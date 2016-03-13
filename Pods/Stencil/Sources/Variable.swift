import Foundation


class FilterExpression : Resolvable {
  let filters: [Filter]
  let variable: Variable

  init(token: String, parser: TokenParser) throws {
    let bits = token.characters.split("|").map({ String($0).trim(" ") })
    if bits.isEmpty {
      filters = []
      variable = Variable("")
      throw TemplateSyntaxError("Variable tags must include at least 1 argument")
    }

    variable = Variable(bits[0])
    let filterBits = bits[1 ..< bits.endIndex]

    do {
      filters = try filterBits.map { try parser.findFilter($0) }
    } catch {
      filters = []
      throw error
    }
  }

  func resolve(context: Context) throws -> Any? {
    let result = try variable.resolve(context)

    return try filters.reduce(result) { x, y in
      return try y(x)
    }
  }
}

/// A structure used to represent a template variable, and to resolve it in a given context.
public struct Variable : Equatable, Resolvable {
  public let variable: String

  /// Create a variable with a string representing the variable
  public init(_ variable: String) {
    self.variable = variable
  }

  private func lookup() -> [String] {
    return variable.characters.split(".").map(String.init)
  }

  /// Resolve the variable in the given context
  public func resolve(context: Context) throws -> Any? {
    var current: Any? = context

    if (variable.hasPrefix("'") && variable.hasSuffix("'")) || (variable.hasPrefix("\"") && variable.hasSuffix("\"")) {
      // String literal
      return variable[variable.startIndex.successor() ..< variable.endIndex.predecessor()]
    }

    for bit in lookup() {
      current = normalize(current)

      if let context = current as? Context {
        current = context[bit]
      } else if let dictionary = current as? [String: Any] {
        current = dictionary[bit]
      } else if let array = current as? [Any] {
        if let index = Int(bit) {
          current = array[index]
        } else if bit == "first" {
          current = array.first
        } else if bit == "last" {
          current = array.last
        } else if bit == "count" {
          current = array.count
        }
      } else if let object = current as? NSObject {  // NSKeyValueCoding
#if os(Linux)
        return nil
#else
        current = object.valueForKey(bit)
#endif
      } else {
        return nil
      }
    }

    return normalize(current)
  }
}

public func ==(lhs: Variable, rhs: Variable) -> Bool {
  return lhs.variable == rhs.variable
}


func normalize(current: Any?) -> Any? {
  if let current = current as? Normalizable {
    return current.normalize()
  }

  return current
}

protocol Normalizable {
  func normalize() -> Any?
}

extension Array : Normalizable {
  func normalize() -> Any? {
    return map { $0 as Any }
  }
}

extension NSArray : Normalizable {
  func normalize() -> Any? {
    return map { $0 as Any }
  }
}

extension Dictionary : Normalizable {
  func normalize() -> Any? {
    var dictionary: [String: Any] = [:]

    for (key, value) in self {
      if let key = key as? String {
        dictionary[key] = Stencil.normalize(value)
      } else if let key = key as? CustomStringConvertible {
        dictionary[key.description] = Stencil.normalize(value)
      }
    }

    return dictionary
  }
}
