//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// Created by Derek Ostrander on 3/7/16.
// MIT License
//

import AppKit.NSFont
import Foundation
import PathKit

public enum Fonts {
  public final class Parser: SwiftGenKit.Parser {
    var entries: [String: Set<Font>] = [:]
    public var warningHandler: Parser.MessageHandler?

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
      self.warningHandler = warningHandler
    }

    public func parse(path: Path) {
      let dirChildren = path.iterateChildren(options: [.skipsHiddenFiles, .skipsPackageDescendants])
      let parentDir = path.absolute().parent()

      for file in dirChildren {
        var value: AnyObject?
        let url = file.url as NSURL
        try? url.getResourceValue(&value, forKey: URLResourceKey.typeIdentifierKey)
        guard let uti = value as? String else {
          warningHandler?("Unable to determine the Universal Type Identifier for file \(file)", #file, #line)
          continue
        }
        guard UTTypeConformsTo(uti as CFString, "public.font" as CFString) else { continue }
        let fonts = CTFont.parse(file: file, relativeTo: parentDir)
        fonts.forEach { addFont($0) }
      }
    }

    private func addFont(_ font: Font) {
      let familyName = font.familyName

      entries[familyName, default: []].insert(font)
    }
  }
}
