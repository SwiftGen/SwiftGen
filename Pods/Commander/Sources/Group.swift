public enum GroupError : Error, Equatable, CustomStringConvertible {
  /// No-subcommand was found with the given name
  case unknownCommand(String)

  /// No command was given
  /// :param: The current path to the command (i.e, all the group names)
  /// :param: The group raising the error
  case noCommand(String?, Group)

  public var description:String {
    switch self {
    case .unknownCommand(let name):
      return "Unknown command: `\(name)`"
    case .noCommand(let path, let group):
      let available = group.commands.map { $0.name }.sorted().joined(separator: ", ")
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
  case let (.unknownCommand(lhsCommand), .unknownCommand(rhsCommand)):
    return lhsCommand == rhsCommand
  case let (.noCommand(lhsPath, lhsGroup), .noCommand(rhsPath, rhsGroup)):
    return lhsPath == rhsPath && lhsGroup === rhsGroup
  default:
    return false
  }
}

/// Represents a group of commands
open class Group : CommandType {
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
  open var unknownCommand: ((_ name: String, _ parser: ArgumentParser) throws -> ())?

  /// Create a new group
  public init() {}

  /// Add a named sub-command to the group
  open func addCommand(_ name: String, _ command: CommandType) {
    commands.append(SubCommand(name: name, description: nil, command: command))
  }

  /// Add a named sub-command to the group with a description
  open func addCommand(_ name: String, _ description: String?, _ command: CommandType) {
    commands.append(SubCommand(name: name, description: description, command: command))
  }

  /// Run the group command
  open func run(_ parser: ArgumentParser) throws {
    if let name = parser.shift() {
      let command = commands.filter { $0.name == name }.first
      if let command = command {
        do {
          try command.command.run(parser)
        } catch GroupError.unknownCommand(let childName) {
          throw GroupError.unknownCommand("\(name) \(childName)")
        } catch GroupError.noCommand(let path, let group) {
          if let path = path {
            throw GroupError.noCommand("\(name) \(path)", group)
          }

          throw GroupError.noCommand(name, group)
        } catch let error as Help {
          throw error.reraise(name)
        }
      } else if let unknownCommand = unknownCommand {
        try unknownCommand(name, parser)
      } else {
        throw GroupError.unknownCommand(name)
      }
    } else {
      throw GroupError.noCommand(nil, self)
    }
  }
}

extension Group {
  public convenience init(closure: (Group) -> ()) {
    self.init()
    closure(self)
  }

  /// Add a sub-group using a closure
  public func group(_ name: String, _ description: String? = nil, closure: (Group) -> ()) {
    addCommand(name, description, Group(closure: closure))
  }
}
