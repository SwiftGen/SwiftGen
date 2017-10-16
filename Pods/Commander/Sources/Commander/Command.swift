/// A simple CommandType using a closure
struct AnonymousCommand : CommandType {
  var closure:(ArgumentParser) throws -> ()

  init(_ closure:@escaping ((ArgumentParser) throws -> ())) {
    self.closure = closure
  }

  func run(_ parser:ArgumentParser) throws {
    try closure(parser)
  }
}

enum CommandError : Error {
  case invalidArgument
}

/// Create a command using a closure
public func command(_ closure: @escaping () throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure()
  }
}
