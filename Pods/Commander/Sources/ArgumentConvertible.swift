public enum ArgumentError : Error, Equatable, CustomStringConvertible {
  case missingValue(argument: String?)

  /// Value is not convertible to type
  case invalidType(value:String, type:String, argument:String?)

  /// Unused Argument
  case unusedArgument(String)

  public var description:String {
    switch self {
    case .missingValue(let key):
      if let key = key {
        return "Missing value for `\(key)`"
      }
      return "Missing argument"
    case .invalidType(let value, let type, let argument):
      if let argument = argument {
        return "`\(value)` is not a valid `\(type)` for `\(argument)`"
      }
      return "`\(value)` is not a `\(type)`"
    case .unusedArgument(let argument):
      return "Unexpected argument `\(argument)`"
    }
  }
}


public func == (lhs: ArgumentError, rhs: ArgumentError) -> Bool {
  switch (lhs, rhs) {
  case let (.missingValue(lhsKey), .missingValue(rhsKey)):
    return lhsKey == rhsKey
  case let (.invalidType(lhsValue, lhsType, lhsArgument), .invalidType(rhsValue, rhsType, rhsArgument)):
    return lhsValue == rhsValue && lhsType == rhsType && lhsArgument == rhsArgument
  case let (.unusedArgument(lhsArgument), .unusedArgument(rhsArgument)):
    return lhsArgument == rhsArgument
  default:
    return false
  }
}


public protocol ArgumentConvertible : CustomStringConvertible {
  /// Initialise the type with an ArgumentParser
  init(parser: ArgumentParser) throws
}

extension String : ArgumentConvertible {
  public init(parser: ArgumentParser) throws {
    if let value = parser.shift() {
      self.init(value)!
    } else {
      throw ArgumentError.missingValue(argument: nil)
    }
  }
}

extension Int : ArgumentConvertible {
  public init(parser: ArgumentParser) throws {
    if let value = parser.shift() {
      if let value = Int(value) {
        self.init(value)
      } else {
        throw ArgumentError.invalidType(value: value, type: "number", argument: nil)
      }
    } else {
      throw ArgumentError.missingValue(argument: nil)
    }
  }
}


extension Float : ArgumentConvertible {
  public init(parser: ArgumentParser) throws {
    if let value = parser.shift() {
      if let value = Float(value) {
        self.init(value)
      } else {
        throw ArgumentError.invalidType(value: value, type: "number", argument: nil)
      }
    } else {
      throw ArgumentError.missingValue(argument: nil)
    }
  }
}


extension Double : ArgumentConvertible {
  public init(parser: ArgumentParser) throws {
    if let value = parser.shift() {
      if let value = Double(value) {
        self.init(value)
      } else {
        throw ArgumentError.invalidType(value: value, type: "number", argument: nil)
      }
    } else {
      throw ArgumentError.missingValue(argument: nil)
    }
  }
}


extension Array where Element : ArgumentConvertible {
  public init(parser: ArgumentParser) throws {
    var temp = [Element]()

    while true {
      do {
        temp.append(try Element(parser: parser))
      } catch ArgumentError.missingValue {
        break
      } catch {
        throw error
      }
    }

    self.init(temp)
  }
}
