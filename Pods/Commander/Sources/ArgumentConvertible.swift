public enum ArgumentError: ErrorType, Equatable, CustomStringConvertible {
  case MissingValue(argument: String?)

  /// Value is not convertible to type
  case InvalidType(value:String, type:String, argument:String?)

  /// Unused Argument
  case UnusedArgument(String)

  public var description: String {
    switch self {
    case .MissingValue(let key):
      if let key = key {
        return "Missing value for `\(key)`"
      }
      return "Missing argument"
    case .InvalidType(let value, let type, let argument):
      if let argument = argument {
        return "`\(value)` is not a valid `\(type)` for `\(argument)`"
      }
      return "`\(value)` is not a `\(type)`"
    case .UnusedArgument(let argument):
      return "Unexpected argument `\(argument)`"
    }
  }
}


public func == (lhs: ArgumentError, rhs: ArgumentError) -> Bool {
  switch (lhs, rhs) {
  case let (.MissingValue(lhsKey), .MissingValue(rhsKey)):
    return lhsKey == rhsKey
  case let (.InvalidType(lhsValue, lhsType, lhsArgument), .InvalidType(rhsValue, rhsType, rhsArgument)):
    return lhsValue == rhsValue && lhsType == rhsType && lhsArgument == rhsArgument
  case let (.UnusedArgument(lhsArgument), .UnusedArgument(rhsArgument)):
    return lhsArgument == rhsArgument
  default:
    return false
  }
}


public protocol ArgumentConvertible: CustomStringConvertible {
  /// Initialise the type with an ArgumentParser
  init(parser: ArgumentParser) throws
}

extension String : ArgumentConvertible, CustomStringConvertible {
  public init(parser: ArgumentParser) throws {
    if let value = parser.shift() {
      self.init(value)
    } else {
      throw ArgumentError.MissingValue(argument: nil)
    }
  }

  public var description: String {
    return self
  }
}

extension Int : ArgumentConvertible {
  public init(parser: ArgumentParser) throws {
    if let value = parser.shift() {
      if let value = Int(value) {
        self.init(value)
      } else {
        throw ArgumentError.InvalidType(value: value, type: "number", argument: nil)
      }
    } else {
      throw ArgumentError.MissingValue(argument: nil)
    }
  }
}


extension Float : ArgumentConvertible {
  public init(parser: ArgumentParser) throws {
    if let value = parser.shift() {
      if let value = Float(value) {
        self.init(value)
      } else {
        throw ArgumentError.InvalidType(value: value, type: "number", argument: nil)
      }
    } else {
      throw ArgumentError.MissingValue(argument: nil)
    }
  }
}


extension Double : ArgumentConvertible {
  public init(parser: ArgumentParser) throws {
    if let value = parser.shift() {
      if let value = Double(value) {
        self.init(value)
      } else {
        throw ArgumentError.InvalidType(value: value, type: "number", argument: nil)
      }
    } else {
      throw ArgumentError.MissingValue(argument: nil)
    }
  }
}


extension Array where Element : ArgumentConvertible {
  public init(parser: ArgumentParser) throws {
    var temp = [Element]()

    while true {
      do {
        temp.append(try Element(parser: parser))
      } catch ArgumentError.MissingValue {
        break
      } catch {
        throw error
      }
    }

    self.init(temp)
  }
}
