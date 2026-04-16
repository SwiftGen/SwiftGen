//
// SwiftGenKit UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

import PathKit
import SwiftGenCLI
import SwiftGenKit
import XCTest

// MARK: - Safe access to fixtures

public class Fixtures {
  public enum Directory: String {
    case colors = "Colors"
    case coreData = "CoreData"
    case files = "Files"
    case fonts = "Fonts"
    case interfaceBuilder = "IB"
    case interfaceBuilderiOS = "IB-iOS"
    case interfaceBuilderMacOS = "IB-macOS"
    case json = "JSON"
    case plist = "Plist"
    case plistBad = "Plist/bad"
    case plistGood = "Plist/good"
    case strings = "Strings"
    case stringsCatalog = "StringsCatalog"
    case xcassets = "XCAssets"
    case yaml = "YAML"
    case yamlBad = "YAML/bad"
    case yamlGood = "YAML/good"
  }

  private static let testBundle = Bundle.module
  private init() {}

  public static func resourceDirectory(sub: Directory? = nil) -> Path {
    guard let resources = testBundle.path(forResource: "Resources", ofType: nil) else {
      fatalError("Unable to find resource directory URL")
    }

    if let dir = sub {
      return Path(resources) + dir.rawValue
    } else {
      return Path(resources)
    }
  }

  public static func resource(for name: String, sub: Directory) -> Path {
    path(for: name, subDirectory: "Resources/\(sub.rawValue)")
  }

  public static func config(for name: String) -> Path {
    path(for: "\(name).yml", subDirectory: "Configs")
  }

  public static func context(for name: String, sub: Directory) -> [String: Any] {
    let path = self.path(for: name, subDirectory: "StencilContexts/\(sub.rawValue)")

    guard let yaml = try? YAML.read(path: path),
      let result = yaml as? [String: Any] else {
        fatalError("Unable to load fixture content")
    }

    return result
  }

  static func template(for name: String, sub: Directory) -> Path {
    // Directly load from SwiftGenFramework bundle
    return Path.bundledTemplates + sub.rawValue.lowercased() + name
  }

  static func output(template: String, variation: String, sub: Directory) -> String {
    do {
      return try path(for: variation, subDirectory: "Generated/\(sub.rawValue)/\(template)").read()
    } catch let error {
      fatalError("Unable to load fixture content: \(error)")
    }
  }

  private static func path(for name: String, subDirectory: String? = nil) -> Path {
    guard let path = testBundle.path(forResource: name, ofType: "", inDirectory: subDirectory) else {
      fatalError("Unable to find fixture \"\(name)\"")
    }
    return Path(path)
  }
}
