//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public enum AssetsCatalog {
  public final class Parser: SwiftGenKit.Parser {
    var catalogs = [Catalog]()
    private let options: ParserOptionValues
    public var warningHandler: Parser.MessageHandler?

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) throws {
      self.options = try ParserOptionValues(options: options, available: Parser.allOptions)
      self.warningHandler = warningHandler
    }

    public static let defaultFilter = "[^/]\\.xcassets$"

    public func parse(path: Path, relativeTo parent: Path) throws {
      let catalog = Catalog(path: path)
      catalogs += [catalog]
    }
  }
}
