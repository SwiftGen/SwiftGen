/// A container for template variables.
public class Context : Equatable {
  var dictionaries:[[String:AnyObject]]

  /// Initialise a Context with a dictionary
  public init(dictionary:[String:AnyObject]) {
    dictionaries = [dictionary]
  }

  /// Initialise an empty Context
  public init() {
    dictionaries = []
  }

  public subscript(key: String) -> AnyObject? {
    /// Retrieves a variable's value, starting at the current context and going upwards
    get {
      for dictionary in Array(dictionaries.reverse()) {
        if let value = dictionary[key] {
          return value
        }
      }

      return nil
    }

    /// Set a variable in the current context, deleting the variable if it's nil
    set(value) {
      if var dictionary = dictionaries.popLast() {
        dictionary[key] = value
        dictionaries.append(dictionary)
      }
    }
  }

  /// Push a new level into the Context
  public func push(dictionary:[String:AnyObject]? = nil) {
    dictionaries.append(dictionary ?? [:])
  }

  /// Pop the last level off of the Context
  public func pop() -> [String:AnyObject]? {
    return dictionaries.popLast()
  }
}

public func ==(lhs:Context, rhs:Context) -> Bool {
  return lhs.dictionaries == rhs.dictionaries
}
