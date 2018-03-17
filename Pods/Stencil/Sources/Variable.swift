import Foundation


typealias Number = Float


class FilterExpression : Resolvable {
  let filters: [(FilterType, [Variable])]
  let variable: Variable

  init(token: String, parser: TokenParser) throws {
    let bits = token.characters.split(separator: "|").map({ String($0).trim(character: " ") })
    if bits.isEmpty {
      filters = []
      variable = Variable("")
      throw TemplateSyntaxError("Variable tags must include at least 1 argument")
    }

    variable = Variable(bits[0])
    let filterBits = bits[bits.indices.suffix(from: 1)]

    do {
      filters = try filterBits.map {
        let (name, arguments) = parseFilterComponents(token: $0)
        let filter = try parser.findFilter(name)
        return (filter, arguments)
      }
    } catch {
      filters = []
      throw error
    }
  }

  func resolve(_ context: Context) throws -> Any? {
    let result = try variable.resolve(context)

    return try filters.reduce(result) { x, y in
      let arguments = try y.1.map { try $0.resolve(context) }
      return try y.0.invoke(value: x, arguments: arguments)
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

  fileprivate func lookup() -> [String] {
    return variable.characters.split(separator: ".").map(String.init)
  }

  /// Resolve the variable in the given context
  public func resolve(_ context: Context) throws -> Any? {
    var current: Any? = context

    if (variable.hasPrefix("'") && variable.hasSuffix("'")) || (variable.hasPrefix("\"") && variable.hasSuffix("\"")) {
      // String literal
      return variable[variable.characters.index(after: variable.startIndex) ..< variable.characters.index(before: variable.endIndex)]
    }

    if let number = Number(variable) {
      // Number literal
      return number
    }

    for bit in lookup() {
      current = normalize(current)

      if let context = current as? Context {
        current = context[bit]
      } else if let dictionary = current as? [String: Any] {
        if bit == "count" {
          current = dictionary.count
        } else {
          current = dictionary[bit]
        }
      } else if let array = current as? [Any] {
        if let index = Int(bit) {
          if index >= 0 && index < array.count {
            current = array[index]
          } else {
            current = nil
          }
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
        current = object.value(forKey: bit)
#endif
      } else if let value = current {
        let mirror = Mirror(reflecting: value)
        current = mirror.descendant(bit)

        if current == nil {
          return nil
          // mirror returns non-nil value even for nil-containing properties
          // so we have to check if its value is actually nil or not
        } else if let current = current, String(describing: current) == "nil" {
          return nil
        }
      } else {
        return nil
      }
    }

    if let resolvable = current as? Resolvable {
      current = try resolvable.resolve(context)
    } else if let node = current as? NodeType {
      current = try node.render(context)
    }

    return normalize(current)
  }
}

public func ==(lhs: Variable, rhs: Variable) -> Bool {
  return lhs.variable == rhs.variable
}


func normalize(_ current: Any?) -> Any? {
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

func parseFilterComponents(token: String) -> (String, [Variable]) {
  var components = token.smartSplit(separator: ":")
  let name = components.removeFirst()
  let variables = components
    .joined(separator: ":")
    .smartSplit(separator: ",")
    .map { Variable($0) }
  return (name, variables)
}
