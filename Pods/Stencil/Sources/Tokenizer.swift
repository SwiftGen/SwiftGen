import Foundation


/// Split a string by spaces leaving quoted phrases together
func smartSplit(value: String) -> [String] {
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
  case Text(value: String)

  /// A token representing a variable.
  case Variable(value: String)

  /// A token representing a comment.
  case Comment(value: String)

  /// A token representing a template block.
  case Block(value: String)

  /// Returns the underlying value as an array seperated by spaces
  public func components() -> [String] {
    switch self {
    case .Block(let value):
      return smartSplit(value)
    case .Variable(let value):
      return smartSplit(value)
    case .Text(let value):
      return smartSplit(value)
    case .Comment(let value):
      return smartSplit(value)
    }
  }

  public var contents: String {
    switch self {
    case .Block(let value):
      return value
    case .Variable(let value):
      return value
    case .Text(let value):
      return value
    case .Comment(let value):
      return value
    }
  }
}


public func == (lhs: Token, rhs: Token) -> Bool {
  switch (lhs, rhs) {
  case (.Text(let lhsValue), .Text(let rhsValue)):
    return lhsValue == rhsValue
  case (.Variable(let lhsValue), .Variable(let rhsValue)):
    return lhsValue == rhsValue
  case (.Block(let lhsValue), .Block(let rhsValue)):
    return lhsValue == rhsValue
  case (.Comment(let lhsValue), .Comment(let rhsValue)):
    return lhsValue == rhsValue
  default:
    return false
  }
}
