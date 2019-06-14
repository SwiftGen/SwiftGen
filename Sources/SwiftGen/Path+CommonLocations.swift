//
// SwiftGen
// Copyright © 2019 SwiftGen
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

  static let applicationSupport: Path = {
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

  static let appSupportTemplates = Path.applicationSupport + "SwiftGen/templates"
  static let bundledTemplates = binary.parent() + templatesRelativePath

  // MARK: Private

  private static let templatesRelativePath: String = {
    if let path = Bundle.main.object(forInfoDictionaryKey: "TemplatePath") as? String, !path.isEmpty {
      return path
    } else if let path = BundleToken.bundle.path(forResource: "templates", ofType: nil) {
      return path
    } else {
      return "../templates"
    }
  }()
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    let bundle = Bundle(for: BundleToken.self)
    if let path = Bundle.paths(forResourcesOfType: "bundle", inDirectory: bundle.bundlePath).first,
        let bundle = Bundle(path: path) {
      return bundle
    }
    return bundle
  }()
}
// swiftlint:enable convenience_type
