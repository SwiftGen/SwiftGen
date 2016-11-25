import Foundation


/// Split a string by spaces leaving quoted phrases together
func smartSplit(_ value: String) -> [String] {
  var word = ""
  var separator: Character = " "
  var components: [String] = []

  for character in value.characters {
    if character == separator {
      if separator != " " {
        word.append(separator)
      }

      if !word.isEmpty {
        components.append(word)
        word = ""
      }

      separator = " "
    } else {
      if separator == " " && (character == "'" || character == "\"") {
        separator = character
      }
      word.append(character)
    }
  }

  if !word.isEmpty {
    components.append(word)
  }

  return components
}


public enum Token : Equatable {
  /// A token representing a piece of text.
  case text(value: String)

  /// A token representing a variable.
  case variable(value: String)

  /// A token representing a comment.
  case comment(value: String)

  /// A token representing a template block.
  case block(value: String)

  /// Returns the underlying value as an array seperated by spaces
  public func components() -> [String] {
    switch self {
    case .block(let value):
      return smartSplit(value)
    case .variable(let value):
      return smartSplit(value)
    case .text(let value):
      return smartSplit(value)
    case .comment(let value):
      return smartSplit(value)
    }
  }

  public var contents: String {
    switch self {
    case .block(let value):
      return value
    case .variable(let value):
      return value
    case .text(let value):
      return value
    case .comment(let value):
      return value
    }
  }
}


public func == (lhs: Token, rhs: Token) -> Bool {
  switch (lhs, rhs) {
  case (.text(let lhsValue), .text(let rhsValue)):
    return lhsValue == rhsValue
  case (.variable(let lhsValue), .variable(let rhsValue)):
    return lhsValue == rhsValue
  case (.block(let lhsValue), .block(let rhsValue)):
    return lhsValue == rhsValue
  case (.comment(let lhsValue), .comment(let rhsValue)):
    return lhsValue == rhsValue
  default:
    return false
  }
}
