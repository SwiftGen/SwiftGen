//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

private extension String {
  var newlineEscaped: String {
    return self
      .replacingOccurrences(of: "\n", with: "\\n")
      .replacingOccurrences(of: "\r", with: "\\r")
  }
}

/*
 - `tables`: `Array` — List of string tables
   - `name`  : `String` — name of the `.strings` file (usually `"Localizable"`)
   - `levels`: `Array` — Tree structure of strings (based on dot syntax), each level has:
     - `name`    : `String` — name of the level (that is, part of the key split by `.` that we're describing)
     - `children`: `Array` — list of sub-levels, repeating the same structure as a level
     - `strings` : `Array` — list of strings at this level:
       - `name` : `String` — contains only the last part of the key (after the last `.`)
         (useful to do recursion when splitting keys against `.` for structured templates)
       - `key`  : `String` — the full translation key, as it appears in the strings file
       - `translation`: `String` — the translation for that key in the strings file
       - `types`: `Array<String>` — defined only if localized string has parameter placeholders like `%d` and `%@` etc.
          Contains a list of types like `"String"`, `"Int"`, etc
*/
extension Strings.Parser {
  public func stencilContext() -> [String: Any] {
    let entryToStringMapper = { (entry: Strings.Entry, keyPath: [String]) -> [String: Any] in
      var result: [String: Any] = [
        "name": entry.keyStructure.last ?? "",
        "key": entry.key.newlineEscaped,
        "translation": entry.translation.newlineEscaped
      ]

      if !entry.types.isEmpty {
        result["types"] = entry.types.map { $0.rawValue }
      }

      return result
    }

    let tables = self.tables
      .sorted { $0.key.lowercased() < $1.key.lowercased() }
      .map { name, entries in
        [
          "name": name,
          "levels": structure(
            entries: entries,
            usingMapper: entryToStringMapper
          )
        ]
      }

    return [
      "tables": tables
    ]
  }

  typealias Mapper = (_ entry: Strings.Entry, _ keyPath: [String]) -> [String: Any]
  private func structure(
    entries: [Strings.Entry],
    atKeyPath keyPath: [String] = [],
    usingMapper mapper: @escaping Mapper) -> [String: Any] {

    var structuredStrings: [String: Any] = [:]
    if let name = keyPath.last {
      structuredStrings["name"] = name
    }

    // collect strings for this level
    let strings = entries
      .filter { $0.keyStructure.count == keyPath.count + 1 }
      .sorted { $0.key.lowercased() < $1.key.lowercased() }
      .map { mapper($0, keyPath) }

    if !strings.isEmpty {
      structuredStrings["strings"] = strings
    }

    // collect children for this level, group them by name for the next level, sort them
    // and then structure those grouped entries
    let childEntries = entries.filter { $0.keyStructure.count > keyPath.count + 1 }
    let children = Dictionary(grouping: childEntries) { $0.keyStructure[keyPath.count] }
      .sorted { $0.key < $1.key }
      .map { name, entries in
        structure(entries: entries, atKeyPath: keyPath + [name], usingMapper: mapper)
      }

    if !children.isEmpty {
      structuredStrings["children"] = children
    }

    return structuredStrings
  }
}
