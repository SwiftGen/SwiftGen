//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation

//
// See the documentation file for a full description of this context's structure:
// Documentation/SwiftGenKit Contexts/Fonts.md
//

extension Fonts.Parser {
  public func stencilContext() -> [String: Any] {
    // turn into array of dictionaries
    let families = entries
      .map { (name: String, family: Set<Fonts.Font>) -> [String: Any] in
        // Font
        let fonts = family
          .map { (font: Fonts.Font) -> [String: Any] in
            [
              "name": font.postScriptName,
              "path": font.filePath,
              "style": font.style,
              // swiftlint:disable:next force_unwrapping
              "icons": font.icons.map { ["name": $0.key, "unicode": $0.value] }.sorted { $0["name"]! < $1["name"]! }
            ]
          }
          .sorted {
            ($0["name"] as? String) ?? "" < ($1["name"] as? String) ?? ""
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
