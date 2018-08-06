//
//  Entity.swift
//  SwiftGenKit
//
//  Created by Grant Butler on 7/18/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation
import Kanna

extension CoreData {
  public struct Entity {
    public let name: String
    public let className: String
    public let isAbstract: Bool
    public let userInfo: [String: Any]

    let superentity: String?

    public let attributes: [Attribute]
    public let relationships: [Relationship]
    public let fetchedProperties: [FetchedProperty]
  }
}

private enum XML {
  fileprivate enum Attributes {
    static let name = "name"
    static let representedClassName = "representedClassName"
    static let isAbstract = "isAbstract"
    static let superentity = "parentEntity"
  }

  static let attributesPath = "attribute"
  static let relationshipsPath = "relationship"
  static let fetchedPropertiesPath = "fetchedProperty"
  static let userInfoPath = "userInfo"
}

extension CoreData.Entity {
  init(with object: Kanna.XMLElement) throws {
    guard let name = object[XML.Attributes.name] else {
      throw CoreData.ParserError.invalidFormat(reason: "Missing required entity name.")
    }
    let className = object[XML.Attributes.representedClassName] ?? "NSManagedObject"
    let isAbstract = object[XML.Attributes.isAbstract].flatMap(Bool.init(from:)) ?? false
    let superentity = object[XML.Attributes.superentity]

    let attributes = try object.xpath(XML.attributesPath).map(CoreData.Attribute.init(with:))
    let relationships = try object.xpath(XML.relationshipsPath).map(CoreData.Relationship.init(with:))
    let fetchedProperties = try object.xpath(XML.fetchedPropertiesPath).map(CoreData.FetchedProperty.init(with:))

    let userInfo = try object.at_xpath(XML.userInfoPath).map { try CoreData.UserInfo.parse(from: $0) } ?? [:]

    self.init(
      name: name,
      className: className,
      isAbstract: isAbstract,
      userInfo: userInfo,
      superentity: superentity,
      attributes: attributes,
      relationships: relationships,
      fetchedProperties: fetchedProperties
    )
  }
}
