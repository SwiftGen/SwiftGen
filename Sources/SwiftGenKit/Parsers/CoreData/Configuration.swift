//
//  Configuration.swift
//  SwiftGenKit
//
//  Created by Grant Butler on 7/23/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation
import Kanna

private enum XML {
  fileprivate enum Attributes {
    static let configurationName = "name"
    static let memberEntityName = "name"
  }

  static let memberEntityPath = "memberEntity"
}

extension CoreData {
  enum Configuration {
    static func parse(from object: Kanna.XMLElement) throws -> (String, [String]) {
      guard let name = object[XML.Attributes.configurationName] else {
        throw CoreData.ParserError.invalidFormat(reason: "Missing required name for configuration.")
      }

      let entityNames = try object.xpath(XML.memberEntityPath).map { element -> String in
        guard let entityName = element[XML.Attributes.memberEntityName] else {
          throw CoreData.ParserError.invalidFormat(reason: "Missing required entity name in configuration.")
        }

        return entityName
      }

      return (name, entityNames)
    }
  }
}
