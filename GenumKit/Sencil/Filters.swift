//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Stencil

struct IdentifierFilters {
  static func identifierNoUnderscores(value: Any?) -> Any? {
    guard let value = value as? String else { return nil }
    return value.asSwiftIdentifier(forbiddenChars: "_", replaceWithUnderscores: false)
  }
  
  static func identifierWithUnderscores(value: Any?) -> Any? {
    guard let value = value as? String else { return nil }
    return value.asSwiftIdentifier(replaceWithUnderscores: true)
  }

}

struct StringCaseFilters {
  
  /* - If the string starts with only one uppercase letter, lowercase that first letter
   * - If the string starts with multiple uppercase letters, lowercase those first letters up to the one before the last uppercase one
   * e.g. "PeoplePicker" gives "peoplePicker" but "URLChooser" gives "urlChooser"
   */
  static func lowerFirstWord(value: Any?) -> Any? {
    guard let string = value as? String else { return nil }
    
    let cs = NSCharacterSet.uppercaseLetterCharacterSet()
    let scalars = string.unicodeScalars
    let start = scalars.startIndex
    var idx = start
    while cs.longCharacterIsMember(scalars[idx].value) && idx < scalars.endIndex {
      idx = idx.successor()
    }
    if idx != start.successor() {
      idx = idx.predecessor()
    }
    let transformed = String(scalars[start..<idx]).lowercaseString + String(scalars[idx..<scalars.endIndex])
    return transformed

  }
}
