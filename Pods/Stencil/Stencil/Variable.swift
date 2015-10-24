import Foundation


class FilterExpression : Resolvable {
  let filters: [Filter]
  let variable: Variable

  init(token: String, parser: TokenParser) throws {
    let bits = token.componentsSeparatedByString("|")
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

  func resolve(context: Context) -> Any? {
    let result = variable.resolve(context)

    return filters.reduce(result) { x, y in
      return y(x)
    }
  }
}

/// A structure used to represent a template variable, and to resolve it in a given context.
public struct Variable : Equatable, Resolvable {
  public let variable:String

  /// Create a variable with a string representing the variable
  public init(_ variable:String) {
    self.variable = variable
  }

  private func lookup() -> [String] {
    return variable.componentsSeparatedByString(".")
  }

  /// Resolve the variable in the given context
  public func resolve(context:Context) -> Any? {
    var current: Any? = context

    if (variable.hasPrefix("'") && variable.hasSuffix("'")) || (variable.hasPrefix("\"") && variable.hasSuffix("\"")) {
      // String literal
      return variable[variable.startIndex.successor() ..< variable.endIndex.predecessor()]
    }

    for bit in lookup() {
      if let context = current as? Context {
        current = context[bit]
      } else if let dictionary = current as? [String: Any] {
        current = dictionary[bit]
      } else if let dictionary = current as? [String: AnyObject] {
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
      } else if let array = current as? NSArray {
        if let index = Int(bit) {
          current = array[index]
        } else if bit == "first" {
          current = array.firstObject
        } else if bit == "last" {
          current = array.lastObject
        } else if bit == "count" {
          current = array.count
        }
      } else if let object = current as? NSObject {
        current = object.valueForKey(bit)
      } else {
        return nil
      }
    }

    return current
  }
}

public func ==(lhs:Variable, rhs:Variable) -> Bool {
  return lhs.variable == rhs.variable
}
