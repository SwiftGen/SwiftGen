import Foundation

public class SwiftGenL10nEnumBuilder {

    private enum PlaceholderType : String {
        case String
        case Float
        case Int
        
        static func fromFormatChar(char: Character) -> PlaceholderType? {
            switch char {
            case "@":
                return .String
            case "f":
                return .Float
            case "d", "i", "u":
                return .Int
            default: return nil
            }
        }
    }

    // "I give %d apples to %@" --> [.Int, .String]
    private func typesFromFormatString(formatString: String) -> [PlaceholderType] {
        var types = [PlaceholderType]()
        var placeholderIndex: Int? = nil
        var lastPlaceholderIndex = 0
        
        for char in formatString.characters {
            if char == Character("%") {
                // TODO: Manage the "%%" special sequence
                placeholderIndex = lastPlaceholderIndex++
            }
            else if placeholderIndex != nil {
                // TODO: Manage positional placeholders like "%2$@"
                //       That change the order the placeholder should be inserted in the types array
                //        (If types.count+1 < placehlderIndex, we'll need to insert "Any" types to fill the gap)
                if let type = PlaceholderType.fromFormatChar(char) {
                    types.append(type)
                    placeholderIndex = nil
                }
            }
        }
        
        return types
    }
    
    private typealias ParsedLine = (key: String, types: [PlaceholderType])
    private var parsedLines = [ParsedLine]()

    private func parseLine(line: String) -> ParsedLine? {
        let range = NSRange(location: 0, length: line.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let regex = try! NSRegularExpression(pattern: "^\"([^\"]*)\" *= *\"(.*)\";", options: [])
        if let match = regex.firstMatchInString(line, options: [], range: range) {
            
            let key = (line as NSString).substringWithRange(match.rangeAtIndex(1))
            
            let translation = (line as NSString).substringWithRange(match.rangeAtIndex(2))
            let types = typesFromFormatString(translation)
            
            return (key, types)
        }
        return nil
    }

    
    // Public interface
    
    public init() {}

    public func addLine(line: String) -> Bool {
        if let parsed = parseLine(line) {
            parsedLines.append(parsed)
            return true
        }
        return false
    }
    
    public func parseLocalizableStringsFile(path: String) throws {
        let fileContent = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        let lines = fileContent.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        for line in lines {
            addLine(line)
        }
    }
    
    public func build(enumName : String = "L10n") -> String {
        var enumText = "// AUTO-GENERATED FILE, DO NOT EDIT\n\n"
        
        enumText += "enum \(enumName.asSwiftIdentifier()) {\n"
        
        for (key, types) in parsedLines {
            let caseName = key.asSwiftIdentifier(forbiddenChars: "_")
            enumText += "\tcase \(caseName)"
            if !types.isEmpty {
                enumText += "(" + ", ".join(types.map{ $0.rawValue }) + ")"
            }
            enumText += "\n"
        }
        
        enumText += "}\n\n"
        
        enumText += "extension \(enumName.asSwiftIdentifier()) : CustomStringConvertible {\n"
        
        enumText += "\tvar description : String { return self.string }\n\n"
        
        enumText += "\tvar string : String {\n"
        enumText += "\t\tswitch self {\n"
        
        for (key, types) in parsedLines {
            let caseName = key.asSwiftIdentifier(forbiddenChars: "_")
            enumText += "\t\t\tcase .\(caseName)"
            if !types.isEmpty {
                let params = (0..<types.count).map { "let p\($0)" }
                enumText += "(" + ", ".join(params) + ")"
            }
            enumText += ":\n"
            enumText += "\t\t\t\treturn L10n.tr(\"\(key)\""
            if !types.isEmpty {
                enumText += ", "
                let params = (0..<types.count).map { "p\($0)" }
                enumText += ", ".join(params)
            }
            enumText += ")\n"
        }
        
        enumText += "\t\t}\n"
        enumText += "\t}\n\n"
        
        enumText += "\tprivate static func tr(key: String, _ args: CVarArgType...) -> String {\n"
        enumText += "\t\tlet format = NSLocalizedString(key, comment: \"\")\n"
        enumText += "\t\treturn String(format: format, arguments: args)\n"
        enumText += "\t}\n"
        enumText += "}\n\n"
        
        enumText += "func tr(key: L10n) -> String {\n"
        enumText += "\treturn key.string\n"
        enumText += "}\n"
        
        return enumText
    }
}


