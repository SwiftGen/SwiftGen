//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
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

  private enum Constants {
    static let modelExtension = "xcdatamodel"
    static let modelBundleExtension = "xcdatamodeld"
    static let currentVersionFile = ".xccurrentversion"
    static let currentVersionKey = "_XCCurrentVersionName"
    static let contentsFile = "contents"
  }

  public final class Parser: SwiftGenKit.Parser {
    var models: [Model] = []
    private let options: ParserOptionValues
    public var warningHandler: Parser.MessageHandler?

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) throws {
      self.options = try ParserOptionValues(options: options, available: Parser.allOptions)
      self.warningHandler = warningHandler
    }

    public static let defaultFilter = "[^/]\\.xcdatamodeld?$"

    public func parse(path: Path, relativeTo parent: Path) throws {
      if path.extension == Constants.modelBundleExtension {
        guard let modelPath = findCurrentModel(path: path) else {
          throw ParserError.invalidFile(path: path, reason: "Current version of Core Data model could not be found.")
        }
        try parse(path: modelPath, relativeTo: parent)
      } else if path.extension == Constants.modelExtension {
        try addModel(path: path)
      } else {
        throw ParserError.invalidFormat(reason: "Unknown file type for \(path)")
      }
    }

    private func findCurrentModel(path: Path) -> Path? {
      let currentVersionPath = path + Constants.currentVersionFile
      if currentVersionPath.exists {
        guard let currentVersionDictionary = NSDictionary(contentsOf: currentVersionPath.url) else {
          return nil
        }

        guard let currentVersionModelFilename = currentVersionDictionary[Constants.currentVersionKey] as? String else {
          return nil
        }

        return path + Path(currentVersionModelFilename)
      } else {
        return path.first { $0.extension == Constants.modelExtension }
      }
    }

    private func addModel(path: Path) throws {
      let contentsPath = path + Constants.contentsFile
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
