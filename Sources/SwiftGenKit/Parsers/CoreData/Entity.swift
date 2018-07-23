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
  public final class Entity {
    public let name: String
    public let className: String
    public let isAbstract: Bool
    public let userInfo: [String: String]

    let superentityName: String?

    public internal(set) var superentity: Entity?
    public let attributes: [Attribute]
    public internal(set) var relationships: [Relationship]

    init(
      name: String,
      className: String,
      isAbstract: Bool,
      superentityName: String?,
      attributes: [Attribute],
      relationships: [Relationship],
      userInfo: [String: String]
    ) {
      self.name = name
      self.className = className
      self.isAbstract = isAbstract
      self.superentityName = superentityName
      self.superentity = nil
      self.attributes = attributes
      self.relationships = relationships
      self.userInfo = userInfo
    }
  }
}

private enum XML {
  fileprivate enum Attributes {
    static let name = "name"
    static let representedClassName = "representedClassName"
    static let isAbstract = "isAbstract"
    static let superentityName = "parentEntity"
  }

  static let attributesPath = "attribute"
  static let relationshipsPath = "relationship"
  static let userInfoPath = "userInfo"
}

extension CoreData.Entity {
  convenience init(with object: Kanna.XMLElement) throws {
    guard let name = object[XML.Attributes.name] else {
      throw CoreData.ParserError.invalidFormat(reason: "Missing required entity name.")
    }
    let className = object[XML.Attributes.representedClassName] ?? "NSManagedObject"
    let isAbstract = object[XML.Attributes.isAbstract].flatMap(Bool.init(from:)) ?? false
    let superentityName = object[XML.Attributes.superentityName]

    let attributes = try object.xpath(XML.attributesPath).map(CoreData.Attribute.init(with:))
    let relationships = try object.xpath(XML.relationshipsPath).map(CoreData.Relationship.init(with:))

    let userInfo = try object.at_xpath(XML.userInfoPath).map { try CoreData.UserInfo.parse(from: $0) } ?? [:]

    self.init(
      name: name,
      className: className,
      isAbstract: isAbstract,
      superentityName: superentityName,
      attributes: attributes,
      relationships: relationships,
      userInfo: userInfo
    )
  }
}
