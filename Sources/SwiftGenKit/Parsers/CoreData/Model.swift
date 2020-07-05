//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import Kanna

extension CoreData {
  public struct Model {
    public let entities: [String: Entity]
    public let configurations: [String: [String]]
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
    configurations = try CoreData.Configuration.parse(
      from: document.xpath(XML.configurationsPath),
      entityNames: Array(entitiesByName.keys)
    )
    fetchRequests = try document.xpath(XML.fetchRequestsPath).map(CoreData.FetchRequest.init(with:))
    fetchRequestsByEntityName = Dictionary(grouping: fetchRequests) { $0.entity }
  }
}
