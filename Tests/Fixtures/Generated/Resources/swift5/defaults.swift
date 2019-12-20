// swiftlint:disable all
// Generated using SwiftGen - https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Resource Files

// swiftlint:disable identifier_name line_length number_separator type_body_length
internal enum Resource {
  internal static let file = FileResource(name: "File", ext: nil)
  internal static let testTxt = FileResource(name: "test", ext: "txt")
}

// MARK: - Implementation Detailsh

internal struct FileResource {
  internal fileprivate(set) var name: String
  internal fileprivate(set) var ext: String?

  internal var url: URL {
    return url(locale: nil)
  }

  internal func url(locale: Locale?) -> URL {
    let bundle = BundleToken.bundle
    let url = bundle.url(forResource: name, withExtension: ext, subdirectory: nil, localization: locale?.identifier)
    guard let result = url else {
      fatalError("Could not locate file named \(name)\(ext ?? "")")
    }
    return result
  }

  internal var path: String {
    return path(locale: nil)
  }

  internal func path(locale: Locale?) -> String {
    let bundle = BundleToken.bundle
    let path = bundle.path(forResource: name, ofType: ext, inDirectory: nil, forLocalization: locale?.identifier)
    guard let result = path else {
      fatalError("Could not locate file named \(name)\(ext ?? "")")
    }
    return result
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
