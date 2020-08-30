// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Files

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Files {
  /// File
  public static let file = File(name: "File", ext: nil, relativePath: "", mimeType: "application/octet-stream")
  /// test.txt
  public static let testTxt = File(name: "test", ext: "txt", relativePath: "", mimeType: "text/plain")
  /// empty intermediate/
  public enum emptyIntermediate {
    /// empty intermediate/subfolder/
    public enum subfolder {
      /// empty intermediate/subfolder/another video.mp4
      public static let anotherVideoMp4 = File(name: "another video", ext: "mp4", relativePath: "empty intermediate/subfolder", mimeType: "video/mp4")
    }
  }
  /// subdir/
  public enum subdir {
    /// subdir/A Video With Spaces.mp4
    public static let aVideoWithSpacesMp4 = File(name: "A Video With Spaces", ext: "mp4", relativePath: "subdir", mimeType: "video/mp4")
    /// subdir/subdir/
    public enum subdir {
      /// subdir/subdir/graphic.svg
      public static let graphicSvg = File(name: "graphic", ext: "svg", relativePath: "subdir/subdir", mimeType: "image/svg+xml")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
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
    let url = bundle.url(forResource: name, withExtension: ext, subdirectory: relativePath, localization: locale?.identifier)
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
