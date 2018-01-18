//
//  PlistParser.swift
//  swiftgen
//
//  Created by John McIntosh on 1/17/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation
import PathKit

public enum Plist {
  public enum ParserError: Error, CustomStringConvertible {
    case directory
    case invalidFile

    public var description: String {
      switch self {
      case .directory:
        return "The input was a directory, but must be a specifc file."
      case .invalidFile:
        return "The file could not be parsed as a valid plist file."
      }
    }
  }

  // MARK: Plist File Parser

  public final class Parser: SwiftGenKit.Parser {
    var plistContext: [String: Any] = [:]
    public var warningHandler: Parser.MessageHandler?

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
      self.warningHandler = warningHandler
    }

    public func parse(path: Path) throws {
      guard path.isFile else {
        throw ParserError.directory
      }

      if let data = NSDictionary(contentsOf: path.url) as? [String: Any] {
        plistContext = data
      } else if let data = NSArray(contentsOf: path.url) as? [Any] {
        plistContext = ["root_array": data]
      } else {
        throw ParserError.invalidFile
      }
    }
  }
}
