//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Stencil

enum FilterError: ErrorType {
  case InvalidInputType
}

struct StringFilters {
  static func stringToSwiftIdentifier(value: Any?) throws -> Any? {
    guard let value = value as? String else { throw FilterError.InvalidInputType }
    return swiftIdentifier(fromString: value, replaceWithUnderscores: true)
  }

  /* - If the string starts with only one uppercase letter, lowercase that first letter
   * - If the string starts with multiple uppercase letters, lowercase those first letters
   *   up to the one before the last uppercase one
   * e.g. "PeoplePicker" gives "peoplePicker" but "URLChooser" gives "urlChooser"
   */
  static func lowerFirstWord(value: Any?) throws -> Any? {
    guard let string = value as? String else { throw FilterError.InvalidInputType }

    let cs = NSCharacterSet.uppercaseLetterCharacterSet()
    let scalars = string.unicodeScalars
    let start = scalars.startIndex
    var idx = start
    while cs.longCharacterIsMember(scalars[idx].value) && idx <= scalars.endIndex {
      idx = idx.successor()
    }
    if idx > start.successor() && idx < scalars.endIndex {
      idx = idx.predecessor()
    }
    let transformed = String(scalars[start..<idx]).lowercaseString + String(scalars[idx..<scalars.endIndex])
    return transformed
  }

  static func titlecase(value: Any?) throws -> Any? {
    guard let string = value as? String else { throw FilterError.InvalidInputType }
    return titlecase(string)
  }

  static func snakeToCamelCase(value: Any?) throws -> Any? {
    guard let string = value as? String else { throw FilterError.InvalidInputType }
    guard let noPrefix = try snakeToCamelCaseNoPrefix(value) else {
      return nil
    }
    var prefixUnderscores = ""
    for scalar in string.unicodeScalars {
      guard scalar == "_" else { break }
      prefixUnderscores += "_"
    }

    return prefixUnderscores + ("\(noPrefix)")
  }

  static func snakeToCamelCaseNoPrefix(value: Any?) throws -> Any? {
    guard let string = value as? String else { throw FilterError.InvalidInputType }
    let comps = string.componentsSeparatedByString("_")
    return comps.map { titlecase($0) }.joinWithSeparator("")
  }

  /**
  This returns the string with its first parameter uppercased.
  - note: This is quite similar to `capitalise` except that this filter doesn't lowercase
          the rest of the string but keep it untouched.

  - parameter string: The string to titleCase

  - returns: The string with its first character uppercased, and the rest of the string unchanged.
  */
  private static func titlecase(string: String) -> String {
    guard let first = string.unicodeScalars.first else { return string }
    return String(first).uppercaseString + String(string.unicodeScalars.dropFirst())
  }
}

struct ArrayFilters {
  static func join(value: Any?) throws -> Any? {
    guard let array = value as? [Any] else { throw FilterError.InvalidInputType }
    let strings = array.flatMap { $0 as? String }
    guard array.count == strings.count else { throw FilterError.InvalidInputType }

    return strings.joinWithSeparator(", ")
  }
}

struct NumFilters {
  static func hexToInt(value: Any?) throws -> Any? {
    guard let value = value as? String else { throw FilterError.InvalidInputType }
    return Int(value, radix:  16)
  }

  static func int255toFloat(value: Any?) throws -> Any? {
    guard let value = value as? Int else { throw FilterError.InvalidInputType }
    return Float(value) / Float(255.0)
  }

  static func percent(value: Any?) throws -> Any? {
    guard let value = value as? Float else { throw FilterError.InvalidInputType }

    let percent = Int(value * 100.0)
    return "\(percent)%"
  }
}
