import Foundation

/// A structure used to represent a template variable, and to resolve it in a given context.
final class KeyPath {
  private var components = [String]()
  private var current = ""
  private var partialComponents = [String]()
  private var subscriptLevel = 0

  let variable: String
  let context: Context

  // Split the keypath string and resolve references if possible
  init(_ variable: String, in context: Context) {
    self.variable = variable
    self.context = context
  }

  func parse() throws -> [String] {
    defer {
      components = []
      current = ""
      partialComponents = []
      subscriptLevel = 0
    }

    for c in variable.characters {
      switch c {
      case "." where subscriptLevel == 0:
        try foundSeparator()
      case "[":
        try openBracket()
      case "]":
        try closeBracket()
      default:
        try addCharacter(c)
      }
    }
    try finish()

    return components
  }

  private func foundSeparator() throws {
    if !current.isEmpty {
      partialComponents.append(current)
    }

    guard !partialComponents.isEmpty else {
      throw TemplateSyntaxError("Unexpected '.' in variable '\(variable)'")
    }

    components += partialComponents
    current = ""
    partialComponents = []
  }

  // when opening the first bracket, we must have a partial component
  private func openBracket() throws {
    guard !partialComponents.isEmpty || !current.isEmpty else {
      throw TemplateSyntaxError("Unexpected '[' in variable '\(variable)'")
    }

    if subscriptLevel > 0 {
      current.append("[")
    } else if !current.isEmpty {
      partialComponents.append(current)
      current = ""
    }

    subscriptLevel += 1
  }

  // for a closing bracket at root level, try to resolve the reference
  private func closeBracket() throws {
    guard subscriptLevel > 0 else {
      throw TemplateSyntaxError("Unbalanced ']' in variable '\(variable)'")
    }

    if subscriptLevel > 1 {
      current.append("]")
    } else if !current.isEmpty,
      let value = try Variable(current).resolve(context) {
      partialComponents.append("\(value)")
      current = ""
    } else {
      throw TemplateSyntaxError("Unable to resolve subscript '\(current)' in variable '\(variable)'")
    }

    subscriptLevel -= 1
  }

  private func addCharacter(_ c: Character) throws {
    guard partialComponents.isEmpty || subscriptLevel > 0 else {
      throw TemplateSyntaxError("Unexpected character '\(c)' in variable '\(variable)'")
    }

    current.append(c)
  }

  private func finish() throws {
    // check if we have a last piece
    if !current.isEmpty {
      partialComponents.append(current)
    }
    components += partialComponents

    guard subscriptLevel == 0 else {
      throw TemplateSyntaxError("Unbalanced subscript brackets in variable '\(variable)'")
    }
  }
}
