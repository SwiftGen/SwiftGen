// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Files

// swiftlint:disable identifier_name line_length number_separator type_body_length
public enum Files {
  /// File
  public static let file = File(name: "File", ext: nil, path: "", mimeType: "application/octet-stream")
  /// test.txt
  public static let testTxt = File(name: "test", ext: "txt", path: "", mimeType: "text/plain")
  /// empty intermediate/subfolder/another video.mp4
  public static let anotherVideoMp4 = File(name: "another video", ext: "mp4", path: "empty intermediate/subfolder", mimeType: "video/mp4")
  /// subdir/A Video With Spaces.mp4
  public static let aVideoWithSpacesMp4 = File(name: "A Video With Spaces", ext: "mp4", path: "subdir", mimeType: "video/mp4")
  /// subdir/subdir/graphic.svg
  public static let graphicSvg = File(name: "graphic", ext: "svg", path: "subdir/subdir", mimeType: "image/svg+xml")
}

// MARK: - Implementation Details

public struct File {
  public fileprivate(set) var name: String
  public fileprivate(set) var ext: String?
  public fileprivate(set) var path: String
  public fileprivate(set) var mimeType: String

  public var url: URL {
    return url(locale: nil)
  }

  public func url(locale: Locale?) -> URL {
    let bundle = BundleToken.bundle
    let url = bundle.url(forResource: name, withExtension: ext, subdirectory: path, localization: locale?.identifier)
    guard let result = url else {
      let file = name + (ext ? "." + ext : "")
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
  static let bundle: Bundle = Bundle(for: BundleToken.self)
}
// swiftlint:enable convenience_type
