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
  public func stencilContext(enumName enumName: String = "Name") -> Context {
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
    return Context(dictionary: ["enumName": enumName, "colors": colorMap])
  }
}

/* MARK: - Stencil Context for Images

 - `enumName`: `String` — name of the enum to generate
 - `images`: `Array<String>` — list of image names
*/
extension AssetsCatalogParser {
  public func stencilContext(enumName enumName: String = "Asset") -> Context {
    return Context(dictionary: ["enumName": enumName, "images": imageNames])
  }
}

/* MARK: - Stencil Context for Storyboards

 - `sceneEnumName`: `String`
 - `segueEnumName`: `String`
 - `storyboards`: `Array` of:
    - `name`: `String`
    - `scenes`: `Array` (absent if empty)
       - `identifier`: `String`
       - `class`: `String` (absent if generic UIViewController)
    - `segues`: `Array` (absent if empty)
       - `identifier`: `String`
       - `class`: `String` (absent if generic UIStoryboardSegue)
*/
extension StoryboardParser {
  public func stencilContext(sceneEnumName sceneEnumName: String = "Scene", segueEnumName: String = "Segue") -> Context {
    let storyboards = Set(storyboardsScenes.keys).union(storyboardsSegues.keys).sort(<)
    let storyboardsMap = storyboards.map { (storyboardName: String) -> [String:AnyObject] in
      var sbMap: [String:AnyObject] = ["name": storyboardName]
      if let scenes = storyboardsScenes[storyboardName] {
        sbMap["scenes"] = scenes
          .sort({$0.storyboardID < $1.storyboardID})
          .map { (scene: Scene) -> [String:String] in
            let customClass = scene.customClass ?? (scene.tag != "viewController" ? "UI" + uppercaseFirst(scene.tag) : nil)
            if let customClass = customClass {
              return ["identifier": scene.storyboardID, "class": customClass]
            } else {
              return ["identifier": scene.storyboardID]
            }
        }
      }
      if let segues = storyboardsSegues[storyboardName] {
        sbMap["segues"] = segues
          .sort({$0.segueID < $1.segueID})
          .map { (segue: Segue) -> [String:String] in
            ["identifier": segue.segueID, "class": segue.customClass ?? "UIStoryboardSegue"]
        }
      }
      return sbMap
    }
    return Context(dictionary: ["sceneEnumName": sceneEnumName, "segueEnumName": segueEnumName, "storyboards": storyboardsMap])
  }
}

/* MARK: - Stencil Context for Strings

 - `enumName`: `String`
 - `strings`: `Array`
    - `key`: `String`
    - `translation`: `String`
    - `params`: `Dictionary` — defined only if localized string has parameters, and in such case contains the following entries:
       - `count`: `Int` — number of parameters
       - `types`: `Array<String>` containing types like `"String"`, `"Int"`, etc
       - `declarations`: `Array<String>` containing declarations like `"let p0"`, `"let p1"`, etc
       - `names`: `Array<String>` containing parameter names like `"p0"`, `"p1"`, etc
*/
extension StringsFileParser {
  public func stencilContext(enumName enumName: String = "L10n") -> Context {
    let strings = entries.map { (entry: StringsFileParser.Entry) -> [String:AnyObject] in
      if entry.types.count > 0 {
        let params = [
          "count": entry.types.count,
          "types": entry.types.map { $0.rawValue },
          "declarations": (0..<entry.types.count).map { "let p\($0)" },
          "names": (0..<entry.types.count).map { "p\($0)" }
        ]
        return ["key": entry.key, "translation": entry.translation, "params": params]
      } else {
        return ["key": entry.key, "translation": entry.translation]
      }
    }
    return Context(dictionary: ["enumName":enumName, "strings":strings])
  }
}
