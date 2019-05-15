//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import AppKit.NSFont
import CoreText
import Foundation
import PathKit

extension CTFont {
  static func parse(file: Path, relativeTo parent: Path? = nil) -> [Fonts.Font] {
    let descs = CTFontManagerCreateFontDescriptorsFromURL(file.url as CFURL) as NSArray?
    guard let descRefs = (descs as? [CTFontDescriptor]) else { return [] }

    // swiftlint:disable:next closure_body_length
    return descRefs.compactMap { desc -> Fonts.Font? in
      let font = CTFontCreateWithFontDescriptorAndOptions(desc, 0.0, nil, [.preventAutoActivation])
      let postScriptName = CTFontCopyPostScriptName(font) as String
      guard let familyName = CTFontCopyAttribute(font, kCTFontFamilyNameAttribute) as? String,
        let style = CTFontCopyAttribute(font, kCTFontStyleNameAttribute) as? String else { return nil }

      let relPath = parent.flatMap { file.relative(to: $0) } ?? file

      let characterSet = CTFontCopyCharacterSet(font) as CharacterSet
      let cgFont = CTFontCopyGraphicsFont(font, nil)

      let icons: [String: String] = Dictionary(
        uniqueKeysWithValues: characterSet.codePoints.compactMap { unicode -> (String, String)? in
          guard let unicodeScalar = UnicodeScalar(unicode) else { return nil }
          let uniChar = UniChar(unicodeScalar.value)

          var codePoint: [UniChar] = [uniChar]
          var glyphs: [CGGlyph] = [0, 0]

          // Gets the Glyph
          CTFontGetGlyphsForCharacters(font, &codePoint, &glyphs, 1)

          if glyphs.isEmpty {
            return nil
          }

          // Gets the name of the Glyph, to be used as key
          guard let name = cgFont.name(for: glyphs[0]) else {
            print("Failed to get glyph name for: \(unicode)")
            return nil
          }

          let key = String(name)
          let value = String(format: "%X", unicode)
          return (key, value)
        }
      )

      return Fonts.Font(
        filePath: relPath.string,
        familyName: familyName,
        style: style,
        postScriptName: postScriptName,
        icons: icons
      )
    }
  }
}

// From https://stackoverflow.com/a/52133561/486182
extension CharacterSet {
  var codePoints: [Int] {
    var result: [Int] = []
    var plane = 0
    // From https://developer.apple.com/documentation/foundation/nscharacterset/1417719-bitmaprepresentation
    for (idx, char) in bitmapRepresentation.enumerated() {
      let big = idx % 8_193
      if big == 8_192 {
        // plane index byte
        plane = Int(char) << 13
        continue
      }
      let base = (plane + big) << 3
      for check in 0 ..< 8 where char & 1 << check != 0 {
        result.append(base + check)
      }
    }
    return result
  }
}
