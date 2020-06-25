private enum Arg : CustomStringConvertible, Equatable {
  /// A positional argument
  case argument(String)

  /// A boolean like option, `--version`, `--help`, `--no-clean`.
  case option(String)

  /// A flag
  case flag([Character])

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


private func == (lhs: Arg, rhs: Arg) -> Bool {
  return lhs.description == rhs.description
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

  public typealias Option = String
  public typealias Flag = Character

  /// Initialises the ArgumentParser with an array of arguments
  public init(arguments: [String]) {
    let splitArguments = arguments.split(maxSplits: 1, omittingEmptySubsequences: false) { $0 == "--" }

    let unfixedArguments: [String]
    let fixedArguments: [String]
    if splitArguments.count == 2, let prefix = splitArguments.first, let suffix = splitArguments.last {
      unfixedArguments = Array(prefix)
      fixedArguments = Array(suffix)
    } else {
      unfixedArguments = arguments
      fixedArguments = []
    }

    self.arguments = unfixedArguments.map { argument in
      if argument.first == "-" {
        let flags = argument[argument.index(after: argument.startIndex)..<argument.endIndex]

        if flags.first == "-" {
          let option = flags[flags.index(after: flags.startIndex)..<flags.endIndex]
          return .option(String(option))
        }
        return .flag(Array(String(flags)))
      }

      return .argument(argument)
    }
    self.arguments.append(contentsOf: fixedArguments.map { .argument($0) })
  }

  public init(parser: ArgumentParser) throws {
    arguments = parser.arguments
  }

  public var description:String {
    return arguments.map { $0.description }.joined(separator: " ")
  }

  public var isEmpty: Bool {
    return arguments.first { $0 != .argument("") } == nil
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
  public func shiftValue(for name: Option) throws -> String? {
    return try shiftValues(for: name)?.first
  }

  /// Returns the value for an option (--name Kyle, --name=Kyle)
  public func shiftValues(for name: Option, count: Int = 1) throws -> [String]? {
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
  public func hasOption(_ name: Option) -> Bool {
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
  public func hasFlag(_ flag: Flag) -> Bool {
    var index = 0
    for argument in arguments {
      switch argument {
      case .flag(let option):
        var options = option
        if options.contains(flag) {
          options.removeAll(where: { $0 == flag })
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
  public func shiftValue(for flag: Flag) throws -> String? {
    return try shiftValues(for: flag)?.first
  }

  /// Returns the value for a flag (-n Kyle)
  public func shiftValues(for flag: Flag, count: Int = 1) throws -> [String]? {
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
  
  /// Returns the value for an option (--name Kyle, --name=Kyle) or flag (-n Kyle)
  public func shiftValue(for name: Option, or flag: Flag?) throws -> String? {
    if let value = try shiftValue(for: name) {
      return value
    } else if let flag = flag, let value = try shiftValue(for: flag) {
      return value
    }
    
    return nil
  }
  
  /// Returns the values for an option (--name Kyle, --name=Kyle) or flag (-n Kyle)
  public func shiftValues(for name: Option, or flag: Flag?, count: Int = 1) throws -> [String]? {
    if let value = try shiftValues(for: name, count: count) {
      return value
    } else if let flag = flag, let value = try shiftValues(for: flag, count: count) {
      return value
    }
    
    return nil
  }
}
