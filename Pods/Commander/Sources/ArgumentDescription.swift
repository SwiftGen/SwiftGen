public enum ArgumentType {
  case Argument
  case Option
}

public protocol ArgumentDescriptor {
  typealias ValueType

  /// The arguments name
  var name: String { get }

  /// The arguments description
  var description: String? { get }

  var type: ArgumentType { get }

  /// Parse the argument
  func parse(parser: ArgumentParser) throws -> ValueType
}

extension ArgumentConvertible {
  init(string: String) throws {
    try self.init(parser: ArgumentParser(arguments: [string]))
  }
}

public class VaradicArgument<T : ArgumentConvertible> : ArgumentDescriptor {
  public typealias ValueType = [T]

  public let name: String
  public let description: String?

  public var type: ArgumentType { return .Argument }

  public init(_ name: String, description: String? = nil) {
    self.name = name
    self.description = description
  }

  public func parse(parser: ArgumentParser) throws -> ValueType {
    return try Array<T>(parser: parser)
  }
}

public class Argument<T : ArgumentConvertible> : ArgumentDescriptor {
  public typealias ValueType = T
  public typealias Validator = ValueType throws -> ValueType

  public let name: String
  public let description: String?
  public let validator: Validator?

  public var type: ArgumentType { return .Argument }

  public init(_ name: String, description: String? = nil, validator: Validator? = nil) {
    self.name = name
    self.description = description
    self.validator = validator
  }

  public func parse(parser: ArgumentParser) throws -> ValueType {
    let value: T

    do {
      value = try T(parser: parser)
    } catch ArgumentError.MissingValue {
      throw ArgumentError.MissingValue(argument: name)
    } catch {
      throw error
    }

    if let validator = validator {
      return try validator(value)
    }

    return value
  }
}


public class Option<T : ArgumentConvertible> : ArgumentDescriptor {
  public typealias ValueType = T
  public typealias Validator = ValueType throws -> ValueType

  public let name: String
  public let flag: Character?
  public let description: String?
  public let `default`:ValueType
  public var type: ArgumentType { return .Option }
  public let validator: Validator?

  public init(_ name: String, _ `default`:ValueType, flag: Character? = nil, description: String? = nil, validator: Validator? = nil) {
    self.name = name
    self.flag = flag
    self.description = description
    self.`default` = `default`
    self.validator = validator
  }

  public func parse(parser: ArgumentParser) throws -> ValueType {
    if let value = try parser.shiftValueForOption(name) {
      let value = try T(string: value)

      if let validator = validator {
        return try validator(value)
      }

      return value
    }

    if let flag = flag {
      if let value = try parser.shiftValueForFlag(flag) {
        let value = try T(string: value)

        if let validator = validator {
          return try validator(value)
        }

        return value
      }
    }

    return `default`
  }
}

public class Options<T : ArgumentConvertible> : ArgumentDescriptor {
  public typealias ValueType = [T]

  public let name: String
  public let description: String?
  public let count: Int
  public let `default`:ValueType
  public var type: ArgumentType { return .Option }

  public init(_ name: String, _ `default`:ValueType, count: Int, description: String? = nil) {
    self.name = name
    self.`default` = `default`
    self.count = count
    self.description = description
  }

  public func parse(parser: ArgumentParser) throws -> ValueType {
    let values = try parser.shiftValuesForOption(name, count: count)
    return try values?.map { try T(string: $0) } ?? `default`
  }
}

public class Flag: ArgumentDescriptor {
  public typealias ValueType = Bool

  public let name: String
  public let flag: Character?
  public let disabledName: String
  public let disabledFlag: Character?
  public let description: String?
  public let `default`:ValueType
  public var type: ArgumentType { return .Option }

  public init(_ name: String, flag: Character? = nil, disabledName: String? = nil, disabledFlag: Character? = nil, description: String? = nil, `default`:Bool = false) {
    self.name = name
    self.disabledName = disabledName ?? "no-\(name)"
    self.flag = flag
    self.disabledFlag = disabledFlag
    self.description = description
    self.`default` = `default`
  }

  public func parse(parser: ArgumentParser) throws -> ValueType {
    if parser.hasOption(disabledName) {
      return false
    }

    if parser.hasOption(name) {
      return true
    }

    if let flag = flag {
      if parser.hasFlag(flag) {
        return true
      }
    }
    if let disabledFlag = disabledFlag {
      if parser.hasFlag(disabledFlag) {
        return false
      }
    }

    return `default`
  }
}

class BoxedArgumentDescriptor {
  let name: String
  let description: String?
  let `default`:String?
  let type: ArgumentType

  init<T: ArgumentDescriptor>(value: T) {
    name = value.name
    description = value.description
    type = value.type

    if let value = value as? Flag {
      `default` = value.`default`.description
    } else {
      // TODO, default for Option and Options
      `default` = nil
    }
  }
}

class UsageError: ErrorType, CustomStringConvertible {
  let message: String
  let help: Help

  init(_ message: String, _ help: Help) {
    self.message = message
    self.help = help
  }

  var description: String {
    return [message, help.description].filter { !$0.isEmpty }.joinWithSeparator("\n\n")
  }
}

class Help: ErrorType, CustomStringConvertible {
  let command: String?
  let group: Group?
  let descriptors: [BoxedArgumentDescriptor]

  init(_ descriptors: [BoxedArgumentDescriptor], command: String? = nil, group: Group? = nil) {
    self.command = command
    self.group = group
    self.descriptors = descriptors
  }

  func reraise(command: String? = nil) -> Help {
    if let oldCommand = self.command, newCommand = command {
      return Help(descriptors, command: "\(newCommand) \(oldCommand)")
    }
    return Help(descriptors, command: command ?? self.command)
  }

  var description: String {
    var output = [String]()

    let arguments = descriptors.filter { $0.type == ArgumentType.Argument }
    let options = descriptors.filter { $0.type == ArgumentType.Option }

    if let command = command {
      let args = arguments.map { "<\($0.name)>" }
      let usage = ([command] + args).joinWithSeparator(" ")

      output.append("Usage:")
      output.append("")
      output.append("    \(usage)")
      output.append("")
    }

    if let group = group {
      output.append("Commands:")
      output.append("")
      for command in group.commands {
        if let description = command.description {
          output.append("    + \(command.name) - \(description)")
        } else {
          output.append("    + \(command.name)")
        }
      }
      output.append("")
    }

    if !options.isEmpty {
      output.append("Options:")
      for option in options {
        // TODO: default, [default: `\(`default`)`]

        if let description = option.description {
          output.append("    --\(option.name) - \(description)")
        } else {
          output.append("    --\(option.name)")
        }
      }
    }

    return output.joinWithSeparator("\n")
  }
}
