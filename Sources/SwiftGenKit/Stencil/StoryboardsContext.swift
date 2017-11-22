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
 - `platform`   : `String` — Name of the target platform (only available if all storyboards target the same platform)
 - `storyboards`: `Array` — List of storyboards
    - `name`: `String` — Name of the storyboard
    - `platform`: `String` — Name of the target platform (iOS, macOS, tvOS, watchOS)
    - `initialScene`: `Dictionary` — Same structure as scenes item (absent if not specified)
    - `scenes`: `Array` - List of scenes
       - `identifier` : `String` — The scene identifier
       - `customClass`: `String` — The custom class of the scene (absent if generic UIViewController/NSViewController)
       - `customModule`: `String` — The custom module of the scene (absent if no custom class)
       - `baseType`: `String` — The base class type of the scene if not custom (absent if class is a custom class).
          Possible values include 'ViewController', 'NavigationController', 'TableViewController'…
    - `segues`: `Array` - List of segues
       - `identifier`: `String` — The segue identifier
       - `customClass`: `String` — The custom class of the segue (absent if generic UIStoryboardSegue)
       - `customModule`: `String` — The custom module of the segue (absent if no custom segue class)
*/
extension StoryboardParser {
  public func stencilContext() -> [String: Any] {
    let storyboards = self.storyboards
      .sorted { (lhs, rhs) in lhs.name < rhs.name }
      .map(map(storyboard:))
    return [
      "modules": modules.sorted(),
      "storyboards": storyboards,
      "platform": platform ?? ""
    ]
  }

  private func map(storyboard: Storyboard) -> [String: Any] {
    var result: [String: Any] = [
      "name": storyboard.name,
      "scenes": storyboard.scenes
        .sorted { $0.identifier < $1.identifier }
        .map(map(scene:)),
      "segues": storyboard.segues
        .sorted { $0.identifier < $1.identifier }
        .map(map(segue:)),
      "platform": storyboard.platform
    ]

    if let scene = storyboard.initialScene {
      result["initialScene"] = map(scene: scene)
    }

    return result
  }

  private func map(scene: Storyboard.Scene) -> [String: Any] {
    if let customClass = scene.customClass {
      return [
        "identifier": scene.identifier,
        "customClass": customClass,
        "customModule": scene.customModule ?? ""
      ]
    } else {
      return [
        "identifier": scene.identifier,
        "baseType": uppercaseFirst(scene.tag)
      ]
    }
  }

  private func map(segue: Storyboard.Segue) -> [String: Any] {
    return [
      "identifier": segue.identifier,
      "customClass": segue.customClass ?? "",
      "customModule": segue.customModule ?? ""
    ]
  }
}
