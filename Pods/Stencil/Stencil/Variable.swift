import Foundation


/// A structure used to represent a template variable, and to resolve it in a given context.
public struct Variable : Equatable {
  public let variable:String

  /// Create a variable with a string representing the variable
  public init(_ variable:String) {
    self.variable = variable
  }

  private func lookup() -> [String] {
    return variable.componentsSeparatedByString(".")
  }

  /// Resolve the variable in the given context
  public func resolve(context:Context) -> AnyObject? {
    var current:AnyObject? = context

    if (variable.hasPrefix("'") && variable.hasSuffix("'")) || (variable.hasPrefix("\"") && variable.hasSuffix("\"")) {
      return variable.substringWithRange(variable.startIndex.successor() ..< variable.endIndex.predecessor())
    }

    for bit in lookup() {
      if let context = current as? Context {
        current = context[bit]
      } else if let dictionary = current as? [String:AnyObject] {
        current = dictionary[bit]
      } else if let array = current as? [AnyObject] {
        if let index = Int(bit) {
          current = array[index]
        } else if bit == "first" {
          current = array.first
        } else if bit == "last" {
          current = array.last
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
