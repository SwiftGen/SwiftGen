//
//  FontsFileParser.swift
//  Pods
//
//  Created by Derek Ostrander on 3/7/16.
//
//

import Foundation
import AppKit.NSFont

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

public func ==(lhs: Font, rhs: Font) -> Bool {
  return lhs.postScriptName == rhs.postScriptName
}

// MARK: CFString

extension CFString {
  var alphanumericString: String {
    return (self as String).componentsSeparatedByCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet).joinWithSeparator("")
  }
}

// MARK: CTFont

extension CTFont {
  static func parseFontInfo(fileURL: NSURL) -> Font? {
    let descs = CTFontManagerCreateFontDescriptorsFromURL(fileURL) as NSArray?
    guard let desc = (descs as? [CTFontDescriptorRef])?.first else { return nil }

    let font = CTFontCreateWithFontDescriptorAndOptions(desc, 0.0, nil, [.PreventAutoActivation])
    let postScriptName = CTFontCopyPostScriptName(font) as String
    guard let familyName = CTFontCopyAttribute(font, kCTFontFamilyNameAttribute) as? String,
      let style = CTFontCopyAttribute(font, kCTFontStyleNameAttribute) as? String else { return nil }
    
    return Font(familyName: familyName, style: style, postScriptName: postScriptName)
  }
}

// MARK: FontsFileParser

public final class FontsFileParser {
  public var entries: [String: Set<Font>] = [:]

  public init() {}

  public func parseFonts(path: String) {
    let url = NSURL(fileURLWithPath: path)
    if let dirEnum = NSFileManager.defaultManager().enumeratorAtURL(url,
      includingPropertiesForKeys: [],
      options: [.SkipsHiddenFiles, .SkipsPackageDescendants],
      errorHandler: nil) {
        var value: AnyObject? = nil
        while let file = dirEnum.nextObject() as? NSURL {
          guard let _ = try? file.getResourceValue(&value, forKey: NSURLTypeIdentifierKey),
          let uti = value as? String else {
            print("Unable to determine the Universal Type Identifier for file \(file)")
            continue
          }
          guard UTTypeConformsTo(uti, "public.font") else { continue }
          guard let font = CTFont.parseFontInfo(file) else { continue }

          addFont(font)
        }
    }
  }
}

// MARK: FontsFileParser - Entry Managment

private extension FontsFileParser {
  func addFont(font: Font) {
    let familyName = font.familyName
    if let _ = entries[familyName]
    {
      entries[familyName]!.insert(font)
    }
    else {
      entries[familyName] = [font]
    }
  }
}
