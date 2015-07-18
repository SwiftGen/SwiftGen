import Foundation
//@import SwiftIdentifier
//@import SwiftGenIndentation

public class SwiftGenL10nEnumBuilder {
    public init() {}

    // Localizable.strings files are generally UTF16, not UTF8!
    public func parseLocalizableStringsFile(path: String, encoding: UInt = NSUTF16StringEncoding) throws {
        let fileContent = try NSString(contentsOfFile: path, encoding: encoding)
        let lines = fileContent.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())

        for case let entry? in lines.map(Entry.init) {
            addEntry(entry)
        }
    }
    
    public func addEntry(entry: Entry) {
        parsedLines.append(entry)
    }
    
    public func build(enumName enumName : String = "L10n", indentation indent : SwiftGenIndentation = .Spaces(4)) -> String {
        var enumText = "// AUTO-GENERATED FILE, DO NOT EDIT\n\n"
        let t = indent.string
        
        enumText += "enum \(enumName.asSwiftIdentifier()) {\n"
        
        for entry in parsedLines {
            let caseName = entry.key.asSwiftIdentifier(forbiddenChars: "_")
            enumText += "\(t)case \(caseName)"
            if !entry.types.isEmpty {
                enumText += "(" + ", ".join(entry.types.map{ $0.rawValue }) + ")"
            }
            enumText += "\n"
        }
        
        enumText += "}\n\n"
        
        enumText += "extension \(enumName.asSwiftIdentifier()) : CustomStringConvertible {\n"
        
        enumText += "\(t)var description : String { return self.string }\n\n"
        
        enumText += "\(t)var string : String {\n"
        enumText += "\(t)\(t)switch self {\n"
        
        for entry in parsedLines {
            let caseName = entry.key.asSwiftIdentifier(forbiddenChars: "_")
            enumText += "\(t)\(t)\(t)case .\(caseName)"
            if !entry.types.isEmpty {
                let params = (0..<entry.types.count).map { "let p\($0)" }
                enumText += "(" + ", ".join(params) + ")"
            }
            enumText += ":\n"
            enumText += "\(t)\(t)\(t)\(t)return \(enumName).tr(\"\(entry.key)\""
            if !entry.types.isEmpty {
                enumText += ", "
                let params = (0..<entry.types.count).map { "p\($0)" }
                enumText += ", ".join(params)
            }
            enumText += ")\n"
        }
        
        enumText += "\(t)\(t)}\n"
        enumText += "\(t)}\n\n"
        
        enumText += "\(t)private static func tr(key: String, _ args: CVarArgType...) -> String {\n"
        enumText += "\(t)\(t)let format = NSLocalizedString(key, comment: \"\")\n"
        enumText += "\(t)\(t)return String(format: format, arguments: args)\n"
        enumText += "\(t)}\n"
        enumText += "}\n\n"
        
        enumText += "func tr(key: \(enumName)) -> String {\n"
        enumText += "\(t)return key.string\n"
        enumText += "}\n"
        
        return enumText
    }
    
    
    
    // MARK: - Public Enum types
    
    public enum PlaceholderType : String {
        case String
        case Float
        case Int
        
        init?(formatChar char: Character) {
            switch char {
            case "@":
                self = .String
            case "f":
                self = .Float
            case "d", "i", "u":
                self = .Int
            default:
                return nil
            }
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
        
        private static var regex = {
            return try! NSRegularExpression(pattern: "^\"([^\"]+)\"[ \t]*=[ \t]*\"(.*)\"[ \t]*;", options: [])
        }()
        
        init?(line: String) {
            let range = NSRange(location: 0, length: (line as NSString).length)
            if let match = Entry.regex.firstMatchInString(line, options: [], range: range) {
                let key = (line as NSString).substringWithRange(match.rangeAtIndex(1))
                
                let translation = (line as NSString).substringWithRange(match.rangeAtIndex(2))
                let types = SwiftGenL10nEnumBuilder.typesFromFormatString(translation)
                
                self = Entry(key: key, types: types)
            } else {
                return nil
            }
        }
    }
    
    
    
    // MARK: - Private Helpers
    
    private var parsedLines = [Entry]()
    
    // "I give %d apples to %@" --> [.Int, .String]
    private static func typesFromFormatString(formatString: String) -> [PlaceholderType] {
        var types = [PlaceholderType]()
        var placeholderIndex: Int? = nil
        var lastPlaceholderIndex = 0
        
        for char in formatString.characters {
            if char == "%" {
                // TODO: Manage the "%%" special sequence
                placeholderIndex = lastPlaceholderIndex++
            }
            else if placeholderIndex != nil {
                // TODO: Manage positional placeholders like "%2$@"
                //       That change the order the placeholder should be inserted in the types array
                //        (If types.count+1 < placehlderIndex, we'll need to insert "Any" types to fill the gap)
                if let type = PlaceholderType(formatChar: char) {
                    types.append(type)
                    placeholderIndex = nil
                }
                else if char == "%" {
                    // Treat it as "%%"
                    // FIXME: This case will also be executed with strings like "%--%"
                    //        Better add some more security during that parsing later
                    placeholderIndex = nil
                }
            }
        }
        
        return types
    }
}


