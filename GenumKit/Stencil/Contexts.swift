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

 - enumName: String
 - colors: Array
 .  - name: String
 .  - rgba: String — hex value of for RRGGBBAA (without the "0x" prefix)
*/
extension ColorsFileParser {
  public func stencilContext(enumName enumName: String = "Name") -> Context {
    let colorMap = colors.map({ (color: (name: String, value: UInt32)) -> [String:String] in
      let name = color.name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
      let hexValue = String(color.value, radix: 16)
      return ["name": name, "rgba": hexValue]
    }).sort { $0["name"] < $1["name"] }
    return Context(dictionary: ["enumName": enumName, "colors": colorMap])
  }
}

/* MARK: - Stencil Context for Images

 - enumName: String
 - images: Array<String> — image names
*/
extension AssetsCatalogParser {
  public func stencilContext(enumName enumName: String = "Asset") -> Context {
    return Context(dictionary: ["enumName": enumName, "images": imageNames])
  }
}

/* MARK: - Stencil Context for Storyboards

 - sceneEnumName: String
 - segueEnumName: String
 - storyboards: Array
 .  - name: String
 .  - scenes: Array (absent if empty)
 .  .  - identifier: String
 .  .  - class: String (absent if generic UIViewController)
 .  - segues: Array (absent if empty)
 .  .  - identifier: String
 .  .  - class: String (absent if generic UIStoryboardSegue)
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

 - enumName: String
 - strings: Array
 .  - key: String
 .  - params: dictionary defined only if localized string has parameters, and in such case contains the following entries:
 .  .  - count: number of parameters
 .  .  - types: Array<String> containing types like "String", "Int", etc
 .  .  - declarations: Array<String> containing declarations like "let p0", "let p1", etc
 .  .  - names: Array<String> containing parameter names like "p0", "p1", etc
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
        return ["key": entry.key, "params":params]
      } else {
        return ["key": entry.key]
      }
    }
    return Context(dictionary: ["enumName":enumName, "strings":strings])
  }
}
