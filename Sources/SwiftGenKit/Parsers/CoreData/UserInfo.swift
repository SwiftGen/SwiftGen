//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import Kanna

private enum XML {
  fileprivate enum Attributes {
    static let key = "key"
    static let value = "value"
  }

  static let entriesPath = "entry"
}

extension CoreData {
  enum UserInfo {
    static func parse(from object: Kanna.XMLElement) throws -> [String: Any] {
      try object.xpath(XML.entriesPath).reduce(into: [:]) { userInfo, element in
        guard let key = element[XML.Attributes.key] else {
          throw CoreData.ParserError.invalidFormat(reason: "Missing required 'key' attribute in user info.")
        }

        guard let value = element[XML.Attributes.value] else {
          throw CoreData.ParserError.invalidFormat(reason: "Missing required 'value' attribute in user info.")
        }

        userInfo[key] = Int(value) ?? Double(value) ?? Bool(from: value) ?? value
      }
    }
  }
}
