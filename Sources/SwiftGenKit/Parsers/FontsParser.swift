//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// Created by Derek Ostrander on 3/7/16.
// MIT License
//

import AppKit.NSFont
import Foundation
import PathKit

// MARK: Font

public struct Font {
  let filePath: String
  let familyName: String
  let style: String
  let postScriptName: String

  init(filePath: String, familyName: String, style: String, postScriptName: String) {
    self.filePath = filePath
    self.familyName = familyName
    self.style = style
    self.postScriptName = postScriptName
  }
}

// Right now the postScriptName is the value of the font we are looking up, so we do
// equatable comparisons on that. If we ever care about the familyName or style it can be added
extension Font: Hashable {
  public var hashValue: Int { return postScriptName.hashValue }
}

public func == (lhs: Font, rhs: Font) -> Bool {
  return lhs.postScriptName == rhs.postScriptName
}

extension PathKit.Path {
  /// Returns the Path relative to a parent directory.
  /// If the argument passed as parent isn't a prefix of `self`, returns `nil`.
  ///
  /// - Parameter parent: The parent Path to get the relative path against
  /// - Returns: The relative Path, or nil if parent was not a parent dir of self
  func relative(to parent: Path) -> Path? {
    let pc = parent.absolute().components
    let fc = self.absolute().components
    return fc.starts(with: pc) ? Path(components: fc.dropFirst(pc.count)) : nil
  }
}

// MARK: CTFont

extension CTFont {
  static func parse(file: Path, relativeTo parent: Path? = nil) -> [Font] {
    let descs = CTFontManagerCreateFontDescriptorsFromURL(file.url as CFURL) as NSArray?
    guard let descRefs = (descs as? [CTFontDescriptor]) else { return [] }

    return descRefs.flatMap { desc -> Font? in
      let font = CTFontCreateWithFontDescriptorAndOptions(desc, 0.0, nil, [.preventAutoActivation])
      let postScriptName = CTFontCopyPostScriptName(font) as String
      guard let familyName = CTFontCopyAttribute(font, kCTFontFamilyNameAttribute) as? String,
        let style = CTFontCopyAttribute(font, kCTFontStyleNameAttribute) as? String else { return nil }

      let relPath = parent.flatMap { file.relative(to: $0) } ?? file
      return Font(
        filePath: relPath.string,
        familyName: familyName,
        style: style,
        postScriptName: postScriptName
      )
    }
  }
}

// MARK: FontsFileParser

public final class FontsParser: Parser {
  var entries: [String: Set<Font>] = [:]
  public var warningHandler: Parser.MessageHandler?

  public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
    self.warningHandler = warningHandler
  }

  public func parse(path: Path) {
    let dirChildren = path.iterateChildren(options: [.skipsHiddenFiles, .skipsPackageDescendants])
    let parentDir = path.absolute().parent()

    for file in dirChildren {
      var value: AnyObject? = nil
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
    var entry = entries[familyName] ?? []
    entry.insert(font)
    entries[familyName] = entry
  }
}
