//
//  Model.swift
//  SwiftGenKit
//
//  Created by Grant Butler on 7/18/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation
import Kanna

extension CoreData {
  public struct Model {
    public let entities: [String: Entity]
    public let configurations: [String: [Entity]]
    public let fetchRequests: [FetchRequest]
    public let fetchRequestsByEntityName: [String: [FetchRequest]]
  }
}

private enum XML {
  static let entitiesPath = "/model/entity"
  static let configurationsPath = "/model/configuration"
  static let fetchRequestsPath = "/model/fetchRequest"
}

extension CoreData.Model {
  init(with document: Kanna.XMLDocument) throws {
    let allEntities = try document.xpath(XML.entitiesPath).map(CoreData.Entity.init(with:))
    let entitiesByName = Dictionary(allEntities.map { ($0.name, $0) }) { first, _ in first }
    entities = entitiesByName

    configurations = try document.xpath(XML.configurationsPath)
                                .reduce(into: ["Default": allEntities]) { allConfigurations, element in
                                  let (name, entityNames) = try CoreData.Configuration.parse(from: element)
                                  allConfigurations[name] = try entityNames.map { entityName in
                                    guard let entity = entitiesByName[entityName] else {
                                      throw CoreData.ParserError.invalidFormat(reason: "Unnown entity \(entityName).")
                                    }

                                    return entity
                                  }
                                }

    fetchRequests = try document.xpath(XML.fetchRequestsPath).map(CoreData.FetchRequest.init(with:))
    fetchRequestsByEntityName = Dictionary(grouping: fetchRequests) { $0.entity }
  }
}
