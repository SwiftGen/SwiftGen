//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
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
    static let defaultName = "Default"

    static func parse(from objects: XPathObject, entityNames: [String]) throws -> [String: [String]] {
      let defaultConfiguration = [CoreData.Configuration.defaultName: entityNames]

      return try objects.reduce(into: defaultConfiguration) { allConfigurations, element in
        let (name, entityNames) = try CoreData.Configuration.parse(from: element)
        allConfigurations[name] = entityNames
      }
    }

    private static func parse(from object: Kanna.XMLElement) throws -> (String, [String]) {
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
