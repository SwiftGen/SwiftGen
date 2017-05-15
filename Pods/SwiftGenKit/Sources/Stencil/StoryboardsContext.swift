//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

private func uppercaseFirst(_ string: String) -> String {
  guard let first = string.characters.first else {
    return string
  }
  return String(first).uppercased() + String(string.characters.dropFirst())
}

/*
 - `modules`    : `Array<String>` — List of modules used by scenes and segues — typically used for "import" statements
 - `storyboards`: `Array` — List of storyboards
    - `name`: `String` — Name of the storyboard
    - `initialScene`: `Dictionary` (absent if not specified)
       - `customClass` : `String` — The custom class of the scene (absent if generic UIViewController/NSViewController)
       - `customModule`: `String` — The custom module of the scene (absent if no custom class)
       - `baseType`: `String` — The base class type of the scene if not custom (absent if class is a custom class).
          Possible values include 'ViewController', 'NavigationController', 'TableViewController'…
    - `scenes`: `Array` (absent if empty)
       - `identifier` : `String` — The scene identifier
       - `customClass`: `String` — The custom class of the scene (absent if generic UIViewController/NSViewController)
       - `customModule`: `String` — The custom module of the scene (absent if no custom class)
       - `baseType`: `String` — The base class type of the scene if not custom (absent if class is a custom class).
          Possible values include 'ViewController', 'NavigationController', 'TableViewController'…
    - `segues`: `Array` (absent if empty)
       - `identifier`: `String` — The segue identifier
       - `customClass`: `String` — The custom class of the segue (absent if generic UIStoryboardSegue)
       - `customModule`: `String` — The custom module of the segue (absent if no custom segue class)
*/
extension StoryboardParser {
  public func stencilContext(sceneEnumName: String = "StoryboardScene",
                             segueEnumName: String = "StoryboardSegue") -> [String: Any] {
    let storyboards = Set(storyboardsScenes.keys).union(storyboardsSegues.keys).sorted(by: <)
    let storyboardsMap = storyboards.map { (storyboardName: String) -> [String:Any] in
      var sbMap: [String:Any] = ["name": storyboardName]
      // Initial Scene
      if let initialScene = initialScenes[storyboardName] {
        sbMap["initialScene"] = map(initialScene: initialScene)
      }
      // All Scenes
      if let scenes = storyboardsScenes[storyboardName] {
        sbMap["scenes"] = scenes
          .sorted(by: {$0.storyboardID < $1.storyboardID})
          .map(map(scene:))
      }
      // All Segues
      if let segues = storyboardsSegues[storyboardName] {
        sbMap["segues"] = segues
          .sorted(by: {$0.identifier < $1.identifier})
          .map(map(segue:))
      }
      return sbMap
    }
    return [
      "modules": modules.sorted(),
      "storyboards": storyboardsMap
    ]
  }

  private func map(initialScene scene: InitialScene) -> [String: Any] {
    if let customClass = scene.customClass {
      return [
        "customClass": customClass,
        "customModule": scene.customModule ?? ""
      ]
    } else {
      return [
        "baseType": uppercaseFirst(scene.tag)
      ]
    }
  }

  private func map(scene: Scene) -> [String: Any] {
    if let customClass = scene.customClass {
      return [
        "identifier": scene.storyboardID,
        "customClass": customClass,
        "customModule": scene.customModule ?? ""
      ]
    } else if scene.tag == "viewController" {
      return [
        "identifier": scene.storyboardID,
        "baseType": uppercaseFirst(scene.tag)
      ]
    } else {
      return [
        "identifier": scene.storyboardID,
        "baseType": uppercaseFirst(scene.tag)
      ]
    }
  }

  private func map(segue: Segue) -> [String: Any] {
    return [
      "identifier": segue.identifier,
      "customClass": segue.customClass ?? "",
      "customModule": segue.customModule ?? ""
    ]
  }
}
