//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

/*
 - `colors`: `Array` of:
    - `name` : `String` — name of each color
    - `red`  : `String` — hex value of the red component
    - `green`: `String` — hex value of the green component
    - `blue` : `String` — hex value of the blue component
    - `alpha`: `String` — hex value of the alpha component
*/
extension ColorsFileParser {
  public func stencilContext(enumName: String = "ColorName") -> [String: Any] {
    let colorMap = colors.map({ (color: (name: String, value: UInt32)) -> [String:String] in
      let name = color.name.trimmingCharacters(in: CharacterSet.whitespaces)
      let hex = "00000000" + String(color.value, radix: 16)
      let hexChars = Array(hex.characters.suffix(8))
      let comps = (0..<4).map { idx in String(hexChars[idx*2...idx*2+1]) }

      return [
        "name": name,
        "red": comps[0],
        "green": comps[1],
        "blue": comps[2],
        "alpha": comps[3]
      ]
    }).sorted { $0["name"] ?? "" < $1["name"] ?? "" }

    return [
      "colors": colorMap
    ]
  }
}
