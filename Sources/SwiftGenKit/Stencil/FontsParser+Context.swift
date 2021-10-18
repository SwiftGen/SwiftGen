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
      .sorted { $0.key.compare($1.key, options: .caseInsensitive) == .orderedAscending }
      .map { (name: String, family: Set<Fonts.Font>) -> [String: Any] in
        // Font
        let fonts = family
          .sorted { $0.postScriptName.compare($1.postScriptName, options: .caseInsensitive) == .orderedAscending }
          .map { (font: Fonts.Font) -> [String: String] in
            [
              "name": font.postScriptName,
              "path": font.filePath,
              "style": font.style
            ]
          }

        // Family
        return [
          "name": name,
          "fonts": fonts
        ]
      }

    return [
      "families": families
    ]
  }
}
