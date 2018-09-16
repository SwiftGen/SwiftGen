//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

typealias CharRange = CountableClosedRange<Int>

private func mr(_ char: Int) -> CharRange {
  return char...char
}

// Official list of valid identifier characters
// swiftlint:disable:next line_length
// from: https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html#//apple_ref/doc/uid/TP40014097-CH30-ID410
private let headRanges: [CharRange] = [
  0x61...0x7a as CharRange,
  0x41...0x5a as CharRange,
  mr(0x5f), mr(0xa8), mr(0xaa), mr(0xad), mr(0xaf),
  0xb2...0xb5 as CharRange,
  0xb7...0xba as CharRange,
  0xbc...0xbe as CharRange,
  0xc0...0xd6 as CharRange,
  0xd8...0xf6 as CharRange,
  0xf8...0xff as CharRange,
  0x100...0x2ff as CharRange,
  0x370...0x167f as CharRange,
  0x1681...0x180d as CharRange,
  0x180f...0x1dbf as CharRange,
  0x1e00...0x1fff as CharRange,
  0x200b...0x200d as CharRange,
  0x202a...0x202e as CharRange,
  mr(0x203F), mr(0x2040), mr(0x2054),
  0x2060...0x206f as CharRange,
  0x2070...0x20cf as CharRange,
  0x2100...0x218f as CharRange,
  0x2460...0x24ff as CharRange,
  0x2776...0x2793 as CharRange,
  0x2c00...0x2dff as CharRange,
  0x2e80...0x2fff as CharRange,
  0x3004...0x3007 as CharRange,
  0x3021...0x302f as CharRange,
  0x3031...0x303f as CharRange,
  0x3040...0xd7ff as CharRange,
  0xf900...0xfd3d as CharRange,
  0xfd40...0xfdcf as CharRange,
  0xfdf0...0xfe1f as CharRange,
  0xfe30...0xfe44 as CharRange,
  0xfe47...0xfffd as CharRange,
  0x10000...0x1fffd as CharRange,
  0x20000...0x2fffd as CharRange,
  0x30000...0x3fffd as CharRange,
  0x40000...0x4fffd as CharRange,
  0x50000...0x5fffd as CharRange,
  0x60000...0x6fffd as CharRange,
  0x70000...0x7fffd as CharRange,
  0x80000...0x8fffd as CharRange,
  0x90000...0x9fffd as CharRange,
  0xa0000...0xafffd as CharRange,
  0xb0000...0xbfffd as CharRange,
  0xc0000...0xcfffd as CharRange,
  0xd0000...0xdfffd as CharRange,
  0xe0000...0xefffd as CharRange
]

private let tailRanges: [CharRange] = [
  0x30...0x39, 0x300...0x36F, 0x1dc0...0x1dff, 0x20d0...0x20ff, 0xfe20...0xfe2f
]

private func identifierCharacterSets(exceptions: String) -> (head: NSMutableCharacterSet, tail: NSMutableCharacterSet) {
  let addRange: (NSMutableCharacterSet, CharRange) -> Void = { mcs, range in
    mcs.addCharacters(in: NSRange(location: range.lowerBound, length: range.count))
  }

  let head = NSMutableCharacterSet()
  for range in headRanges {
    addRange(head, range)
  }
  head.removeCharacters(in: exceptions)

  guard let tail = head.mutableCopy() as? NSMutableCharacterSet else {
    fatalError("Internal error: mutableCopy() should have returned a valid NSMutableCharacterSet")
  }
  for range in tailRanges {
    addRange(tail, range)
  }
  tail.removeCharacters(in: exceptions)

  return (head, tail)
}

enum SwiftIdentifier {
  static func identifier(from string: String,
                         forbiddenChars exceptions: String = "",
                         replaceWithUnderscores underscores: Bool = false) -> String {

    let (_, tail) = identifierCharacterSets(exceptions: exceptions)

    let parts = string.components(separatedBy: tail.inverted)
    let replacement = underscores ? "_" : ""
    let mappedParts = parts.map { (string: String) -> String in
      // Can't use capitalizedString here because it will lowercase all letters after the first
      // e.g. "SomeNiceIdentifier".capitalizedString will because "Someniceidentifier" which is not what we want
      guard let first = string.unicodeScalars.first else { return string }
      return String(first).uppercased() + String(string.unicodeScalars.dropFirst())
    }

    let result = mappedParts.joined(separator: replacement)
    return prefixWithUnderscoreIfNeeded(string: result, forbiddenChars: exceptions)
  }

  static func prefixWithUnderscoreIfNeeded(string: String,
                                           forbiddenChars exceptions: String = "") -> String {

    let (head, _) = identifierCharacterSets(exceptions: exceptions)

    let chars = string.unicodeScalars
    let firstChar = chars[chars.startIndex]
    let prefix = !head.longCharacterIsMember(firstChar.value) ? "_" : ""

    return prefix + string
  }
}
