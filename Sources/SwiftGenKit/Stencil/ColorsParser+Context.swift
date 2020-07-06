//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation

//
// See the documentation file for a full description of this context's structure:
// Documentation/SwiftGenKit Contexts/colors.md
//

extension Colors.Parser {
  public func stencilContext() -> [String: Any] {
    let palettes: [[String: Any]] = self.palettes
      .sorted { $0.name < $1.name }
      .map { palette in
        let colors = palette.colors
          .sorted { $0.key < $1.key }
          .map(map(color:value:))

        return [
          "name": palette.name,
          "colors": colors
        ]
      }

    return [
      "palettes": palettes
    ]
  }

  private func map(color name: String, value: UInt32) -> [String: String] {
    let name = name.trimmingCharacters(in: .whitespaces)
    let hex = "00000000" + String(value, radix: 16)
    let hexChars = Array(hex.suffix(8))
    let comps = (0..<4).map { idx in String(hexChars[(idx * 2)...(idx * 2 + 1)]) }

    return [
      "name": name,
      "red": comps[0],
      "green": comps[1],
      "blue": comps[2],
      "alpha": comps[3]
    ]
  }
}
