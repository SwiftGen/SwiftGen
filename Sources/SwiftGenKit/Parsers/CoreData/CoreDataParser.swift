//
//  CoreDataParser.swift
//  SwiftGenKit
//
//  Created by Grant Butler on 7/18/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation
import Kanna
import PathKit

public enum CoreData {
  public enum ParserError: Error, CustomStringConvertible {
    case invalidFile(path: Path, reason: String)
    case invalidFormat(reason: String)

    public var description: String {
      switch self {
      case .invalidFile(let path, let reason):
        return "error: Unable to parse file at \(path). \(reason)"
      case .invalidFormat(let reason):
        return "error: Invalid format. \(reason)"
      }
    }
  }

  public final class Parser: SwiftGenKit.Parser {
    public var warningHandler: Parser.MessageHandler?
    var models: [Model] = []

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
      self.warningHandler = warningHandler
    }

    public func parse(path: Path) throws {
      if path.extension == "xcdatamodeld" {
        guard let modelPath = findCurrentModel(path: path) else {
          throw ParserError.invalidFile(path: path, reason: "Current version of Core Data model could not be found.")
        }
        try parse(path: modelPath)
      } else if path.extension == "xcdatamodel" {
        try addModel(path: path)
      } else {
        let dirChildren = path.iterateChildren(options: [.skipsHiddenFiles, .skipsPackageDescendants])

        for file in dirChildren where file.extension == "xcdatamodeld" || file.extension == "xcdatamodel" {
          try parse(path: file)
        }
      }
    }

    private func findCurrentModel(path: Path) -> Path? {
      let currentVersionPath = path + ".xccurrentversion"
      if currentVersionPath.exists {
        guard let currentVersionDictionary = NSDictionary(contentsOf: currentVersionPath.url) else {
          return nil
        }

        guard let currentVersionModelFilename = currentVersionDictionary["_XCCurrentVersionName"] as? String else {
          return nil
        }

        return path + Path(currentVersionModelFilename)
      } else {
        return path.first { $0.extension == "xcdatamodel" }
      }
    }

    private func addModel(path: Path) throws {
      let contentsPath = path + "contents"
      guard contentsPath.exists else {
        throw ParserError.invalidFormat(reason: "Only models in Xcode 4.0+ format are supported")
      }

      do {
        let document = try Kanna.XML(xml: contentsPath.read(), encoding: .utf8)
        let model = try Model(with: document)
        models.append(model)
      } catch {
        throw ParserError.invalidFile(path: path, reason: "XML parser error: \(error).")
      }
    }
  }
}
