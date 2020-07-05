//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import AppKit.NSFont
import Foundation
import PathKit

extension CTFont {
  static func parse(file: Path, relativeTo parent: Path? = nil) -> [Fonts.Font] {
    let descs = CTFontManagerCreateFontDescriptorsFromURL(file.url as CFURL) as NSArray?
    guard let descRefs = (descs as? [CTFontDescriptor]) else { return [] }

    return descRefs.compactMap { desc -> Fonts.Font? in
      let font = CTFontCreateWithFontDescriptorAndOptions(desc, 0.0, nil, [.preventAutoActivation])
      let postScriptName = CTFontCopyPostScriptName(font) as String
      guard let familyName = CTFontCopyAttribute(font, kCTFontFamilyNameAttribute) as? String,
        let style = CTFontCopyAttribute(font, kCTFontStyleNameAttribute) as? String else { return nil }

      let relPath = parent.flatMap { file.relative(to: $0) } ?? file
      return Fonts.Font(
        filePath: relPath.string,
        familyName: familyName,
        style: style,
        postScriptName: postScriptName
      )
    }
  }
}
