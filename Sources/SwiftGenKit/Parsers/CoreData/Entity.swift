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
      relationships: [Relationship]
    ) {
      self.name = name
      self.className = className
      self.isAbstract = isAbstract
      self.superentityName = superentityName
      self.superentity = nil
      self.attributes = attributes
      self.relationships = relationships
    }
  }
}

private enum XML {
  static let nameAttribute = "name"
  static let representedClassNameAttribute = "representedClassName"
  static let isAbstractAttribute = "isAbstract"
  static let superentityNameAttribute = "parentEntity"

  static let attributesPath = "attribute"
  static let relationshipsPath = "relationship"
}

extension CoreData.Entity {
  convenience init(with object: Kanna.XMLElement) throws {
    let name = object[XML.nameAttribute] ?? ""
    let className = object[XML.representedClassNameAttribute] ?? "NSManagedObject"
    let isAbstract = object[XML.isAbstractAttribute].flatMap(Bool.init(from:)) ?? false
    let superentityName = object[XML.superentityNameAttribute]

    let attributes = try object.xpath(XML.attributesPath).map(CoreData.Attribute.init(with:))
    let relationships = try object.xpath(XML.relationshipsPath).map(CoreData.Relationship.init(with:))

    self.init(
      name: name,
      className: className,
      isAbstract: isAbstract,
      superentityName: superentityName,
      attributes: attributes,
      relationships: relationships
    )
  }
}
