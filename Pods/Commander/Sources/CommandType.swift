/// Represents a command that can be run, given an argument parser
public protocol CommandType {
  func run(_ parser:ArgumentParser) throws
}


/// Extensions to CommandType to provide convinience running methods
extension CommandType {
  /// Run the command with an array of arguments
  public func run(_ arguments:[String]) throws {
    try run(ArgumentParser(arguments: arguments))
  }
}

