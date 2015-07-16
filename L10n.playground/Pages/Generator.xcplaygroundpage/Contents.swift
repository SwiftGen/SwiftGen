import Foundation


enum PlaceholderType : String {
    case String
    case Float
    case Int
    
    static func fromFormatChar(char: Character) -> PlaceholderType? {
        switch char {
            case "@": return .String
            case "f": return .Float
            case "d": return .Int
            default: return nil
        }
    }
}

func identifierFromKey(key: String) -> String {
    // Build Identifier
    var identifier = ""
    var capitalizeNext = true
    let separatorChars = [".","_"," "].map(Character.init)
    for char in key.characters {
        if separatorChars.contains(char) {
            capitalizeNext = true
        }
        else if capitalizeNext {
            identifier += String(char).capitalizedString
            capitalizeNext = false
        }
        else {
            identifier += String(char)
        }
    }
    
    return identifier
}

func typesFromFormatString(formatString: String) -> [PlaceholderType] {
    // Build Types list
    var types = [PlaceholderType]()
    var placeholderIndex: Int? = nil
    var lastPlaceholderIndex = 0
    
    for char in formatString.characters {
        if char == Character("%") {
            placeholderIndex = lastPlaceholderIndex++
        }
        else if placeholderIndex != nil {
            if let type = PlaceholderType.fromFormatChar(char) {
                types.append(type)
                placeholderIndex = nil
            }
        }
    }
    
    return types
}

func parseKeyAndPlaceholders(line: String) -> (key: String, identifier: String, types: [PlaceholderType])? {
    let range = NSRange(location: 0, length: line.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    let regex = try! NSRegularExpression(pattern: "^\"([^\"]*)\" *= *\"(.*)\";", options: [])
    if let keyMatch = regex.firstMatchInString(line, options: [], range: range) {

        let key = (line as NSString).substringWithRange(keyMatch.rangeAtIndex(1))
        
        let identifier = identifierFromKey(key)

        let stringValue = (line as NSString).substringWithRange(keyMatch.rangeAtIndex(2))
        let types = typesFromFormatString(stringValue)
        
        return (key, identifier, types)
    }
    return nil
}

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
            let params = types.enumerate().map { (idx,type) in "p\(idx): \(type.rawValue)" }
            enumText += "(" + ", ".join(params) + ")"
        }
        enumText += ":\n"
        enumText += "\t\t\t\treturn tr(\"\(key)\""
        if !types.isEmpty {
            enumText += ", "
            let params = (0..<types.count).map { "p\($0)" }
            enumText += ", ".join(params)
        }
        enumText += ")\n"
    }

    enumText += "\t\t}\n"
    enumText += "\t}\n\n"
    
    enumText += "\tprivate func tr(key: String, _ args: CVarArgType...) -> String {\n"
    enumText += "\t\tlet format = NSLocalizedString(key, comment: \"\")\n"
    enumText += "\t\treturn String(format: format, arguments: args)\n"
    enumText += "\t}\n"
    enumText += "}\n\n"
    
    enumText += "func tr(key: L10n) -> String {\n"
    enumText += "\treturn key.string\n"
    enumText += "}\n"
    
    return enumText
}








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
