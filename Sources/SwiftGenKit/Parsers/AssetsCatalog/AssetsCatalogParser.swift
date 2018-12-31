//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public enum AssetsCatalog {
  public enum ParserError: Swift.Error, CustomStringConvertible {
    case invalidFile

    public var description: String {
      switch self {
      case .invalidFile:
        return "error: File must be an asset catalog"
      }
    }
  }

  private enum Constants {
    static let `extension` = "xcassets"
  }

  public final class Parser: SwiftGenKit.Parser {
    var catalogs = [Catalog]()
    public var warningHandler: Parser.MessageHandler?

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
      self.warningHandler = warningHandler
    }

    public func parse(path: Path) throws {
      guard path.extension == Constants.extension else {
        throw ParserError.invalidFile
      }

      let catalog = Catalog(path: path)
      catalogs += [catalog]
    }
  }
}
