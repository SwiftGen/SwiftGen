//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public enum AssetsCatalogParserError: Swift.Error, CustomStringConvertible {
  case invalidFile

  public var description: String {
    switch self {
    case .invalidFile:
      return "error: File must be an asset catalog"
    }
  }
}

private enum AssetCatalog {
  static let `extension` = "xcassets"
}

public final class AssetsCatalogParser: Parser {
  var catalogs = [Catalog]()
  public var warningHandler: Parser.MessageHandler?

  public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
    self.warningHandler = warningHandler
  }

  public func parse(path: Path) throws {
    guard path.extension == AssetCatalog.extension else {
      throw AssetsCatalogParserError.invalidFile
    }

    let catalog = Catalog(path: path)
    catalogs += [catalog]
  }
}
