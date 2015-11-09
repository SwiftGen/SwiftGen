//
// GenumKit
// Copyright (c) 2015 Josep Rodriguez
// MIT Licence
//

import Foundation

public typealias Font = (fontName:String,fontSize:Int)

public enum FontFileParserError: ErrorType {
	
	/// Thrown when the path specified contains no data.
	case NoSuchFile

	/// A required parameter was not specified
	case MissingParameter(String)
}

public final class FontFileParser {
	
	var fonts = [String:Font]()
	
	public init() {}
	
	public func addFontWithName(name: String, value: Font) {
		fonts[name] = value
	}
	
	/// Text file expected to be in plist format, containg an array of dictionaries
	/// with the following keys:
	///  - Key
	///  - FontName
	///  - FontSize
	public func parseTextFile(path: String, separator: String = ":") throws {
		guard let fonts = NSArray(contentsOfFile: path) as? [[String:AnyObject]] else {
			throw FontFileParserError.NoSuchFile
		}

		for font in fonts {
			guard let key = font["Key"] as? String else
			{
				throw FontFileParserError.MissingParameter("Key")
			}
			guard let fontName = font["FontName"] as? String else
			{
				throw FontFileParserError.MissingParameter("FontName")
			}
			guard let fontSize = font["FontSize"] as? Int else {
				throw FontFileParserError.MissingParameter("FontSize")
			}
			
			addFontWithName(key, value: (fontName:fontName, fontSize:fontSize))
		}
		
	}
}

