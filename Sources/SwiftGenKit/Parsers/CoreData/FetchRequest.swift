//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import Kanna

extension CoreData {
  public struct FetchRequest {
    public let name: String
    public let entity: String
    public let fetchLimit: Int
    public let fetchBatchSize: Int
    public let predicateString: String
    public let resultType: ResultType
    public let includeSubentities: Bool
    public let includePropertyValues: Bool
    public let includesPendingChanges: Bool
    public let returnsObjectsAsFaults: Bool
    public let returnDistinctResults: Bool

    public enum ResultType: String {
      case object     = "0"
      case objectID   = "1"
      case dictionary = "2"
    }
  }
}

private enum XML {
  fileprivate enum Attributes {
    static let name = "name"
    static let entity = "entity"
    static let fetchLimit = "fetchLimit"
    static let fetchBatchSize = "fetchBatchSize"
    static let predicateString = "predicateString"
    static let resultType = "resultType"
    static let includeSubentities = "includeSubentities"
    static let includePropertyValues = "includePropertyValues"
    static let includesPendingChanges = "includesPendingChanges"
    static let returnObjectsAsFaults = "returnObjectsAsFaults"
    static let returnDistinctResults = "returnDistinctResults"
  }
}

extension CoreData.FetchRequest {
  init(with object: Kanna.XMLElement) throws {
    guard let name = object[XML.Attributes.name] else {
      throw CoreData.ParserError.invalidFormat(reason: "Missing required fetch request name.")
    }

    guard let entity = object[XML.Attributes.entity] else {
      throw CoreData.ParserError.invalidFormat(reason: "Missing required entity name.")
    }

    let fetchLimit = object[XML.Attributes.fetchLimit].flatMap(Int.init) ?? 0
    let fetchBatchSize = object[XML.Attributes.fetchBatchSize].flatMap(Int.init) ?? 0

    let predicateString = object[XML.Attributes.predicateString] ?? ""
    let resultType = object[XML.Attributes.resultType]
      .flatMap(CoreData.FetchRequest.ResultType.init(rawValue:)) ?? .object

    let includeSubentities = object[XML.Attributes.includeSubentities].flatMap(Bool.init(from:)) ?? true
    let includePropertyValues = object[XML.Attributes.includePropertyValues].flatMap(Bool.init(from:)) ?? true
    let includesPendingChanges = object[XML.Attributes.includesPendingChanges].flatMap(Bool.init(from:)) ?? true
    let returnObjectsAsFaults = object[XML.Attributes.returnObjectsAsFaults].flatMap(Bool.init(from:)) ?? true
    let returnDistinctResults = object[XML.Attributes.returnDistinctResults].flatMap(Bool.init(from:)) ?? false

    self.init(
      name: name,
      entity: entity,
      fetchLimit: fetchLimit,
      fetchBatchSize: fetchBatchSize,
      predicateString: predicateString,
      resultType: resultType,
      includeSubentities: includeSubentities,
      includePropertyValues: includePropertyValues,
      includesPendingChanges: includesPendingChanges,
      returnsObjectsAsFaults: returnObjectsAsFaults,
      returnDistinctResults: returnDistinctResults
    )
  }
}
