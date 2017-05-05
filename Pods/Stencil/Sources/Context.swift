/// A container for template variables.
public class Context {
  var dictionaries: [[String: Any?]]

  public let environment: Environment

  init(dictionary: [String: Any]? = nil, environment: Environment? = nil) {
    if let dictionary = dictionary {
      dictionaries = [dictionary]
    } else {
      dictionaries = []
    }

    self.environment = environment ?? Environment()
  }

  public subscript(key: String) -> Any? {
    /// Retrieves a variable's value, starting at the current context and going upwards
    get {
      for dictionary in Array(dictionaries.reversed()) {
        if let value = dictionary[key] {
          return value
        }
      }

      return nil
    }

    /// Set a variable in the current context, deleting the variable if it's nil
    set(value) {
      if let dictionary = dictionaries.popLast() {
        var mutable_dictionary = dictionary
        mutable_dictionary[key] = value
        dictionaries.append(mutable_dictionary)
      }
    }
  }

  /// Push a new level into the Context
  fileprivate func push(_ dictionary: [String: Any]? = nil) {
    dictionaries.append(dictionary ?? [:])
  }

  /// Pop the last level off of the Context
  fileprivate func pop() -> [String: Any?]? {
    return dictionaries.popLast()
  }

  /// Push a new level onto the context for the duration of the execution of the given closure
  public func push<Result>(dictionary: [String: Any]? = nil, closure: (() throws -> Result)) rethrows -> Result {
    push(dictionary)
    defer { _ = pop() }
    return try closure()
  }

  public func flatten() -> [String: Any] {
    var accumulator: [String: Any] = [:]

    for dictionary in dictionaries {
      for (key, value) in dictionary {
        if let value = value {
          accumulator.updateValue(value, forKey: key)
        }
      }
    }

    return accumulator
  }
}
