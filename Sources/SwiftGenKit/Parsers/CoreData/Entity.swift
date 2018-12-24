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
    public let superEntity: String?
    public let attributes: [Attribute]
    public let relationships: [Relationship]
    public let fetchedProperties: [FetchedProperty]
    public let uniquenessConstraints: [[String]]
  }
}

private enum XML {
  fileprivate enum Attributes {
    static let name = "name"
    static let representedClassName = "representedClassName"
    static let isAbstract = "isAbstract"
    static let superEntity = "parentEntity"
  }

  static let attributesPath = "attribute"
  static let relationshipsPath = "relationship"
  static let fetchedPropertiesPath = "fetchedProperty"
  static let userInfoPath = "userInfo"
  static let uniquenessConstraintsPath = "uniquenessConstraints"
}

extension CoreData.Entity {
  static let defaultClassName = "NSManagedObject"

  init(with object: Kanna.XMLElement) throws {
    guard let name = object[XML.Attributes.name] else {
      throw CoreData.ParserError.invalidFormat(reason: "Missing required entity name.")
    }

    let className = object[XML.Attributes.representedClassName] ?? CoreData.Entity.defaultClassName
    let isAbstract = object[XML.Attributes.isAbstract].flatMap(Bool.init(from:)) ?? false
    let superEntity = object[XML.Attributes.superEntity]

    let attributes = try object.xpath(XML.attributesPath).map(CoreData.Attribute.init(with:))
    let relationships = try object.xpath(XML.relationshipsPath).map(CoreData.Relationship.init(with:))
    let fetchedProperties = try object.xpath(XML.fetchedPropertiesPath).map(CoreData.FetchedProperty.init(with:))

    let userInfo = try object.at_xpath(XML.userInfoPath).map { try CoreData.UserInfo.parse(from: $0) } ?? [:]
    let uniquenessConstraints = try object.at_xpath(XML.uniquenessConstraintsPath).map {
      try CoreData.UniquenessConstraints.parse(from: $0)
    } ?? []

    self.init(
      name: name,
      className: className,
      isAbstract: isAbstract,
      userInfo: userInfo,
      superEntity: superEntity,
      attributes: attributes,
      relationships: relationships,
      fetchedProperties: fetchedProperties,
      uniquenessConstraints: uniquenessConstraints
    )
  }
}
