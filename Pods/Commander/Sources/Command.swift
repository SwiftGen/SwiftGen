/// A simple CommandType using a closure
struct AnonymousCommand: CommandType {
  var closure: ArgumentParser throws -> ()

  init(_ closure: (ArgumentParser throws -> ())) {
    self.closure = closure
  }

  func run(parser: ArgumentParser) throws {
    try closure(parser)
  }
}

enum CommandError: ErrorType {
  case InvalidArgument
}

/// Create a command using a closure
public func command(closure:() throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure()
  }
}
