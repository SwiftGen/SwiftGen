//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// Created by Derek Ostrander on 3/7/16.
// MIT License
//

import AppKit.NSFont
import Foundation
import PathKit

extension PathKit.Path {
  /// Returns the Path relative to a parent directory.
  /// If the argument passed as parent isn't a prefix of `self`, returns `nil`.
  ///
  /// - Parameter parent: The parent Path to get the relative path against
  /// - Returns: The relative Path, or nil if parent was not a parent dir of self
  func relative(to parent: Path) -> Path? {
    let parentComponents = parent.absolute().components
    let currentComponents = self.absolute().components
    return currentComponents.starts(with: parentComponents)
      ? Path(components: currentComponents.dropFirst(parentComponents.count)) : nil
  }
}

extension CTFont {
  static func parse(file: Path, relativeTo parent: Path? = nil) -> [Font] {
    let descs = CTFontManagerCreateFontDescriptorsFromURL(file.url as CFURL) as NSArray?
    guard let descRefs = (descs as? [CTFontDescriptor]) else { return [] }

    return descRefs.compactMap { desc -> Font? in
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
