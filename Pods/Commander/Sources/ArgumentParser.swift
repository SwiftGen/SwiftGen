private enum Arg: CustomStringConvertible {
  /// A positional argument
  case Argument(String)

  /// A boolean like option, `--version`, `--help`, `--no-clean`.
  case Option(String)

  /// A flag
  case Flag(Set<Character>)

  var description: String {
    switch self {
    case .Argument(let value):
      return value
    case .Option(let key):
      return "--\(key)"
    case .Flag(let flags):
      return "-\(String(flags))"
    }
  }

  var type: String {
    switch self {
    case .Argument:
      return "argument"
    case .Option:
      return "option"
    case .Flag:
      return "flag"
    }
  }
}


public struct ArgumentParserError: ErrorType, Equatable, CustomStringConvertible {
  public let description: String

  public init(_ description: String) {
    self.description = description
  }
}


public func ==(lhs: ArgumentParserError, rhs: ArgumentParserError) -> Bool {
  return lhs.description == rhs.description
}


public final class ArgumentParser: ArgumentConvertible, CustomStringConvertible {
  private var arguments: [Arg]

  /// Initialises the ArgumentParser with an array of arguments
  public init(arguments: [String]) {
    self.arguments = arguments.map { argument in
      if argument.characters.first == "-" {
        let flags = argument[argument.startIndex.successor()..<argument.endIndex]

        if flags.characters.first == "-" {
          let option = flags[flags.startIndex.successor()..<flags.endIndex]
          return .Option(option)
        }

        return .Flag(Set(flags.characters))
      }

      return .Argument(argument)
    }
  }

  public init(parser: ArgumentParser) throws {
    arguments = parser.arguments
  }

  public var description: String {
    return arguments.map { $0.description }.joinWithSeparator(" ")
  }

  public var isEmpty: Bool {
    return arguments.isEmpty
  }

  public var remainder: [String] {
    return arguments.map { $0.description }
  }

  /// Returns the first positional argument in the remaining arguments.
  /// This will remove the argument from the remaining arguments.
  public func shift() -> String? {
    for (index, argument) in arguments.enumerate() {
      switch argument {
      case .Argument(let value):
        arguments.removeAtIndex(index)
        return value
      default:
        continue
      }
    }

    return nil
  }

  /// Returns the value for an option (--name Kyle, --name=Kyle)
  public func shiftValueForOption(name: String) throws -> String? {
    return try shiftValuesForOption(name)?.first
  }

  /// Returns the value for an option (--name Kyle, --name=Kyle)
  public func shiftValuesForOption(name: String, count: Int = 1) throws -> [String]? {
    var index = 0
    var hasOption = false

    for argument in arguments {
      switch argument {
      case .Option(let option):
        if option == name {
          hasOption = true
          break
        }
        fallthrough
      default:
        index += 1
      }

      if hasOption {
        break
      }
    }

    if hasOption {
      arguments.removeAtIndex(index)  // Pop option
      return try (0..<count).map { i in
        if arguments.count > index {
          let argument = arguments.removeAtIndex(index)
          switch argument {
          case .Argument(let value):
            return value
          default:
            throw ArgumentParserError("Unexpected \(argument.type) `\(argument)` as a value for `--\(name)`")
          }
        }

        throw ArgumentError.MissingValue(argument: "--\(name)")
      }
    }

    return nil
  }

  /// Returns whether an option was specified in the arguments
  public func hasOption(name: String) -> Bool {
    var index = 0
    for argument in arguments {
      switch argument {
      case .Option(let option):
        if option == name {
          arguments.removeAtIndex(index)
          return true
        }
      default:
        break
      }

      index += 1
    }

    return false
  }

  /// Returns whether a flag was specified in the arguments
  public func hasFlag(flag: Character) -> Bool {
    var index = 0
    for argument in arguments {
      switch argument {
      case .Flag(let option):
        var options = option
        if options.contains(flag) {
          options.remove(flag)
          arguments.removeAtIndex(index)

          if !options.isEmpty {
            arguments.insert(.Flag(options), atIndex: index)
          }
          return true
        }
      default:
        break
      }

      index += 1
    }

    return false
  }

  /// Returns the value for a flag (-n Kyle)
  public func shiftValueForFlag(flag: Character) throws -> String? {
    return try shiftValuesForFlag(flag)?.first
  }

  /// Returns the value for a flag (-n Kyle)
  public func shiftValuesForFlag(flag: Character, count: Int = 1) throws -> [String]? {
    var index = 0
    var hasFlag = false

    for argument in arguments {
      switch argument {
      case .Flag(let flags):
        if flags.contains(flag) {
          hasFlag = true
          break
        }
        fallthrough
      default:
        index += 1
      }

      if hasFlag {
        break
      }
    }

    if hasFlag {
      arguments.removeAtIndex(index)

      return try (0..<count).map { i in
        if arguments.count > index {
          let argument = arguments.removeAtIndex(index)
          switch argument {
          case .Argument(let value):
            return value
          default:
            throw ArgumentParserError("Unexpected \(argument.type) `\(argument)` as a value for `-\(flag)`")
          }
        }

        throw ArgumentError.MissingValue(argument: "-\(flag)")
      }
    }

    return nil
  }
}
