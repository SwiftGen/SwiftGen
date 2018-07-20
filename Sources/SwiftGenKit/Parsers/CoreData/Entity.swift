//
//  Entity.swift
//  SwiftGenKit
//
//  Created by Grant Butler on 7/18/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation

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

