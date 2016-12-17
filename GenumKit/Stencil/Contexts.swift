//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Stencil

private func uppercaseFirst(_ string: String) -> String {
  guard let first = string.characters.first else {
    return string
  }
  return String(first).uppercased() + String(string.characters.dropFirst())
}

private extension String {
  var newlineEscaped: String {
    return self
      .replacingOccurrences(of: "\n", with: "\\n")
      .replacingOccurrences(of: "\r", with: "\\r")
  }
}

/* MARK: - Stencil Context for Colors

 - `enumName`: `String` — name of the enum to generate
 - `colors`: `Array` of:
    - `name` : `String` — name of each color
    - `rgb`  : `String` — hex value of the form RRGGBB (like "ff6600")
    - `rgba` : `String` — hex value of the form RRGGBBAA (like "ff6600cc")
    - `red`  : `String` — hex value of the red component
    - `green`: `String` — hex value of the green component
    - `blue` : `String` — hex value of the blue component
    - `alpha`: `String` — hex value of the alpha component
*/
extension ColorsFileParser {
  public func stencilContext(enumName: String = "ColorName") -> [String: Any] {
    let colorMap = colors.map({ (color: (name: String, value: UInt32)) -> [String:String] in
      let name = color.name.trimmingCharacters(in: CharacterSet.whitespaces)
      let hex = "00000000" + String(color.value, radix: 16)
      let hexChars = Array(hex.characters.suffix(8))
      let comps = (0..<4).map { idx in String(hexChars[idx*2...idx*2+1]) }

      return [
        "name": name,
        "rgba": String(hexChars[0..<8]),
        "rgb": String(hexChars[0..<6]),
        "red": comps[0],
        "green": comps[1],
        "blue": comps[2],
        "alpha": comps[3]
      ]
    }).sorted { $0["name"] ?? "" < $1["name"] ?? "" }
    return ["enumName": enumName, "colors": colorMap]
  }
}

/* MARK: - Stencil Context for Images

 - `enumName`: `String` — name of the enum to generate
 - `images`: `Array<String>` — list of image names
*/
extension AssetsCatalogParser {
  public func stencilContext(enumName: String = "Asset") -> [String: Any] {
    let images = catalogs.flatMap { justValues(entries: $1) }.sorted(by: <)
    let structured = catalogs.keys.sorted(by: <).map { name -> [String: Any] in
      return [
        "name": name,
        "assets": structure(entries: catalogs[name] ?? [])
      ]
    }

    return [
      "enumName": enumName,
      "images": images,
      "catalogs": structured
    ]
  }

  private func justValues(entries: [Entry]) -> [String] {
    var result = [String]()

    for entry in entries {
      switch entry {
      case let .group(name: _, items: items):
        result += justValues(entries: items)
      case let .image(name: _, value: value):
        result += [value]
      }
    }

    return result
  }

  private func structure(entries: [Entry], currentLevel: Int = 0, maxLevel: Int = 5) -> [[String: Any]] {
    return entries.map { entry in
      switch entry {
      case let .group(name: name, items: items):
        if currentLevel + 1 >= maxLevel {
          return [
            "name": name,
            "items": flatten(entries: items)
          ]
        } else {
          return [
            "name": name,
            "items": structure(entries: items, currentLevel: currentLevel + 1, maxLevel: maxLevel)
          ]
        }
      case let .image(name: name, value: value):
        return [
          "name": name,
          "value": value
        ]
      }
    }
  }

  private func flatten(entries: [Entry]) -> [[String: Any]] {
    var result = [[String: Any]]()

    for entry in entries {
      switch entry {
      case let .group(name: name, items: items):
        result += flatten(entries: items).map { item in
          return [
            "name": "\(name)/\(item["name"]!)",
            "value": item["value"]!
          ]
        }
      case let .image(name: name, value: value):
        result += [[
          "name": name,
          "value": value
        ]]
      }
    }

    return result
  }
}

/* MARK: - Stencil Context for Storyboards

 - `sceneEnumName`: `String`
 - `segueEnumName`: `String`
 - `extraImports`: `Array` of `String`
 - `storyboards`: `Array` of:
    - `name`: `String`
    - `initialScene`: `Dictionary` (absent if not specified)
       - `customClass`: `String` (absent if generic UIViewController/NSViewController)
       - `isBaseViewController`: `Bool`, indicate if the baseType is 'viewController' or anything else
       - `baseType`: `String` (absent if class is a custom class).
          The base class type on which the initial scene is base.
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
  public func stencilContext(sceneEnumName: String = "StoryboardScene",
                                           segueEnumName: String = "StoryboardSegue",
                                           extraImports: [String] = []) -> [String: Any] {
    let storyboards = Set(storyboardsScenes.keys).union(storyboardsSegues.keys).sorted(by: <)
    let storyboardsMap = storyboards.map { (storyboardName: String) -> [String:Any] in
      var sbMap: [String:Any] = ["name": storyboardName]
      // Initial Scene
      if let initialScene = initialScenes[storyboardName] {
        let initial: [String:Any]
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
          .sorted(by: {$0.storyboardID < $1.storyboardID})
          .map { (scene: Scene) -> [String:Any] in
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
          .sorted(by: {$0.segueID < $1.segueID})
          .map { (segue: Segue) -> [String:String] in
            ["identifier": segue.segueID, "customClass": segue.customClass ?? ""]
        }
      }
      return sbMap
    }
    return [
      "sceneEnumName": sceneEnumName,
      "segueEnumName": segueEnumName,
      "extraImports": extraImports,
      "storyboards": storyboardsMap
    ]
  }
}

/* MARK: - Stencil Context for Strings

 - `enumName`: `String`
 - `tableName`: `String` - name of the `.strings` file (usually `"Localizable"`)
 - `strings`: `Array`
    - `key`: `String`
    - `translation`: `String`
    - `params`: `Dictionary` — defined only if localized string has parameters; contains the following entries:
       - `count`: `Int` — number of parameters
       - `types`: `Array<String>` containing types like `"String"`, `"Int"`, etc
       - `declarations`: `Array<String>` containing declarations like `"let p0"`, `"let p1"`, etc
       - `names`: `Array<String>` containing parameter names like `"p0"`, `"p1"`, etc
       - `typednames`: Array<String>` containing typed declarations like `"let p0: String`", `"let p1: Int"`, etc
    - `keytail`: `String` containing the rest of the key after the next first `.`
                 (useful to do recursion when splitting keys against `.` for structured templates)
 - `structuredStrings`: `Dictionary` - contains strings structured by keys separated by '.' syntax
*/
extension StringsFileParser {
  public func stencilContext(enumName: String = "L10n", tableName: String = "Localizable") -> [String: Any] {

    let entryToStringMapper = { (entry: Entry, keyPath: [String]) -> [String: Any] in
      var keyStructure = entry.keyStructure
      Array(0..<keyPath.count).forEach { _ in keyStructure.removeFirst() }
      let keytail = keyStructure.joined(separator: ".")

      if entry.types.count > 0 {
        let params: [String: Any] = [
          "count": entry.types.count,
          "types": entry.types.map { $0.rawValue },
          "declarations": entry.types.indices.map { "let p\($0)" },
          "names": entry.types.indices.map { "p\($0)" },
          "typednames": entry.types.enumerated().map { "p\($0): \($1.rawValue)" }
        ]
        return ["key": entry.key.newlineEscaped,
                "translation": entry.translation.newlineEscaped,
                "params": params,
                "keytail": keytail
        ]
      } else {
        return ["key": entry.key.newlineEscaped,
                "translation": entry.translation.newlineEscaped,
                "keytail": keytail
        ]
      }
    }

    let strings = entries
        .sorted { $0.key.caseInsensitiveCompare($1.key) == .orderedAscending }
        .map { entryToStringMapper($0, []) }
    let structuredStrings = structure(
        entries: entries,
        usingMapper: entryToStringMapper,
        currentLevel: 0,
        maxLevel: 5
    )

    return [
      "enumName": enumName,
      "tableName": tableName,
      "strings": strings,
      "structuredStrings": structuredStrings
    ]
  }

  private func normalize(_ string: String) -> String {
    let components = string.components(separatedBy: CharacterSet(charactersIn: "-_"))
    return components.map { $0.capitalized }.joined(separator: "")
  }

  typealias Mapper = (_ entry: Entry, _ keyPath: [String]) -> [String: Any]
  private func structure(
    entries: [Entry],
    atKeyPath keyPath: [String] = [],
    usingMapper mapper: @escaping Mapper,
    currentLevel: Int,
    maxLevel: Int) -> [String: Any] {

    var structuredStrings: [String: Any] = [:]

    let strings = entries
      .filter { $0.keyStructure.count == keyPath.count+1 }
      .sorted { $0.key.lowercased() < $1.key.lowercased() }
      .map { mapper($0, keyPath) }

    if !strings.isEmpty {
      structuredStrings["strings"] = strings
    }

    if let lastKeyPathComponent = keyPath.last {
      structuredStrings["name"] = lastKeyPathComponent
    }

    var subenums: [[String: Any]] = []
    let nextLevelKeyPaths: [[String]] = entries
      .filter({ $0.keyStructure.count > keyPath.count+1 })
      .map({ Array($0.keyStructure.prefix(keyPath.count+1)) })

    // make key paths unique
    let uniqueNextLevelKeyPaths = Array(Set(
      nextLevelKeyPaths.map { keyPath in
        keyPath.map({
          $0.capitalized.replacingOccurrences(of: "-", with: "_")
        }).joined(separator: ".")
      }))
      .sorted()
      .map { $0.components(separatedBy: ".") }

    for nextLevelKeyPath in uniqueNextLevelKeyPaths {
      let entriesInKeyPath = entries.filter {
        Array($0.keyStructure.map(normalize).prefix(nextLevelKeyPath.count)) == nextLevelKeyPath.map(normalize)
      }
      if currentLevel >= maxLevel {
        subenums.append(
            flattenedStrings(fromEnteries: entries,
                             atKeyPath: nextLevelKeyPath,
                             usingMapper: mapper,
                             level: currentLevel+1
            )
        )
      } else {
        subenums.append(
            structure(entries: entriesInKeyPath,
                      atKeyPath: nextLevelKeyPath,
                      usingMapper: mapper,
                      currentLevel: currentLevel+1,
                      maxLevel: maxLevel)
        )
      }
    }

    if !subenums.isEmpty {
      structuredStrings["subenums"] = subenums
    }

    return structuredStrings
  }

  private func flattenedStrings(
    fromEnteries entries: [Entry],
    atKeyPath keyPath: [String],
    usingMapper mapper: @escaping Mapper,
    level: Int) -> [String: Any] {

    var structuredStrings: [String: Any] = [:]

    let strings = entries
      .filter { $0.keyStructure.count >= keyPath.count+1 }
      .map { mapper($0, keyPath) }

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
  public func stencilContext(enumName: String = "FontFamily") -> [String: Any] {
    // turn into array of dictionaries
    let families = entries.map { (name: String, family: Set<Font>) -> [String: Any] in
      let fonts = family.map { (font: Font) -> [String: String] in
        // Font
        return [
          "style": font.style,
          "fontName": font.postScriptName
        ]
      }.sorted { $0["fontName"] ?? "" < $1["fontName"] ?? "" }
      // Family
      return [
        "name": name,
        "fonts": fonts
      ]
    }.sorted { $0["name"] as? String ?? "" < $1["name"] as? String ?? "" }

    return ["enumName": enumName, "families": families]
  }
}

/* MARK: - Stencil Context for Models
 */
extension JSONFileParser {
  public func stencilContext() -> [String: Any] {
    return ["spec": json]
  }
}
