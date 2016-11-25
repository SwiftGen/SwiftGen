private enum Arg : CustomStringConvertible {
  /// A positional argument
  case argument(String)

  /// A boolean like option, `--version`, `--help`, `--no-clean`.
  case option(String)

  /// A flag
  case flag(Set<Character>)

  var description:String {
    switch self {
    case .argument(let value):
      return value
    case .option(let key):
      return "--\(key)"
    case .flag(let flags):
      return "-\(String(flags))"
    }
  }

  var type:String {
    switch self {
    case .argument:
      return "argument"
    case .option:
      return "option"
    case .flag:
      return "flag"
    }
  }
}


public struct ArgumentParserError : Error, Equatable, CustomStringConvertible {
  public let description: String

  public init(_ description: String) {
    self.description = description
  }
}


public func ==(lhs: ArgumentParserError, rhs: ArgumentParserError) -> Bool {
  return lhs.description == rhs.description
}


public final class ArgumentParser : ArgumentConvertible, CustomStringConvertible {
  fileprivate var arguments:[Arg]

  /// Initialises the ArgumentParser with an array of arguments
  public init(arguments: [String]) {
    self.arguments = arguments.map { argument in
      if argument.characters.first == "-" {
        let flags = argument[argument.characters.index(after: argument.startIndex)..<argument.endIndex]

        if flags.characters.first == "-" {
          let option = flags[flags.characters.index(after: flags.startIndex)..<flags.endIndex]
          return .option(option)
        }

        return .flag(Set(flags.characters))
      }

      return .argument(argument)
    }
  }

  public init(parser: ArgumentParser) throws {
    arguments = parser.arguments
  }

  public var description:String {
    return arguments.map { $0.description }.joined(separator: " ")
  }

  public var isEmpty:Bool {
    return arguments.isEmpty
  }

  public var remainder:[String] {
    return arguments.map { $0.description }
  }

  /// Returns the first positional argument in the remaining arguments.
  /// This will remove the argument from the remaining arguments.
  public func shift() -> String? {
    for (index, argument) in arguments.enumerated() {
      switch argument {
      case .argument(let value):
        arguments.remove(at: index)
        return value
      default:
        continue
      }
    }

    return nil
  }

  /// Returns the value for an option (--name Kyle, --name=Kyle)
  public func shiftValueForOption(_ name:String) throws -> String? {
    return try shiftValuesForOption(name)?.first
  }

  /// Returns the value for an option (--name Kyle, --name=Kyle)
  public func shiftValuesForOption(_ name:String, count:Int = 1) throws -> [String]? {
    var index = 0
    var hasOption = false

    for argument in arguments {
      switch argument {
      case .option(let option):
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
      arguments.remove(at: index)  // Pop option
      return try (0..<count).map { i in
        if arguments.count > index {
          let argument = arguments.remove(at: index)
          switch argument {
          case .argument(let value):
            return value
          default:
            throw ArgumentParserError("Unexpected \(argument.type) `\(argument)` as a value for `--\(name)`")
          }
        }

        throw ArgumentError.missingValue(argument: "--\(name)")
      }
    }

    return nil
  }

  /// Returns whether an option was specified in the arguments
  public func hasOption(_ name:String) -> Bool {
    var index = 0
    for argument in arguments {
      switch argument {
      case .option(let option):
        if option == name {
          arguments.remove(at: index)
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
  public func hasFlag(_ flag:Character) -> Bool {
    var index = 0
    for argument in arguments {
      switch argument {
      case .flag(let option):
        var options = option
        if options.contains(flag) {
          options.remove(flag)
          arguments.remove(at: index)

          if !options.isEmpty {
            arguments.insert(.flag(options), at: index)
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
  public func shiftValueForFlag(_ flag:Character) throws -> String? {
    return try shiftValuesForFlag(flag)?.first
  }

  /// Returns the value for a flag (-n Kyle)
  public func shiftValuesForFlag(_ flag:Character, count:Int = 1) throws -> [String]? {
    var index = 0
    var hasFlag = false

    for argument in arguments {
      switch argument {
      case .flag(let flags):
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
      arguments.remove(at: index)

      return try (0..<count).map { i in
        if arguments.count > index {
          let argument = arguments.remove(at: index)
          switch argument {
          case .argument(let value):
            return value
          default:
            throw ArgumentParserError("Unexpected \(argument.type) `\(argument)` as a value for `-\(flag)`")
          }
        }

        throw ArgumentError.missingValue(argument: "-\(flag)")
      }
    }

    return nil
  }
}
