//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
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
    public let shouldGenerateCode: Bool
  }
}

private enum XML {
  fileprivate enum Attributes {
    static let name = "name"
    static let representedClassName = "representedClassName"
    static let isAbstract = "isAbstract"
    static let superEntity = "parentEntity"
    static let codeGenerationType = "codeGenerationType"
  }
  fileprivate enum Values {
    static let categoryCodeGeneration = "category"
    static let classCodeGeneration = "class"
  }

  static let attributesPath = "attribute"
  static let relationshipsPath = "relationship"
  static let fetchedPropertiesPath = "fetchedProperty"
  static let userInfoPath = "userInfo"
  static let uniquenessConstraintsPath = "uniquenessConstraints"
}

extension CoreData.Entity {
  init(with object: Kanna.XMLElement) throws {
    guard let name = object[XML.Attributes.name] else {
      throw CoreData.ParserError.invalidFormat(reason: "Missing required entity name.")
    }

    // The module and the class name are stored in the same field, separated by a '.'. If the user chooses
    // "current product module", the field is prefixed with a '.'. We actually do not want the module part of the type,
    // so we need to remove it.
    let classComponents = (object[XML.Attributes.representedClassName] ?? "").components(separatedBy: ".")
    let className: String
    if classComponents.count > 1 {
      className = classComponents.dropFirst().joined(separator: ".")
    } else {
      className = classComponents.joined(separator: ".")
    }

    let isAbstract = object[XML.Attributes.isAbstract].flatMap(Bool.init(from:)) ?? false
    let superEntity = object[XML.Attributes.superEntity]
    let shouldGenerateCode = object[XML.Attributes.codeGenerationType].map {
      $0 != XML.Values.categoryCodeGeneration && $0 != XML.Values.classCodeGeneration
    } ?? true

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
      uniquenessConstraints: uniquenessConstraints,
      shouldGenerateCode: shouldGenerateCode
    )
  }
}
