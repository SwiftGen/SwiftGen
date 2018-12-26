//
//  UniquenessConstraints.swift
//  SwiftGenKit
//
//  Created by Grant Butler on 8/6/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation
import Kanna

private enum XML {
  fileprivate enum Attributes {
    static let value = "value"
  }

  static let uniquenessConstraintPath = "uniquenessConstraint"
  static let constraintPath = "constraint"
}

extension CoreData {
  public enum UniquenessConstraints {
    public static func parse(from object: Kanna.XMLElement) throws -> [[String]] {
      return try object.xpath(XML.uniquenessConstraintPath).map { uniquenessConstraintElement in
        try uniquenessConstraintElement.xpath(XML.constraintPath).map {
          guard let value = $0[XML.Attributes.value] else {
            throw CoreData.ParserError.invalidFormat(reason: "Missing required uniqueness constraint value")
          }

          return value
        }
      }
    }
  }
}
