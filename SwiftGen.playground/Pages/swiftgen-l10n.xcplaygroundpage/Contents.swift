import Foundation


// WIP. This should be ported as a lib + CLI later
//: #### List of supported types in string placeholders (`%…`)
enum PlaceholderType : String {
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

//: #### Build Types list
//:
//: -> Parse "I give %d apples to %@" into [.Int, .String]
func typesFromFormatString(formatString: String) -> [PlaceholderType] {
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

//: #### Parse a Localizable.strings line
//:
//: From a line in the Localizable.strings file, extract the key and value
//: And compute the case identifier and list of PlaceholderTypes to use for it
func parseKeyAndPlaceholders(line: String) -> (key: String, identifier: String, types: [PlaceholderType])? {
    let range = NSRange(location: 0, length: line.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    let regex = try! NSRegularExpression(pattern: "^\"([^\"]*)\" *= *\"(.*)\";", options: [])
    if let match = regex.firstMatchInString(line, options: [], range: range) {

        let key = (line as NSString).substringWithRange(match.rangeAtIndex(1))
        
        let identifier = key.asSwiftIdentifier(forbiddenChars: "_")

        let translation = (line as NSString).substringWithRange(match.rangeAtIndex(2))
        let types = typesFromFormatString(translation)
        
        return (key, identifier, types)
    }
    return nil
}


//: #### Transform an array of lines into the code for the enum
func processLines(lines: [String]) -> String {
    let keys = lines.map { parseKeyAndPlaceholders($0) }
    var enumText = "// AUTO-GENERATED FILE, DO NOT EDIT\n\n"
    
    enumText += "enum L10n {\n"
    
    for case let (_, identifier, types)? in keys {
        enumText += "\tcase \(identifier)"
        if !types.isEmpty {
            enumText += "(" + ", ".join(types.map{ $0.rawValue }) + ")"
        }
        enumText += "\n"
    }
    
    enumText += "}\n\n"
    
    enumText += "extension L10n : CustomStringConvertible {\n"
    
    enumText += "\tvar description : String { return self.string }\n\n"

    enumText += "\tvar string : String {\n"
    enumText += "\t\tswitch self {\n"

    for case let (key, identifier, types)? in keys {
        enumText += "\t\t\tcase .\(identifier)"
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






//: ## Main
//: The entry point for the code.
//: This needs to be transformed into a standalone CLI tool in the future
if let path = NSBundle.mainBundle().pathForResource("Localizable", ofType: "strings") {
    do {
        let fileContent = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        let lines = fileContent.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        let generated = processLines(lines)
        print(generated)
    }
    catch {
        print("Ooops: \(error)")
    }
}

