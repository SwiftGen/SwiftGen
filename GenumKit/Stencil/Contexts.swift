//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Stencil

/* Stencil Context for Strings

- enumName: String
- strings: Array
- key: String
- params: dictionary defined only if localized string has parameters, and in such case contains the following entries:
- count: number of parameters
- types: Array<String> containing types like "String", "Int", etc
- declarations: Array<String> containing declarations like "let p0", "let p1", etc
- names: Array<String> containing parameter names like "p0", "p1", etc
*/

extension StringEnumBuilder {
  public func stencilContext(enumName: String = "L10n") -> Context {
    let strings = entries.map { (entry: StringEnumBuilder.Entry) -> [String:AnyObject] in
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
