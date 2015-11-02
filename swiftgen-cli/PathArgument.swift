//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit

// MARK: Validators

func checkPath(type: String, @noescape assertion: Path->Bool)(path: Path) throws -> Path {
  guard assertion(path) else { throw ArgumentError.InvalidType(value: path.description, type: type, argument: nil) }
  return path
}
let pathExists = checkPath("path") { $0.exists }
let fileExists = checkPath("file") { $0.isFile }
let dirExists  = checkPath("directory") { $0.isDirectory }

// MARK: Path as Input Argument

extension Path : ArgumentConvertible {
  public init(parser: ArgumentParser) throws {
    guard let path = parser.shift() else {
      throw ArgumentError.MissingValue(argument: nil)
    }
    self = Path(path)
  }
}

// MARK: Output (Path or Console) Argument

enum OutputDestination: ArgumentConvertible {
  case Console
  case File(Path)
  
  init(parser: ArgumentParser) throws {
    guard let path = parser.shift() else {
      throw ArgumentError.MissingValue(argument: nil)
    }
    self = .File(Path(path))
  }
  var description: String {
    switch self {
    case .Console: return "(stdout)"
    case .File(let path): return path.description
    }
  }
  
  func write(content: String) {
    switch self {
    case .Console:
      print(content)
    case .File(let path):
      do {
        try path.write(content)
        print("File written: \(path)")
      } catch let e as NSError {
        print("Error: \(e)")
      }
    }
  }
}
