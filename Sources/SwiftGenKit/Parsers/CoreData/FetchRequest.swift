//
//  FetchRequest.swift
//  SwiftGenKit
//
//  Created by Grant Butler on 7/23/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation
import Kanna

extension CoreData {
  public final class FetchRequest {
    public let name: String

    public let fetchLimit: Int
    public let fetchBatchSize: Int

    public let predicateString: String
    public let resultType: ResultType

    public let includeSubentities: Bool
    public let includePropertyValues: Bool
    public let includesPendingChanges: Bool
    public let returnsObjectsAsFaults: Bool
    public let returnDistinctResults: Bool

    public let entity: String

    init(
      name: String,
      entity: String,
      fetchLimit: Int,
      fetchBatchSize: Int,
      predicateString: String,
      resultType: ResultType,
      includeSubentities: Bool,
      includePropertyValues: Bool,
      includesPendingChanges: Bool,
      returnsObjectsAsFaults: Bool,
      returnDistinctResults: Bool
    ) {
      self.name = name
      self.entity = entity
      self.fetchLimit = fetchLimit
      self.fetchBatchSize = fetchBatchSize
      self.predicateString = predicateString
      self.resultType = resultType

      self.includeSubentities = includeSubentities
      self.includePropertyValues = includePropertyValues
      self.includesPendingChanges = includesPendingChanges
      self.returnsObjectsAsFaults = returnsObjectsAsFaults
      self.returnDistinctResults = returnDistinctResults
    }

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
  convenience init(with object: Kanna.XMLElement) throws {
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
