// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit
  internal enum ColorName { }
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit
  internal enum ColorName { }
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Colors

// swiftlint:disable identifier_name line_length type_body_length
internal extension ColorName {
  enum Colors {
    /// 0x339666ff (r: 51, g: 150, b: 102, a: 255)
    internal static let articleBody = #colorLiteral(red: 0.2, green: 0.5882353, blue: 0.4, alpha: 1.0)
    /// 0xff66ccff (r: 255, g: 102, b: 204, a: 255)
    internal static let articleFootnote = #colorLiteral(red: 1.0, green: 0.4, blue: 0.8, alpha: 1.0)
    /// 0x33fe66ff (r: 51, g: 254, b: 102, a: 255)
    internal static let articleTitle = #colorLiteral(red: 0.2, green: 0.99607843, blue: 0.4, alpha: 1.0)
    /// 0xffffffcc (r: 255, g: 255, b: 255, a: 204)
    internal static let `private` = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
  }
}
// swiftlint:enable identifier_name line_length type_body_length
