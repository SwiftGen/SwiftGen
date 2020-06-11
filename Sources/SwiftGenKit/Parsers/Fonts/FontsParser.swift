//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import AppKit.NSFont
import Foundation
import PathKit

public enum Fonts {
  public enum Option {
    static let codePoints = ParserOption(
      key: "codePoints",
      defaultValue: "false",
      help: "If enabled, will extract code points from the font. Only useful for icon fonts."
    )
  }

  public final class Parser: SwiftGenKit.Parser {
    var entries: [String: Set<Font>] = [:]
    private let options: ParserOptionValues
    public var warningHandler: Parser.MessageHandler?

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) throws {
      self.options = try ParserOptionValues(options: options, available: Parser.allOptions)
      self.warningHandler = warningHandler
    }

    public static let defaultFilter = "[^/]\\.(?i:otf|ttc|ttf)$"
    public static let allOptions: ParserOptionList = [Option.codePoints]

    public func parse(path: Path, relativeTo parent: Path) throws {
      guard let values = try? path.url.resourceValues(forKeys: [.typeIdentifierKey]),
        let uti = values.typeIdentifier else {
        warningHandler?("Unable to determine the Universal Type Identifier for file \(path)", #file, #line)
        return
      }
      guard UTTypeConformsTo(uti as CFString, kUTTypeFont) else {
        warningHandler?("File is not a known font type: \(path)", #file, #line)
        return
      }

      let getCodePoints: Bool = self.options[Option.codePoints] == "true"

      let fonts = CTFont.parse(
        file: path,
        relativeTo: parent,
        extractCodePoints: getCodePoints
      )
      fonts.forEach { addFont($0) }
    }

    private func addFont(_ font: Font) {
      let familyName = font.familyName
      entries[familyName, default: []].insert(font)
    }
  }
}
