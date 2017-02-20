//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// Created by Derek Ostrander on 3/7/16.
// MIT License
//

import Foundation
import AppKit.NSFont
import PathKit

// MARK: Font

public struct Font {
  let familyName: String
  let style: String
  let postScriptName: String
  let size: CGFloat

  init(familyName: String, style: String, postScriptName: String) {
    self.familyName = familyName
    self.style = style
    self.postScriptName = postScriptName
	self.size = 0
  }
	
  init(familyName: String, style: String, size: CGFloat) {
	self.familyName = familyName
	self.style = style
	self.postScriptName = ""
	self.size = size
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

  static let fontTagName = "font"
  static let fontNameAttribute = "name"
  static let familyTagName = "family"
  static let styleTagName = "style"
  static let sizeTagName = "size"
	
  public var entries: [String: Set<Font>] = [:]
  public var fonts: [String: Font] = [:]
  private var fontsFileURL: URL?

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
          guard UTTypeConformsTo(uti as CFString, "public.font" as CFString) else {
			
			if file.pathExtension.lowercased() == "xml" {
			  fontsFileURL = file
			}
			
			continue
		  }
			
          let fonts = CTFont.parseFonts(at: file)

          fonts.forEach { addFont($0) }
        }
	}
	
	fontsXMLFileParser()
  }

  private func addFont(_ font: Font) {
    let familyName = font.familyName
    var entry = entries[familyName] ?? []
    entry.insert(font)
    entries[familyName] = entry
  }

  private func fontsXMLFileParser() {
	guard let url = typoURL,
		let parser = XMLParser(contentsOf: url) else { return }
	
	let delegate = ParserDelegate()
	parser.delegate = delegate
	
	if parser.parse()
	{
		typos = delegate.parsedTypo
	}
  }


  private class ParserDelegate: NSObject, XMLParserDelegate {
	var parsedTypo = [String: Font]()
	var currentTypoName: String? = nil
	var currentFamilyName: String? = nil
	var currentStyleName: String? = nil
	var currentSize: CGFloat = 0
	var typoParserError: Error? = nil
		
	@objc func parser(_ parser: XMLParser, didStartElement elementName: String,
	                  namespaceURI: String?, qualifiedName qName: String?,
	                  attributes attributeDict: [String: String]) {
			
	  switch elementName {
		case FontsFileParser.fontTagName:		currentTypoName = attributeDict[FontsFileParser.fontNameAttribute]
		case FontsFileParser.familyTagName:		currentFamilyName = nil
		case FontsFileParser.styleTagName:		currentStyleName = nil
		case FontsFileParser.sizeTagName:		currentSize = 0
		default:								break
	  }
	}
	
	@objc func parser(_ parser: XMLParser, foundCharacters string: String) {
			
	  if currentFamilyName == nil {
		currentFamilyName = string
	  } else if currentStyleName == nil {
		currentStyleName = string
	  } else if currentSize == 0 {
		if let number = NumberFormatter().number(from: string) {
		  currentSize = CGFloat(number)
		}
	  }
	}
	
	@objc func parser(_ parser: XMLParser, didEndElement elementName: String,
	                  namespaceURI: String?, qualifiedName qName: String?) {
			
	  switch elementName {
	    case FontsFileParser.fontTagName:
			guard let typoName = currentTypoName,
				let familyName = currentFamilyName,
				let style = currentStyleName else { return }
				
			let font = Font(familyName: familyName, style: style, size: currentSize)
			parsedTypo[typoName] = font
				
			currentTypoName = nil
			currentFamilyName = nil
			currentStyleName = nil
			currentSize = 0
				
		case FontsFileParser.familyTagName:		break
		case FontsFileParser.styleTagName:		break
		case FontsFileParser.sizeTagName:		break
		default:								break
	  }
	}
  }
}

public enum FontXMLParserError: Error, CustomStringConvertible {
	case invalidFile(reason: String)
	
	public var description: String {
		switch self {
		case .invalidFile(reason: let reason):
			return "error: Unable to parse file. \(reason)"
		}
	}
}

