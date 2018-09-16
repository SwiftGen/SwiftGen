import Foundation


typealias Number = Float


class FilterExpression : Resolvable {
  let filters: [(FilterType, [Variable])]
  let variable: Variable

  init(token: String, parser: TokenParser) throws {
    let bits = token.characters.split(separator: "|").map({ String($0).trim(character: " ") })
    if bits.isEmpty {
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

  // Split the lookup string and resolve references if possible
  fileprivate func lookup(_ context: Context) throws -> [String] {
    let keyPath = KeyPath(variable, in: context)
    return try keyPath.parse()
  }

  /// Resolve the variable in the given context
  public func resolve(_ context: Context) throws -> Any? {
    var current: Any? = context

    if (variable.hasPrefix("'") && variable.hasSuffix("'")) || (variable.hasPrefix("\"") && variable.hasSuffix("\"")) {
      // String literal
      return String(variable[variable.characters.index(after: variable.startIndex) ..< variable.characters.index(before: variable.endIndex)])
    }

    // Number literal
    if let int = Int(variable) {
      return int
    }
    if let number = Number(variable) {
      return number
    }
    // Boolean literal
    if let bool = Bool(variable) {
      return bool
    }

    for bit in try lookup(context) {
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
        current = Mirror(reflecting: value).getValue(for: bit)
        if current == nil {
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

/// A structure used to represet range of two integer values expressed as `from...to`.
/// Values should be numbers (they will be converted to integers).
/// Rendering this variable produces array from range `from...to`.
/// If `from` is more than `to` array will contain values of reversed range.
public struct RangeVariable: Resolvable {
  public let from: Resolvable
  public let to: Resolvable

  @available(*, deprecated, message: "Use init?(_:parser:containedIn:)")
  public init?(_ token: String, parser: TokenParser) throws {
    let components = token.components(separatedBy: "...")
    guard components.count == 2 else {
      return nil
    }

    self.from = try parser.compileFilter(components[0])
    self.to = try parser.compileFilter(components[1])
  }

  public init?(_ token: String, parser: TokenParser, containedIn containingToken: Token) throws {
    let components = token.components(separatedBy: "...")
    guard components.count == 2 else {
      return nil
    }

    self.from = try parser.compileFilter(components[0], containedIn: containingToken)
    self.to = try parser.compileFilter(components[1], containedIn: containingToken)
  }

  public func resolve(_ context: Context) throws -> Any? {
    let fromResolved = try from.resolve(context)
    let toResolved = try to.resolve(context)

    guard let from = fromResolved.flatMap(toNumber(value:)).flatMap(Int.init) else {
      throw TemplateSyntaxError("'from' value is not an Integer (\(fromResolved ?? "nil"))")
    }

    guard let to = toResolved.flatMap(toNumber(value:)).flatMap(Int.init) else {
      throw TemplateSyntaxError("'to' value is not an Integer (\(toResolved ?? "nil") )")
    }

    let range = min(from, to)...max(from, to)
    return from > to ? Array(range.reversed()) : Array(range)
  }

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
  let name = components.removeFirst().trim(character: " ")
  let variables = components
    .joined(separator: ":")
    .smartSplit(separator: ",")
    .map { Variable($0.trim(character: " ")) }
  return (name, variables)
}

extension Mirror {
  func getValue(for key: String) -> Any? {
    let result = descendant(key) ?? Int(key).flatMap({ descendant($0) })
    if result == nil {
      // go through inheritance chain to reach superclass properties
      return superclassMirror?.getValue(for: key)
    } else if let result = result {
      guard String(describing: result) != "nil" else {
        // mirror returns non-nil value even for nil-containing properties
        // so we have to check if its value is actually nil or not
        return nil
      }
      if let result = (result as? AnyOptional)?.wrapped {
        return result
      } else {
        return result
      }
    }
    return result
  }
}

protocol AnyOptional {
  var wrapped: Any? { get }
}

extension Optional: AnyOptional {
  var wrapped: Any? {
    switch self {
    case let .some(value): return value
    case .none: return nil
    }
  }
}


