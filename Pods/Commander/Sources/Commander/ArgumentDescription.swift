public enum ArgumentType {
  case argument
  case option
}


public protocol ArgumentDescriptor {
  associatedtype ValueType

  /// The arguments name
  var name: String { get }

  /// The arguments description
  var description: String? { get }

  var type: ArgumentType { get }

  /// Parse the argument
  func parse(_ parser: ArgumentParser) throws -> ValueType
}


extension ArgumentConvertible {
  init(string: String) throws {
    try self.init(parser: ArgumentParser(arguments: [string]))
  }
}


public class VariadicArgument<T : ArgumentConvertible> : ArgumentDescriptor {
  public typealias ValueType = [T]
  public typealias Validator = (ValueType) throws -> ValueType

  public let name: String
  public let description: String?
  public let validator: Validator?
  public var type: ArgumentType { return .argument }

  public init(_ name: String, description: String? = nil, validator: Validator? = nil) {
    self.name = name
    self.description = description
    self.validator = validator
  }

  public func parse(_ parser: ArgumentParser) throws -> ValueType {
    let value = try Array<T>(parser: parser)

    if let validator = validator {
      return try validator(value)
    }

    return value
  }
}

@available(*, deprecated, message: "use VariadicArgument instead")
typealias VaradicArgument<T : ArgumentConvertible> = VariadicArgument<T>


public class Argument<T : ArgumentConvertible> : ArgumentDescriptor {
  public typealias ValueType = T
  public typealias Validator = (ValueType) throws -> ValueType

  public let name: String
  public let description: String?
  public let validator: Validator?
  public var type: ArgumentType { return .argument }

  public init(_ name: String, description: String? = nil, validator: Validator? = nil) {
    self.name = name
    self.description = description
    self.validator = validator
  }

  public func parse(_ parser: ArgumentParser) throws -> ValueType {
    let value: T

    do {
      value = try T(parser: parser)
    } catch ArgumentError.missingValue {
      throw ArgumentError.missingValue(argument: name)
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
  public typealias Validator = (ValueType) throws -> ValueType

  public let name: String
  public let `default`: ValueType
  public let flag: Character?
  public let description: String?
  public let validator: Validator?
  public var type: ArgumentType { return .option }

  public init(_ name: String, default: ValueType, flag: Character? = nil, description: String? = nil, validator: Validator? = nil) {
    self.name = name
    self.`default` = `default`
    self.flag = flag
    self.description = description
    self.validator = validator
  }
  
  @available(*, deprecated, message: "use init(_:default:flag:description:validator:) instead")
  public convenience init(_ name: String, _ default: ValueType, flag: Character? = nil, description: String? = nil, validator: Validator? = nil) {
    self.init(name, default: `default`, flag: flag, description: description, validator: validator)
  }

  public func parse(_ parser: ArgumentParser) throws -> ValueType {
    guard let shifted = try parser.shiftValue(for: name, or: flag) else { return `default` }
    let value = try T(string: shifted)
        
    if let validator = validator {
      return try validator(value)
    }
    
    return value
  }
}


public class Options<T : ArgumentConvertible> : ArgumentDescriptor {
  public typealias ValueType = [T]
  public typealias Validator = (ValueType) throws -> ValueType

  public let name: String
  public let `default`: ValueType
  public let flag: Character?
  public let count: Int
  public let description: String?
  public let validator: Validator?
  public var type: ArgumentType { return .option }

  public init(_ name: String, default: ValueType, flag: Character? = nil, count: Int, description: String? = nil, validator: Validator? = nil) {
    self.name = name
    self.`default` = `default`
    self.flag = flag
    self.count = count
    self.description = description
    self.validator = validator
  }
  
  @available(*, deprecated, message: "use init(_:default:flag:count:description:validator:) instead")
  public convenience init(_ name: String, _ default: ValueType, flag: Character? = nil, count: Int, description: String? = nil, validator: Validator? = nil) {
    self.init(name, default: `default`, flag: flag, count: count, description: description, validator: validator)
  }

  public func parse(_ parser: ArgumentParser) throws -> ValueType {
    guard let shifted = try parser.shiftValues(for: name, or: flag, count: count) else { return `default` }
    let values = try shifted.map { try T(string: $0) }
    
    if let validator = validator {
      return try validator(values)
    }
    
    return values
  }
}


public class VariadicOption<T : ArgumentConvertible> : ArgumentDescriptor {
  public typealias ValueType = [T]
  public typealias Validator = (ValueType) throws -> ValueType

  public let name: String
  public let `default`: ValueType
  public let flag: Character?
  public let description: String?
  public let validator: Validator?
  public var type: ArgumentType { return .option }

  public init(_ name: String, default: ValueType = [], flag: Character? = nil, description: String? = nil, validator: Validator? = nil) {
    self.name = name
    self.`default` = `default`
    self.flag = flag
    self.description = description
    self.validator = validator
  }
  
  @available(*, deprecated, message: "use init(_:default:flag:description:validator:) instead")
  public convenience init(_ name: String, _ default: ValueType, flag: Character? = nil, description: String? = nil, validator: Validator? = nil) {
    self.init(name, default: `default`, flag: flag, description: description, validator: validator)
  }

  public func parse(_ parser: ArgumentParser) throws -> ValueType {
    var values: ValueType? = nil

    while let shifted = try parser.shiftValue(for: name, or: flag) {
      let argument = try T(string: shifted)

      if values == nil {
        values = ValueType()
      }
      values?.append(argument)
    }

    if let validator = validator, let values = values {
      return try validator(values)
    }
    
    return values ?? `default`
  }
}


public class Flag : ArgumentDescriptor {
  public typealias ValueType = Bool

  public let name: String
  public let `default`: ValueType
  public let flag: Character?
  public let disabledName: String
  public let disabledFlag: Character?
  public let description: String?
  public var type: ArgumentType { return .option }

  public init(_ name: String, default: Bool = false, flag: Character? = nil, disabledName: String? = nil, disabledFlag: Character? = nil, description: String? = nil) {
    self.name = name
    self.`default` = `default`
    self.disabledName = disabledName ?? "no-\(name)"
    self.flag = flag
    self.disabledFlag = disabledFlag
    self.description = description
  }
  
  @available(*, deprecated, message: "use init(_:default:flag:disabledName:disabledFlag:description:) instead")
  public convenience init(_ name: String, _ default: ValueType, flag: Character? = nil, disabledName: String? = nil, disabledFlag: Character? = nil, description: String? = nil) {
    self.init(name, default: `default`, flag: flag, disabledName: disabledName, disabledFlag: disabledFlag, description: description)
  }

  public func parse(_ parser: ArgumentParser) throws -> ValueType {
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
  let `default`: String?
  let type: ArgumentType

  init<T : ArgumentDescriptor>(value: T) {
    name = value.name
    description = value.description
    type = value.type

    if let value = value as? Flag {
      `default` = value.`default`.description
    } else if let value = value as? Option<String> {
      `default` = value.`default`.description
    } else if let value = value as? Option<Int> {
      `default` = value.`default`.description
    } else {
      // TODO, default for Option of generic type
      `default` = nil
    }
  }
}


class UsageError : Error, ANSIConvertible, CustomStringConvertible {
  let message: String
  let help: Help

  init(_ message: String, _ help: Help) {
    self.message = message
    self.help = help
  }

  var description: String {
    return [message, help.description].filter { !$0.isEmpty }.joined(separator: "\n\n")
  }

  var ansiDescription: String {
    return [message, help.ansiDescription].filter { !$0.isEmpty }.joined(separator: "\n\n")
  }
}


class Help : Error, ANSIConvertible, CustomStringConvertible {
  let command: String?
  let group: Group?
  let descriptors: [BoxedArgumentDescriptor]

  init(_ descriptors: [BoxedArgumentDescriptor], command: String? = nil, group: Group? = nil) {
    self.command = command
    self.group = group
    self.descriptors = descriptors
  }

  func reraise(_ command: String? = nil) -> Help {
    if let oldCommand = self.command, let newCommand = command {
      return Help(descriptors, command: "\(newCommand) \(oldCommand)")
    }
    return Help(descriptors, command: command ?? self.command)
  }

  var description: String {
    var output = [String]()

    let arguments = descriptors.filter { $0.type == ArgumentType.argument }
    let options = descriptors.filter   { $0.type == ArgumentType.option }

    if let command = command {
      let args = arguments.map { "<\($0.name)>" }
      let usage = ([command] + args).joined(separator: " ")

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
    } else if !arguments.isEmpty {
      output.append("Arguments:")
      output.append("")

      output += arguments.map { argument in
        if let description = argument.description {
          return "    \(argument.name) - \(description)"
        } else {
          return "    \(argument.name)"
        }
      }

      output.append("")
    }

    if !options.isEmpty {
      output.append("Options:")
      for option in options {
        var line = "    --\(option.name)"

        if let `default` = option.default {
          line += " [default: \(`default`)]"
        }

        if let description = option.description {
          line += " - \(description)"
        }

        output.append(line)
      }
    }

    return output.joined(separator: "\n")
  }

  var ansiDescription: String {
    var output = [String]()

    let arguments = descriptors.filter { $0.type == ArgumentType.argument }
    let options = descriptors.filter   { $0.type == ArgumentType.option }

    if let command = command {
      let args = arguments.map { "<\($0.name)>" }
      let usage = ([command] + args).joined(separator: " ")

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
          output.append("    + \(ANSI.green)\(command.name)\(ANSI.reset) - \(description)")
        } else {
          output.append("    + \(ANSI.green)\(command.name)\(ANSI.reset)")
        }
      }
      output.append("")
    } else if !arguments.isEmpty {
      output.append("Arguments:")
      output.append("")

      output += arguments.map { argument in
        if let description = argument.description {
          return "    \(ANSI.blue)\(argument.name)\(ANSI.reset) - \(description)"
        } else {
          return "    \(ANSI.blue)\(argument.name)\(ANSI.reset)"
        }
      }

      output.append("")
    }

    if !options.isEmpty {
      output.append("Options:")
      for option in options {
        var line = "    \(ANSI.blue)--\(option.name)\(ANSI.reset)"

        if let `default` = option.default {
          line += " [default: \(`default`)]"
        }

        if let description = option.description {
          line += " - \(description)"
        }

        output.append(line)
      }
    }

    return output.joined(separator: "\n")
  }
}
