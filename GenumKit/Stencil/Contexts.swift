//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Stencil

private func uppercaseFirst(string: String) -> String {
  guard let first = string.characters.first else {
    return string
  }
  return String(first).uppercaseString + String(string.characters.dropFirst())
}

/* MARK: - Stencil Context for Colors

 - `enumName`: `String` — name of the enum to generate
 - `colors`: `Array` of:
    - `name`: `String` — name of each color
    - `rgb`  : `String` — hex value of the form RRGGBB (like "ff6600")
    - `rgba` : `String` — hex value of the form RRGGBBAA (like "ff6600cc")
    - `red`  : `String` — hex value of the red component
    - `green`: `String` — hex value of the green component
    - `blue` : `String` — hex value of the blue component
    - `alpha`: `String` — hex value of the alpha component
*/
extension ColorsFileParser {
  public func stencilContext(enumName enumName: String = "ColorName") -> Context {
    let colorMap = colors.map({ (color: (name: String, value: UInt32)) -> [String:String] in
      let name = color.name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
      let hex = "00000000" + String(color.value, radix: 16)
      let hexChars = Array(hex.characters.suffix(8))
      let comps = (0..<4).map { idx in String(hexChars[idx*2...idx*2+1]) }

      return [
        "name": name,
        "rgba" : String(hexChars[0..<8]),
        "rgb"  : String(hexChars[0..<6]),
        "red"  : comps[0],
        "green": comps[1],
        "blue" : comps[2],
        "alpha": comps[3],
      ]
    }).sort { $0["name"] < $1["name"] }
    return Context(dictionary: ["enumName": enumName, "colors": colorMap], namespace: GenumNamespace())
  }
}

/* MARK: - Stencil Context for Images

 - `enumName`: `String` — name of the enum to generate
 - `images`: `Array<String>` — list of image names
*/
extension AssetsCatalogParser {
  public func stencilContext(enumName enumName: String = "Asset") -> Context {
    return Context(dictionary: ["enumName": enumName, "images": imageNames], namespace: GenumNamespace())
  }
}

/* MARK: - Stencil Context for Storyboards

 - `sceneEnumName`: `String`
 - `segueEnumName`: `String`
 - `storyboards`: `Array` of:
    - `name`: `String`
    - `initialScene`: `Dictionary` (absent if not specified)
       - `customClass`: `String` (absent if generic UIViewController/NSViewController)
       - `isBaseViewController`: `Bool`, indicate if the baseType is 'viewController' or anything else
       - `baseType`: `String` (absent if class is a custom class). The base class type on which the initial scene is base.
          Possible values include 'ViewController', 'NavigationController', 'TableViewController'…
    - `scenes`: `Array` (absent if empty)
       - `identifier`: `String`
       - `customClass`: `String` (absent if generic UIViewController/NSViewController)
       - `isBaseViewController`: `Bool`, indicate if the baseType is 'ViewController' or anything else
       - `baseType`: `String` (absent if class is a custom class). The base class type on which a scene is base.
          Possible values include 'ViewController', 'NavigationController', 'TableViewController'…
    - `segues`: `Array` (absent if empty)
       - `identifier`: `String`
       - `class`: `String` (absent if generic UIStoryboardSegue)
*/
extension StoryboardParser {
  public func stencilContext(sceneEnumName sceneEnumName: String = "StoryboardScene",
                                           segueEnumName: String = "StoryboardSegue") -> Context {
    let storyboards = Set(storyboardsScenes.keys).union(storyboardsSegues.keys).sort(<)
    let storyboardsMap = storyboards.map { (storyboardName: String) -> [String:AnyObject] in
      var sbMap: [String:AnyObject] = ["name": storyboardName]
      // Initial Scene
      if let initialScene = initialScenes[storyboardName] {
        let initial: [String:AnyObject]
        if let customClass = initialScene.customClass {
          initial = ["customClass": customClass]
        } else {
          initial = [
            "baseType": uppercaseFirst(initialScene.tag),
            "isBaseViewController": initialScene.tag == "viewController"
          ]
        }
        sbMap["initialScene"] = initial
      }
      // All Scenes
      if let scenes = storyboardsScenes[storyboardName] {
        sbMap["scenes"] = scenes
          .sort({$0.storyboardID < $1.storyboardID})
          .map { (scene: Scene) -> [String:AnyObject] in
            if let customClass = scene.customClass {
                return ["identifier": scene.storyboardID, "customClass": customClass]
            } else if scene.tag == "viewController" {
                return [
                    "identifier": scene.storyboardID,
                    "baseType": uppercaseFirst(scene.tag),
                    "isBaseViewController": scene.tag == "viewController"
                ]
            }
            return ["identifier": scene.storyboardID, "baseType": uppercaseFirst(scene.tag)]
        }
      }
      // All Segues
      if let segues = storyboardsSegues[storyboardName] {
        sbMap["segues"] = segues
          .sort({$0.segueID < $1.segueID})
          .map { (segue: Segue) -> [String:String] in
            ["identifier": segue.segueID, "customClass": segue.customClass ?? ""]
        }
      }
      return sbMap
    }
    return Context(
      dictionary: [
        "sceneEnumName": sceneEnumName,
        "segueEnumName": segueEnumName,
        "storyboards": storyboardsMap
      ],
      namespace: GenumNamespace()
    )
  }
}

/* MARK: - Stencil Context for Strings

 - `enumName`: `String`
 - `strings`: `Array`
    - `key`: `String`
    - `translation`: `String`
    - `params`: `Dictionary` — defined only if localized string has parameters; contains the following entries:
       - `count`: `Int` — number of parameters
       - `types`: `Array<String>` containing types like `"String"`, `"Int"`, etc
       - `declarations`: `Array<String>` containing declarations like `"let p0"`, `"let p1"`, etc
       - `names`: `Array<String>` containing parameter names like `"p0"`, `"p1"`, etc
 - `structuredStrings`: `Dictionary` - contains strings structured by keys separated by '.' syntax
*/
extension StringsFileParser {
  public func stencilContext(enumName enumName: String = "L10n", tableName: String = "Localizable") -> Context {

    let entryToStringMapper = { (entry: Entry, keyPath: [String]) -> [String: AnyObject] in
      var keyStructure = entry.keyStructure
      Array(0..<keyPath.count).forEach { _ in keyStructure.removeFirst() }
      let keytail = keyStructure.joinWithSeparator(".")

      if entry.types.count > 0 {
        let params = [
          "count": entry.types.count,
          "types": entry.types.map { $0.rawValue },
          "declarations": entry.types.indices.map { "let p\($0)" },
          "names": entry.types.indices.map { "p\($0)" },
          "typednames": entry.types.enumerate().map { "p\($0): \($1.rawValue)" }
        ]
        return ["key": entry.key, "translation": entry.translation, "params": params, "keytail": keytail]
      } else {
        return ["key": entry.key, "translation": entry.translation, "keytail": keytail]
      }
    }

    let strings = entries.map { entryToStringMapper($0, []) }
    let structuredStrings = structure(entries, mapper: entryToStringMapper, currentLevel: 0, maxLevel: 5)

    return Context(dictionary:
      [
        "enumName": enumName,
        "tableName": tableName,
        "strings": strings,
        "structuredStrings": structuredStrings
      ],
      namespace: GenumNamespace()
    )
  }

  private func normalize(string: String) -> String {
    let components = string.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "-_"))
    return components.map { $0.capitalizedString }.joinWithSeparator("")
  }

  typealias Mapper = (entry: Entry, keyPath: [String]) -> [String: AnyObject]
  private func structure(entries: [Entry], keyPath: [String] = [], mapper: Mapper, currentLevel: Int, maxLevel: Int) -> [String: AnyObject] {

    var structuredStrings: [String: AnyObject] = [:]

    let strings = entries
      .filter { $0.keyStructure.count == keyPath.count+1 }
      .map { mapper(entry: $0, keyPath: keyPath) }

    if !strings.isEmpty {
      structuredStrings["strings"] = strings
    }

    if let lastKeyPathComponent = keyPath.last {
      structuredStrings["name"] = lastKeyPathComponent
    }

    var subenums: [[String: AnyObject]] = []
    let nextLevelKeyPaths: [[String]] = entries
      .filter({ $0.keyStructure.count > keyPath.count+1 })
      .map({ Array($0.keyStructure.prefix(keyPath.count+1)) })

    // make key paths unique
    let uniqueNextLevelKeyPaths = Array(Set(
      nextLevelKeyPaths.map { keyPath in
        keyPath.map({
          $0.capitalizedString.stringByReplacingOccurrencesOfString("-", withString: "_")
        }).joinWithSeparator(".")
      }))
      .sort()
      .map { $0.componentsSeparatedByString(".") }

    for nextLevelKeyPath in uniqueNextLevelKeyPaths {
      let entriesInKeyPath = entries.filter {
        Array($0.keyStructure.map(normalize).prefix(nextLevelKeyPath.count)) == nextLevelKeyPath.map(normalize)
      }
      if currentLevel >= maxLevel {
        subenums.append(flattenedStrings(entries, keyPath: nextLevelKeyPath, mapper: mapper, level: currentLevel+1))
      } else {
        subenums.append(structure(entriesInKeyPath, keyPath: nextLevelKeyPath, mapper: mapper, currentLevel: currentLevel+1, maxLevel: maxLevel))
      }
    }

    if !subenums.isEmpty {
      structuredStrings["subenums"] = subenums
    }

    return structuredStrings
  }

  private func flattenedStrings(entries: [Entry], keyPath: [String], mapper: Mapper, level: Int) -> [String: AnyObject] {

    var structuredStrings: [String: AnyObject] = [:]

    let strings = entries
      .filter { $0.keyStructure.count >= keyPath.count+1 }
      .map { mapper(entry: $0, keyPath: keyPath) }

    if !strings.isEmpty {
      structuredStrings["strings"] = strings
    }

    if let lastKeyPathComponent = keyPath.last {
      structuredStrings["name"] = lastKeyPathComponent
    }

    return structuredStrings
  }
}

/* MARK: - Stencil Context for Fonts
- `enumName`: `String`
- `families`: `Array`
  - `name`: `String`
  - `fonts`: `Array`
    - `style`: `String`
    - `name`: `String`
*/

extension FontsFileParser {
  public func stencilContext(enumName enumName: String = "FontFamily") -> Context {
    // turn into array of dictionaries
    let families = entries.map { (name: String, family: Set<Font>) -> [String:AnyObject] in

      let fonts = family.map { (font: Font) -> [String: String] in
        // Font
        return [
          "style" : font.style,
          "fontName" : font.postScriptName
        ]
      }

      // Family
      return [
        "name":name,
        "fonts":fonts
      ]
    }
    return Context(dictionary: ["enumName": enumName, "families" : families], namespace: GenumNamespace())
  }
}
