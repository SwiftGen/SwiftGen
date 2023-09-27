//
// SwiftGenKit
// Copyright © 2022 SwiftGen
// MIT Licence
//

import AppKit.NSFont
import Foundation
import PathKit

public enum Fonts {
  public final class Parser: SwiftGenKit.Parser {
    var entries: [String: Set<Font>] = [:]
    private let options: ParserOptionValues
    public var warningHandler: Parser.MessageHandler?

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) throws {
      self.options = try ParserOptionValues(options: options, available: Self.allOptions)
      self.warningHandler = warningHandler
    }

    public static let defaultFilter = filterRegex(forExtensions: ["otf", "ttc", "ttf"])

    public func parse(path: Path, relativeTo parent: Path) throws {
      guard checkIsFont(path: path) else {
        warningHandler?("File is not a known font type: \(path)", #file, #line)
        return
      }

      let fonts = CTFont.parse(file: path, relativeTo: parent)
      fonts.forEach { addFont($0) }
    }
  }
}

// MARK: - Helpers

private extension Data {
    var isTrueTypeFont: Bool {
        let trueTypeFontHeaderBytes: [UInt8] = [0x00, 0x01, 0x00, 0x00, 0x00] // https://en.wikipedia.org/wiki/List_of_file_signatures
        var values = [UInt8](repeating: 0, count: trueTypeFontHeaderBytes.count)
        self.copyBytes(to: &values, count: trueTypeFontHeaderBytes.count)
        return values == trueTypeFontHeaderBytes
    }

    var isOpenTypeFont: Bool {
        let openTypeFontHeaderBytes: [UInt8] = [0x4F, 0x54, 0x54, 0x4F] // https://en.wikipedia.org/wiki/List_of_file_signatures
        var values = [UInt8](repeating: 0, count: openTypeFontHeaderBytes.count)
        self.copyBytes(to: &values, count: openTypeFontHeaderBytes.count)
        return values == openTypeFontHeaderBytes
    }
}

private extension Fonts.Parser {
  /// Try to quickly check if the given file is an actual font file.
  ///
  /// - Note: This can seemingly fail in sandboxed environments.
  func checkIsFont(path: Path) -> Bool {
    do {
      let values = try path.url.resourceValues(forKeys: [.typeIdentifierKey])
      guard let uti = values.typeIdentifier else {
        return true
      }
      return UTTypeConformsTo(uti as CFString, kUTTypeFont)
    } catch {
      if let handle = try? FileHandle(forReadingFrom: path.url) {
        defer { handle.closeFile() }
        let fileHeaderData = handle.readData(ofLength: 5)
        if fileHeaderData.isTrueTypeFont || fileHeaderData.isOpenTypeFont {
          return true
        }
      }
      warningHandler?("Unable to determine the Universal Type Identifier for file \(path) : \(error)", #file, #line)
      return true
    }
  }

  func addFont(_ font: Fonts.Font) {
    let familyName = font.familyName
    entries[familyName, default: []].insert(font)
  }
}
