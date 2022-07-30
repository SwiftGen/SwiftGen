//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Path {
  static let binary: Path = {
    var binaryPath = Path(ProcessInfo.processInfo.arguments[0])
    do {
      while binaryPath.isSymlink {
        binaryPath = try binaryPath.symlinkDestination()
      }
    } catch {
      print("Warning: could not resolve symlink of \(binaryPath) with error \(error)")
    }
    return binaryPath
  }()

  // Deprecated: Remove this in SwiftGen 7.0
  static let deprecatedApplicationSupport: Path = {
    let paths = NSSearchPathForDirectoriesInDomains(
      .applicationSupportDirectory,
      .userDomainMask,
      true
    )
    guard let path = paths.first else {
      fatalError("Unable to locate the Application Support directory on your machine!")
    }
    return Path(path)
  }()

  // Deprecated: Remove this in SwiftGen 7.0
  public static let deprecatedAppSupportTemplates = Path.deprecatedApplicationSupport + "SwiftGen/templates"
  public static let bundledTemplates = Path(Bundle.module.path(forResource: "templates", ofType: nil) ?? "")
}

/// URL to the Documentation on GitHub
public func gitHubDocURL(version: String, path: String = "") -> URL {
  let type = path.isEmpty || path.hasSuffix("/") ? "tree" : "blob"
  return URL(
    string: "https://github.com/SwiftGen/SwiftGen/\(type)/\(version)/Documentation/\(path)"
  )! // swiftlint:disable:this force_unwrapping
}
