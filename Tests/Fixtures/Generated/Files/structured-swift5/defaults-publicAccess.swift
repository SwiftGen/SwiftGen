// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length line_length implicit_return

// MARK: - Files

// swiftlint:disable explicit_type_interface identifier_name
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Files {
  /// Files/
  public enum files {
    /// Files/File
    public static let file = File(name: "File", ext: nil, relativePath: "Files", mimeType: "application/octet-stream")
    /// Files/test.txt
    public static let testTxt = File(name: "test", ext: "txt", relativePath: "Files", mimeType: "text/plain")
    /// Files/empty intermediate/
    public enum emptyIntermediate {
      /// Files/empty intermediate/subfolder/
      public enum subfolder {
        /// Files/empty intermediate/subfolder/another video.mp4
        public static let anotherVideoMp4 = File(name: "another video", ext: "mp4", relativePath: "Files/empty intermediate/subfolder", mimeType: "video/mp4")
      }
    }
    /// Files/subdir/
    public enum subdir {
      /// Files/subdir/A Video With Spaces.mp4
      public static let aVideoWithSpacesMp4 = File(name: "A Video With Spaces", ext: "mp4", relativePath: "Files/subdir", mimeType: "video/mp4")
      /// Files/subdir/subdir/
      public enum subdir {
        /// Files/subdir/subdir/graphic.svg
        public static let graphicSvg = File(name: "graphic", ext: "svg", relativePath: "Files/subdir/subdir", mimeType: "image/svg+xml")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface identifier_name
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

public struct File {
  public fileprivate(set) var name: String
  public fileprivate(set) var ext: String?
  public fileprivate(set) var relativePath: String
  public fileprivate(set) var mimeType: String

  public var url: URL {
    return url(locale: nil)
  }

  public func url(locale: Locale?) -> URL {
    let bundle = BundleToken.bundle
    let url = bundle.url(
      forResource: name,
      withExtension: ext,
      subdirectory: relativePath,
      localization: locale?.identifier
    )
    guard let result = url else {
      let file = name + (ext != nil ? "." + ext : "")
      fatalError("Could not locate file named \(file)")
    }
    return result
  }

  public var path: String {
    return path(locale: nil)
  }

  public func path(locale: Locale?) -> String {
    return url(locale: locale).path
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle = Bundle(for: BundleToken.self)
}
// swiftlint:enable convenience_type
