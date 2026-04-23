//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Kanna
import PathKit

public enum IdentifiersParserError: Error, CustomStringConvertible {
  case xmlParseError(path: Path)

  public var description: String {
    switch self {
    case .xmlParseError(let path):
      return "error: Unable to parse \(path). "
    }
  }
}

private enum Constants {
  static let identifierXPath = "//accessibility/@identifier"
  static let placeholderXPath = "placeholder[@placeholderIdentifier=\"IBFilesOwner\"]"
  static let customObjectXPath = "customObject[@userLabel=\"File's Owner\"]"

  static let customClassAttribute = "customClass"
  static let containerTags = [
    "viewController", "tableViewController", "collectionViewCell", "tableViewCell", "pagecontroller", "objects"
  ]

  static let storyboard = "storyboard"
  static let xib = "xib"
}

struct AccessibilityItem {
  let elementType: String
  let identifier: String
  let rawValue: String
}

public final class IdentifiersParser: Parser {
  typealias IdentifiersData = [String: [AccessibilityItem]]

  var accessibilityIdentifiers: IdentifiersData = [:]
  public var warningHandler: Parser.MessageHandler?

  public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
    self.warningHandler = warningHandler
  }

  public func parse(path: Path) throws {
    switch path.extension {
    case Constants.storyboard?, Constants.xib?:
      try extractData(from: path)

    case nil:
      let dirChildren = path.iterateChildren(options: [.skipsHiddenFiles, .skipsPackageDescendants])

      for file in dirChildren {
        try parse(path: file)
      }

    default:
      break
    }
  }

  private func extractData(from path: Path) throws {
    guard let document = Kanna.XML(xml: try path.read(), encoding: .utf8) else {
      throw IdentifiersParserError.xmlParseError(path: path)
    }

    typealias Pair = (String, AccessibilityItem)
    let pairs: [Pair] = document.xpath(Constants.identifierXPath).flatMap { element in
      guard
        let customClass = customClassFor(element: element, in: path),
        let identifier = element.text,
        let elementType = element.parent?.parent?.tagName
        else { return nil }

      let item = AccessibilityItem(elementType: elementType, identifier: identifier.sanitized(), rawValue: identifier)

      return (customClass, item)
    }

    let identifiers: IdentifiersData = pairs.grouped(
      key: { $0.0 },
      value: { $0.1 }
    )

    accessibilityIdentifiers += identifiers
  }
  private func customClassFor(element: Kanna.XMLElement, in path: Path) -> String? {
    switch path.extension {
    case Constants.storyboard?, Constants.xib?:
      guard let parent = element.parent(tagNames: Constants.containerTags) else { return nil }

      if let className = parent[Constants.customClassAttribute] {
        return className
      } else if let placeholder = parent.xpath(Constants.placeholderXPath).first {
        return placeholder[Constants.customClassAttribute]
      } else if let placeholder = parent.xpath(Constants.customObjectXPath).first {
        return placeholder[Constants.customClassAttribute]
      } else {
        return nil
      }

    default:
      return nil
    }
  }
}

extension Sequence {
  func grouped<Key, Value>(key: (Element) -> Key, value: (Element) -> Value) -> [Key: [Value]] {
    return Dictionary(grouping: self, by: key).mapValues { groupedValues in
      return groupedValues.map(value)
    }
  }
}

func +=<Key, Value>(lhs: inout [Key: Value], rhs: [Key: Value]) {
  for (key, value) in rhs {
    lhs[key] = value
  }
}

extension Kanna.XMLElement {
  func parent(tagNames: [String]) -> Kanna.XMLElement? {
    var parent: Kanna.XMLElement = self
    var match: Kanna.XMLElement? = nil

    while let element = parent.parent {
      defer { parent = element }

      guard
        let tagName = element.tagName,
        tagNames.contains(tagName)
        else { continue }

      match = element
      break
    }

    return match
  }
}

let reservedWords: Set<String> = [
  "Protocol", "Type", "associatedtype", "class", "deinit", "enum", "extension",
  "fileprivate", "func", "import", "init", "inout", "internal", "let",
  "operator", "private", "protocol", "public", "static", "struct", "subscript",
  "typealias", "var", "_", "break", "case", "continue", "default", "defer", "do",
  "else", "fallthrough", "for", "guard", "if", "in", "repeat", "return", "switch",
  "where", "while", "as", "Any", "catch", "false", "is", "nil", "rethrows",
  "super", "self", "Self", "throw", "throws", "true", "try"
]

extension String {
  func sanitized() -> String {
    let value = self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined(separator: "_")
    return reservedWords.contains(value) ? "`\(value)`" : value
  }
}
