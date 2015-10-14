//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation
import Commander

enum OutputDestination: ArgumentConvertible {
    case Console
    case File(String)
    
    init(parser: ArgumentParser) throws {
        guard let path = parser.shift() else {
            throw ArgumentError.MissingValue(argument: nil)
        }
        if path == "-" {
            self = .Console
        } else {
            self = .File(path)
        }
    }
    var description: String {
        switch self {
        case .Console: return "(stdout)"
        case .File(let path): return path
        }
    }
    
    func write(content: String) {
        switch self {
        case .Console:
            print(content)
        case .File(let path):
            do {
                try content.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
            } catch let e as NSError {
                print("Error: \(e)")
            }
            print("File written: \(path)")
        }
    }
}

let outputOption = Option("output", OutputDestination.Console, description: "The path to the file to generate. Use - to generate in stdout")
