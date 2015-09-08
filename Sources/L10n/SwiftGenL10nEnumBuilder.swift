import Foundation
//@import SwiftIdentifier
//@import SwiftGenIndentation

public final class SwiftGenL10nEnumBuilder {
    public init() {}

    public func addEntry(entry: Entry) {
        parsedLines.append(entry)
    }

    // Localizable.strings files are generally UTF16, not UTF8!
    public func parseLocalizableStringsFile(path: String, encoding: UInt = NSUTF16StringEncoding) throws {
        let fileContent = try NSString(contentsOfFile: path, encoding: encoding)
        let lines = fileContent.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())

        for case let entry? in lines.map(Entry.init) {
            addEntry(entry)
        }
    }
    
    public func build(enumName enumName : String = "L10n", indentation indent : SwiftGenIndentation = .Spaces(4)) -> String {
        var text = "// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen\n\n"
        text += "import Foundation\n\n"
        
        let t = indent.string
        
        text += "enum \(enumName.asSwiftIdentifier()) {\n"
        
        for entry in parsedLines {
            let caseName = entry.key.asSwiftIdentifier(forbiddenChars: "_")
            text += "\(t)case \(caseName)"
            if !entry.types.isEmpty {
                text += "(" + entry.types.map{ $0.rawValue }.joinWithSeparator(", ") + ")"
            }
            text += "\n"
        }
        
        text += "}\n\n"
        
        text += "extension \(enumName.asSwiftIdentifier()) : CustomStringConvertible {\n"
        
        text += "\(t)var description : String { return self.string }\n\n"
        
        text += "\(t)var string : String {\n"
        text += "\(t)\(t)switch self {\n"
        
        for entry in parsedLines {
            let caseName = entry.key.asSwiftIdentifier(forbiddenChars: "_")
            text += "\(t)\(t)\(t)case .\(caseName)"
            if !entry.types.isEmpty {
                let params = (0..<entry.types.count).map { "let p\($0)" }
                text += "(" + params.joinWithSeparator(", ") + ")"
            }
            text += ":\n"
            text += "\(t)\(t)\(t)\(t)return \(enumName).tr(\"\(entry.key)\""
            if !entry.types.isEmpty {
                text += ", "
                let params = (0..<entry.types.count).map { "p\($0)" }
                text += params.joinWithSeparator(", ")
            }
            text += ")\n"
        }
        
        text += "\(t)\(t)}\n"
        text += "\(t)}\n\n"
        
        text += "\(t)private static func tr(key: String, _ args: CVarArgType...) -> String {\n"
        text += "\(t)\(t)let format = NSLocalizedString(key, comment: \"\")\n"
        text += "\(t)\(t)return String(format: format, arguments: args)\n"
        text += "\(t)}\n"
        text += "}\n\n"
        
        text += "func tr(key: \(enumName)) -> String {\n"
        text += "\(t)return key.string\n"
        text += "}\n"
        
        return text
    }
    
    
    
    // MARK: - Public Enum types
    
    public enum PlaceholderType : String {
        case Object = "String"
        case Float = "Float"
        case Int = "Int"
        case Char = "Character"
        case CString = "UnsafePointer<unichar>"
        case Pointer = "UnsafePointer<Void>"
        case Unknown = "Any"
        
        init?(formatChar char: Character) {
            let lcChar = String(char).lowercaseString.characters.first!
            switch lcChar {
            case "@":
                self = .Object
            case "a", "e", "f", "g":
                self = .Float
            case "d", "i", "o", "u", "x":
                self = .Int
            case "c":
                self = .Char
            case "s":
                self = .CString
            case "p":
                self = .Pointer
            default:
                return nil
            }
        }
        
        public static func fromFormatString(format: String) -> [PlaceholderType] {
            return SwiftGenL10nEnumBuilder.typesFromFormatString(format)
        }
    }
    
    public struct Entry {
        let key: String
        let types: [PlaceholderType]
        
        init(key: String, types: [PlaceholderType]) {
            self.key = key
            self.types = types
        }
        
        init(key: String, types: PlaceholderType...) {
            self.key = key
            self.types = types
        }
        
        private static var lineRegEx = {
            return try! NSRegularExpression(pattern: "^\"([^\"]+)\"[ \t]*=[ \t]*\"(.*)\"[ \t]*;", options: [])
        }()
        
        init?(line: String) {
            let range = NSRange(location: 0, length: (line as NSString).length)
            if let match = Entry.lineRegEx.firstMatchInString(line, options: [], range: range) {
                let key = (line as NSString).substringWithRange(match.rangeAtIndex(1))
                
                let translation = (line as NSString).substringWithRange(match.rangeAtIndex(2))
                let types = PlaceholderType.fromFormatString(translation)
                
                self = Entry(key: key, types: types)
            } else {
                return nil
            }
        }
    }
    
    
    
    // MARK: - Private Helpers
    
    private var parsedLines = [Entry]()
    
    // "I give %d apples to %@" --> [.Int, .String]
    private static var formatTypesRegEx : NSRegularExpression = {
        let pattern_int = "(?:h|hh|l|ll|q|z|t|j)?([dioux])" // %d/%i/%o/%u/%x with their optional length modifiers like in "%lld"
        let pattern_float = "[aefg]"
        let position = "([1-9]\\d*\\$)?" // like in "%3$" to make positional specifiers
        let precision = "[-+]?\\d?(?:\\.\\d)?" // precision like in "%1.2f"
        return try! NSRegularExpression(pattern: "(?<!%)%\(position)\(precision)(@|\(pattern_int)|\(pattern_float)|[csp])", options: [.CaseInsensitive])
    }()
    
    private static func typesFromFormatString(formatString: String) -> [PlaceholderType] {
        let range = NSRange(location: 0, length: (formatString as NSString).length)
        
        // Extract the list of chars (conversion specifiers) and their optional positional specifier
        let chars = formatTypesRegEx.matchesInString(formatString, options: [], range: range).map { match -> (String, Int?) in
            let range : NSRange
            if match.rangeAtIndex(3).location != NSNotFound {
                // [dioux] are in range #3 because in #2 there may be length modifiers (like in "lld")
                range = match.rangeAtIndex(3)
            } else {
                // otherwise, no length modifier, the conversion specifier is in #2
                range = match.rangeAtIndex(2)
            }
            let char = (formatString as NSString).substringWithRange(range)
            
            let posRange = match.rangeAtIndex(1)
            if posRange.location == NSNotFound {
                // No positional specifier
                return (char, nil)
            }
            else {
                // Remove the "$" at the end of the positional specifier, and convert to Int
                let posRange1 = NSRange(location: posRange.location, length: posRange.length-1)
                let pos = (formatString as NSString).substringWithRange(posRange1)
                return (char, Int(pos))
            }
        }
        
        // enumerate the conversion specifiers and their optionally forced position and build the array of PlaceholderTypes accordingly
        var list = [PlaceholderType]()
        var nextNonPositional = 1
        for (str, pos) in chars {
            if let char = str.characters.first, let p = PlaceholderType(formatChar: char) {
                let insertionPos = pos ?? nextNonPositional++
                if insertionPos > 0 {
                    while list.count <= insertionPos-1 {
                        list.append(.Unknown)
                    }
                    list[insertionPos-1] = p
                }
            }
        }
        return list
    }
}
