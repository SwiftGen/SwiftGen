//
// SwiftGenKit
// Copyright © 2022 SwiftGen
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
          .sorted { lhs, rhs in
            lhs["name"] ?? "" < rhs["name"] ?? ""
          }

        // Family
        return [
          "name": name,
          "fonts": fonts
        ]
      }
      .sorted { lhs, rhs in
        lhs["name"] as? String ?? "" < rhs["name"] as? String ?? ""
      }

    return [
      "families": families
    ]
  }
}
