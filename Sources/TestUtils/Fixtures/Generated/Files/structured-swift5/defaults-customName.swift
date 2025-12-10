// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length line_length implicit_return

// MARK: - Files

// swiftlint:disable explicit_type_interface identifier_name
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum FileList {
  /// File
  internal static let file = Resource(name: "File", ext: nil, relativePath: "", mimeType: "application/octet-stream")
  /// test.txt
  internal static let testTxt = Resource(name: "test", ext: "txt", relativePath: "", mimeType: "text/plain")
  /// empty intermediate/
  internal enum EmptyIntermediate {
    /// empty intermediate/subfolder/
    internal enum Subfolder {
      /// another video.mp4
      internal static let anotherVideoMp4 = Resource(name: "another video", ext: "mp4", relativePath: "", mimeType: "video/mp4")
    }
  }
  /// subdir/
  internal enum Subdir {
    /// A Video With Spaces.mp4
    internal static let aVideoWithSpacesMp4 = Resource(name: "A Video With Spaces", ext: "mp4", relativePath: "", mimeType: "video/mp4")
    /// subdir/subdir/
    internal enum Subdir {
      /// graphic.svg
      internal static let graphicSvg = Resource(name: "graphic", ext: "svg", relativePath: "", mimeType: "image/svg+xml")
    }
  }
}
// swiftlint:enable explicit_type_interface identifier_name
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

internal struct Resource {
  internal let name: String
  internal let ext: String?
  internal let relativePath: String
  internal let mimeType: String

  internal var url: URL {
    return url(locale: nil)
  }

  internal func url(locale: Locale?) -> URL {
    let bundle = BundleToken.bundle
    let url = bundle.url(
      forResource: name,
      withExtension: ext,
      subdirectory: relativePath,
      localization: locale?.identifier
    )
    guard let result = url else {
      let file = name + (ext.flatMap { ".\($0)" } ?? "")
      fatalError("Could not locate file named \(file)")
    }
    return result
  }

  internal var path: String {
    return path(locale: nil)
  }

  internal func path(locale: Locale?) -> String {
    return url(locale: locale).path
  }
}

// swiftlint:disable convenience_type explicit_type_interface
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type explicit_type_interface
// swiftlint:enable all
