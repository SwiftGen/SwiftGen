//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation


// Official list of valid identifier characters
// swiftlint:disable:next line_length
// from: https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html#//apple_ref/doc/uid/TP40014097-CH30-ID410
// swiftlint:disable function_body_length
private func identifierCharacterSets() -> (head: NSMutableCharacterSet, tail: NSMutableCharacterSet) {
  let addRange: (NSMutableCharacterSet, Range<Int>) -> Void = { (mcs, range) in
    mcs.addCharactersInRange(NSRange(location: range.startIndex, length: range.endIndex-range.startIndex))
  }
  let addChars: (NSMutableCharacterSet, String) -> Void = { (mcs, string) in
    mcs.addCharactersInString(string)
  }

  let head = NSMutableCharacterSet()

  addRange(head, 0x41...0x5A) // A-Z
  addRange(head, 0x61...0x7A) // a-z
  addChars(head, "_")
  addChars(head, "\u{00A8}\u{00AA}\u{00AD}\u{00AF}")
  addRange(head, 0x00B2...0x00B5)
  addRange(head, 0x00B7...0x00BA)
  addRange(head, 0x00BC...0x00BE)
  addRange(head, 0x00C0...0x00D6)
  addRange(head, 0x00D8...0x00F6)
  addRange(head, 0x00F8...0x00FF)
  addRange(head, 0x0100...0x02FF)
  addRange(head, 0x0370...0x167F)
  addRange(head, 0x1681...0x180D)
  addRange(head, 0x180F...0x1DBF)
  addRange(head, 0x1E00...0x1FFF)
  addRange(head, 0x200B...0x200D)
  addRange(head, 0x202A...0x202E)
  addRange(head, 0x203F...0x2040)
  addChars(head, "\u{2054}")
  addRange(head, 0x2060...0x206F)
  addRange(head, 0x2070...0x20CF)
  addRange(head, 0x2100...0x218F)
  addRange(head, 0x2460...0x24FF)
  addRange(head, 0x2776...0x2793)
  addRange(head, 0x2C00...0x2DFF)
  addRange(head, 0x2E80...0x2FFF)
  addRange(head, 0x3004...0x3007)
  addRange(head, 0x3021...0x302F)
  addRange(head, 0x3031...0x303F)
  addRange(head, 0x3040...0xD7FF)
  addRange(head, 0xF900...0xFD3D)
  addRange(head, 0xFD40...0xFDCF)
  addRange(head, 0xFDF0...0xFE1F)
  addRange(head, 0xFE30...0xFE44)
  addRange(head, 0xFE47...0xFFFD)
  addRange(head, 0x10000...0x1FFFD)
  addRange(head, 0x20000...0x2FFFD)
  addRange(head, 0x30000...0x3FFFD)
  addRange(head, 0x40000...0x4FFFD)
  addRange(head, 0x50000...0x5FFFD)
  addRange(head, 0x60000...0x6FFFD)
  addRange(head, 0x70000...0x7FFFD)
  addRange(head, 0x80000...0x8FFFD)
  addRange(head, 0x90000...0x9FFFD)
  addRange(head, 0xA0000...0xAFFFD)
  addRange(head, 0xB0000...0xBFFFD)
  addRange(head, 0xC0000...0xCFFFD)
  addRange(head, 0xD0000...0xDFFFD)
  addRange(head, 0xE0000...0xEFFFD)

  guard let tail = head.mutableCopy() as? NSMutableCharacterSet else {
    fatalError("Internal error: mutableCopy() should have returned a valid NSMutableCharacterSet")
  }
  addChars(tail, "0123456789")
  addRange(tail, 0x0300...0x036F)
  addRange(tail, 0x1DC0...0x1DFF)
  addRange(tail, 0x20D0...0x20FF)
  addRange(tail, 0xFE20...0xFE2F)

  return (head, tail)
}
// swiftlint:enable function_body_length

func swiftIdentifier(fromString string: String,
                     forbiddenChars exceptions: String = "",
                     replaceWithUnderscores underscores: Bool = false) -> String {

  let (head, tail) = identifierCharacterSets()
  head.removeCharactersInString(exceptions)
  tail.removeCharactersInString(exceptions)

  let chars = string.unicodeScalars
  let firstChar = chars[chars.startIndex]

  let prefix = !head.longCharacterIsMember(firstChar.value) && tail.longCharacterIsMember(firstChar.value) ? "_" : ""
  let parts = string.componentsSeparatedByCharactersInSet(tail.invertedSet)
  let replacement = underscores ? "_" : ""
  let mappedParts = parts.map({ (string: String) -> String in
    // Can't use capitalizedString here because it will lowercase all letters after the first
    // e.g. "SomeNiceIdentifier".capitalizedString will because "Someniceidentifier" which is not what we want
    let ns = string as NSString
    if ns.length > 0 {
      let firstLetter = ns.substringToIndex(1)
      let rest = ns.substringFromIndex(1)
      return firstLetter.uppercaseString + rest
    } else {
      return ""
    }
  })
  return prefix + mappedParts.joinWithSeparator(replacement)
}
