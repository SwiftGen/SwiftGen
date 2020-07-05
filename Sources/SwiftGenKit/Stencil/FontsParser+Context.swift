//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation

//
// See the documentation file for a full description of this context's structure:
// Documentation/SwiftGenKit Contexts/fonts.md
//

extension Fonts.Parser {
  public func stencilContext() -> [String: Any] {
    // turn into array of dictionaries
    let families = entries
      .map { (name: String, family: Set<Fonts.Font>) -> [String: Any] in
        // Font
        let fonts = family
          .map { (font: Fonts.Font) -> [String: String] in
            [
              "name": font.postScriptName,
              "path": font.filePath,
              "style": font.style
            ]
          }
          .sorted {
            $0["name"] ?? "" < $1["name"] ?? ""
          }

        // Family
        return [
          "name": name,
          "fonts": fonts
        ]
      }
      .sorted {
        $0["name"] as? String ?? "" < $1["name"] as? String ?? ""
      }

    return [
      "families": families
    ]
  }
}
