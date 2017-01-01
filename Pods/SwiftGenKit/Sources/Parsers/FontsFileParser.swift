//
//  SwiftGen
//  Created by Derek Ostrander on 3/7/16.
//  Copyright (c) 2015 Olivier Halligon
//  MIT License
//

import Foundation
import AppKit.NSFont
import PathKit

// MARK: Font

public struct Font {
  let familyName: String
  let style: String
  let postScriptName: String

  init(familyName: String, style: String, postScriptName: String) {
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

// MARK: CTFont

extension CTFont {
  static func parseFonts(at url: URL) -> [Font] {
    let descs = CTFontManagerCreateFontDescriptorsFromURL(url as CFURL) as NSArray?
    guard let descRefs = (descs as? [CTFontDescriptor]) else { return [] }

    return descRefs.flatMap { (desc) -> Font? in
      let font = CTFontCreateWithFontDescriptorAndOptions(desc, 0.0, nil, [.preventAutoActivation])
      let postScriptName = CTFontCopyPostScriptName(font) as String
      guard let familyName = CTFontCopyAttribute(font, kCTFontFamilyNameAttribute) as? String,
        let style = CTFontCopyAttribute(font, kCTFontStyleNameAttribute) as? String else { return nil }

      return Font(familyName: familyName, style: style, postScriptName: postScriptName)
    }
  }
}

// MARK: FontsFileParser

public final class FontsFileParser {
  public var entries: [String: Set<Font>] = [:]

  public init() {}

  public func parseFile(at path: Path) {
    // PathKit does not support support enumeration with options yet
    // see: https://github.com/kylef/PathKit/pull/25
    let url = URL(fileURLWithPath: path.description)

    if let dirEnum = FileManager.default.enumerator(at: url,
      includingPropertiesForKeys: [],
      options: [.skipsHiddenFiles, .skipsPackageDescendants],
      errorHandler: nil) {
        var value: AnyObject? = nil
        while let file = dirEnum.nextObject() as? URL {
          guard let _ = try? (file as NSURL).getResourceValue(&value, forKey: URLResourceKey.typeIdentifierKey),
          let uti = value as? String else {
            print("Unable to determine the Universal Type Identifier for file \(file)")
            continue
          }
          guard UTTypeConformsTo(uti as CFString, "public.font" as CFString) else { continue }
          let fonts = CTFont.parseFonts(at: file)

          fonts.forEach { addFont($0) }
        }
    }
  }

  private func addFont(_ font: Font) {
    let familyName = font.familyName
    var entry = entries[familyName] ?? []
    entry.insert(font)
    entries[familyName] = entry
  }
}
