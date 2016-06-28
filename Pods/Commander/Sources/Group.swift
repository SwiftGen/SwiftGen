public enum GroupError: ErrorType, Equatable, CustomStringConvertible {
  /// No-subcommand was found with the given name
  case UnknownCommand(String)

  /// No command was given
  /// :param: The current path to the command (i.e, all the group names)
  /// :param: The group raising the error
  case NoCommand(String?, Group)

  public var description: String {
    switch self {
    case .UnknownCommand(let name):
      return "Unknown command: `\(name)`"
    case .NoCommand(let path, let group):
      let available = group.commands.map { $0.name }.sort().joinWithSeparator(", ")
      if let path = path {
        return "Usage: \(path) COMMAND\n\nCommands: \(available)"
      } else {
        return "Commands: \(available)"
      }
    }
  }
}

public func == (lhs: GroupError, rhs: GroupError) -> Bool {
  switch (lhs, rhs) {
  case let (.UnknownCommand(lhsCommand), .UnknownCommand(rhsCommand)):
    return lhsCommand == rhsCommand
  case let (.NoCommand(lhsPath, lhsGroup), .NoCommand(rhsPath, rhsGroup)):
    return lhsPath == rhsPath && lhsGroup === rhsGroup
  default:
    return false
  }
}

/// Represents a group of commands
public class Group: CommandType {
  struct SubCommand {
    let name: String
    let description: String?
    let command: CommandType

    init(name: String, description: String?, command: CommandType) {
      self.name = name
      self.description = description
      self.command = command
    }
  }

  var commands = [SubCommand]()

  // When set, allows you to override the default unknown command behaviour
  public var unknownCommand: ((name: String, parser: ArgumentParser) throws -> ())?

  /// Create a new group
  public init() {}

  /// Add a named sub-command to the group
  public func addCommand(name: String, _ command: CommandType) {
    commands.append(SubCommand(name: name, description: nil, command: command))
  }

  /// Add a named sub-command to the group with a description
  public func addCommand(name: String, _ description: String?, _ command: CommandType) {
    commands.append(SubCommand(name: name, description: description, command: command))
  }

  /// Run the group command
  public func run(parser: ArgumentParser) throws {
    if let name = parser.shift() {
      let command = commands.filter { $0.name == name }.first
      if let command = command {
        do {
          try command.command.run(parser)
        } catch GroupError.UnknownCommand(let childName) {
          throw GroupError.UnknownCommand("\(name) \(childName)")
        } catch GroupError.NoCommand(let path, let group) {
          if let path = path {
            throw GroupError.NoCommand("\(name) \(path)", group)
          }

          throw GroupError.NoCommand(name, group)
        } catch let error as Help {
          throw error.reraise(name)
        }
      } else if let unknownCommand = unknownCommand {
        try unknownCommand(name: name, parser: parser)
      } else {
        throw GroupError.UnknownCommand(name)
      }
    } else {
      throw GroupError.NoCommand(nil, self)
    }
  }
}

extension Group {
  public convenience init(@noescape closure: Group -> ()) {
    self.init()
    closure(self)
  }

  /// Add a sub-group using a closure
  public func group(name: String, _ description: String? = nil, @noescape closure: Group -> ()) {
    addCommand(name, description, Group(closure: closure))
  }
}
