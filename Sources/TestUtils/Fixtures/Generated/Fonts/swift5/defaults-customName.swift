// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "MyFontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias MyFont = MyFontConvertible.Font

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum CustomFamily {
  internal enum SFNSDisplay {
    internal static let black = MyFontConvertible(name: ".SFNSDisplay-Black", family: ".SF NS Display", path: "SFNSDisplay-Black.otf")
    internal static let bold = MyFontConvertible(name: ".SFNSDisplay-Bold", family: ".SF NS Display", path: "SFNSDisplay-Bold.otf")
    internal static let heavy = MyFontConvertible(name: ".SFNSDisplay-Heavy", family: ".SF NS Display", path: "SFNSDisplay-Heavy.otf")
    internal static let regular = MyFontConvertible(name: ".SFNSDisplay-Regular", family: ".SF NS Display", path: "SFNSDisplay-Regular.otf")
    internal static let all: [MyFontConvertible] = [black, bold, heavy, regular]
  }
  internal enum SFNSText {
    internal static let bold = MyFontConvertible(name: ".SFNSText-Bold", family: ".SF NS Text", path: "SFNSText-Bold.otf")
    internal static let heavy = MyFontConvertible(name: ".SFNSText-Heavy", family: ".SF NS Text", path: "SFNSText-Heavy.otf")
    internal static let regular = MyFontConvertible(name: ".SFNSText-Regular", family: ".SF NS Text", path: "SFNSText-Regular.otf")
    internal static let all: [MyFontConvertible] = [bold, heavy, regular]
  }
  internal enum Avenir {
    internal static let black = MyFontConvertible(name: "Avenir-Black", family: "Avenir", path: "Avenir.ttc")
    internal static let blackOblique = MyFontConvertible(name: "Avenir-BlackOblique", family: "Avenir", path: "Avenir.ttc")
    internal static let book = MyFontConvertible(name: "Avenir-Book", family: "Avenir", path: "Avenir.ttc")
    internal static let bookOblique = MyFontConvertible(name: "Avenir-BookOblique", family: "Avenir", path: "Avenir.ttc")
    internal static let heavy = MyFontConvertible(name: "Avenir-Heavy", family: "Avenir", path: "Avenir.ttc")
    internal static let heavyOblique = MyFontConvertible(name: "Avenir-HeavyOblique", family: "Avenir", path: "Avenir.ttc")
    internal static let light = MyFontConvertible(name: "Avenir-Light", family: "Avenir", path: "Avenir.ttc")
    internal static let lightOblique = MyFontConvertible(name: "Avenir-LightOblique", family: "Avenir", path: "Avenir.ttc")
    internal static let medium = MyFontConvertible(name: "Avenir-Medium", family: "Avenir", path: "Avenir.ttc")
    internal static let mediumOblique = MyFontConvertible(name: "Avenir-MediumOblique", family: "Avenir", path: "Avenir.ttc")
    internal static let oblique = MyFontConvertible(name: "Avenir-Oblique", family: "Avenir", path: "Avenir.ttc")
    internal static let roman = MyFontConvertible(name: "Avenir-Roman", family: "Avenir", path: "Avenir.ttc")
    internal static let all: [MyFontConvertible] = [black, blackOblique, book, bookOblique, heavy, heavyOblique, light, lightOblique, medium, mediumOblique, oblique, roman]
  }
  internal enum ZapfDingbats {
    internal static let regular = MyFontConvertible(name: "ZapfDingbatsITC", family: "Zapf Dingbats", path: "ZapfDingbats.ttf")
    internal static let all: [MyFontConvertible] = [regular]
  }
  internal enum Public {
    internal static let `internal` = MyFontConvertible(name: "private", family: "public", path: "class.ttf")
    internal static let all: [MyFontConvertible] = [`internal`]
  }
  internal static let allCustomFonts: [MyFontConvertible] = [SFNSDisplay.all, SFNSText.all, Avenir.all, ZapfDingbats.all, Public.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct MyFontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  #if os(macOS)
  internal typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Font = UIFont
  #endif

  internal func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal func swiftUIFont(size: CGFloat) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, size: size)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  internal func swiftUIFont(fixedSize: CGFloat) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, fixedSize: fixedSize)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  internal func swiftUIFont(size: CGFloat, relativeTo textStyle: SwiftUI.Font.TextStyle) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, size: size, relativeTo: textStyle)
  }
  #endif

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate func registerIfNeeded() {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: family).contains(name) {
      register()
    }
    #elseif os(macOS)
    if let url = url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      register()
    }
    #endif
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension MyFontConvertible.Font {
  convenience init?(font: MyFontConvertible, size: CGFloat) {
    font.registerIfNeeded()
    self.init(name: font.name, size: size)
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Font {
  static func custom(_ font: MyFontConvertible, size: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, size: size)
  }
}

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
internal extension SwiftUI.Font {
  static func custom(_ font: MyFontConvertible, fixedSize: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, fixedSize: fixedSize)
  }

  static func custom(
    _ font: MyFontConvertible,
    size: CGFloat,
    relativeTo textStyle: SwiftUI.Font.TextStyle
  ) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, size: size, relativeTo: textStyle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
// swiftlint:enable all
