//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import Kanna

extension CoreData {
  public struct FetchedProperty {
    public let name: String
    public let isOptional: Bool
    public let fetchRequest: FetchRequest
    public let userInfo: [String: Any]
  }
}

private enum XML {
  fileprivate enum Attributes {
    static let name = "name"
    static let isOptional = "optional"
  }

  static let fetchRequestPath = "fetchRequest"
  static let userInfoPath = "userInfo"
}

extension CoreData.FetchedProperty {
  init(with object: Kanna.XMLElement) throws {
    guard let name = object[XML.Attributes.name] else {
      throw CoreData.ParserError.invalidFormat(reason: "Missing required fetched property name.")
    }

    guard let fetchRequest = try object.at_xpath(XML.fetchRequestPath).map(CoreData.FetchRequest.init(with:)) else {
      throw CoreData.ParserError.invalidFormat(reason: "Missing required fetch request")
    }

    let isOptional = object[XML.Attributes.isOptional].flatMap(Bool.init(from:)) ?? false
    let userInfo = try object.at_xpath(XML.userInfoPath).map { try CoreData.UserInfo.parse(from: $0) } ?? [:]

    self.init(name: name, isOptional: isOptional, fetchRequest: fetchRequest, userInfo: userInfo)
  }
}
