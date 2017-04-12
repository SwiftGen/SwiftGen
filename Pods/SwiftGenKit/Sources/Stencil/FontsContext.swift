//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

/*
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
