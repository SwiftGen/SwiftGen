// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "MyFontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
typealias MyFont = MyFontConvertible.Font

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable implicit_return

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
enum CustomFamily {
  enum SFNSDisplay {
    static let black = MyFontConvertible(name: ".SFNSDisplay-Black", family: ".SF NS Display", path: "SFNSDisplay-Black.otf")
    static let bold = MyFontConvertible(name: ".SFNSDisplay-Bold", family: ".SF NS Display", path: "SFNSDisplay-Bold.otf")
    static let heavy = MyFontConvertible(name: ".SFNSDisplay-Heavy", family: ".SF NS Display", path: "SFNSDisplay-Heavy.otf")
    static let regular = MyFontConvertible(name: ".SFNSDisplay-Regular", family: ".SF NS Display", path: "SFNSDisplay-Regular.otf")
    static let all: [MyFontConvertible] = [black, bold, heavy, regular]
  }
  enum SFNSText {
    static let bold = MyFontConvertible(name: ".SFNSText-Bold", family: ".SF NS Text", path: "SFNSText-Bold.otf")
    static let heavy = MyFontConvertible(name: ".SFNSText-Heavy", family: ".SF NS Text", path: "SFNSText-Heavy.otf")
    static let regular = MyFontConvertible(name: ".SFNSText-Regular", family: ".SF NS Text", path: "SFNSText-Regular.otf")
    static let all: [MyFontConvertible] = [bold, heavy, regular]
  }
  enum Avenir {
    static let black = MyFontConvertible(name: "Avenir-Black", family: "Avenir", path: "Avenir.ttc")
    static let blackOblique = MyFontConvertible(name: "Avenir-BlackOblique", family: "Avenir", path: "Avenir.ttc")
    static let book = MyFontConvertible(name: "Avenir-Book", family: "Avenir", path: "Avenir.ttc")
    static let bookOblique = MyFontConvertible(name: "Avenir-BookOblique", family: "Avenir", path: "Avenir.ttc")
    static let heavy = MyFontConvertible(name: "Avenir-Heavy", family: "Avenir", path: "Avenir.ttc")
    static let heavyOblique = MyFontConvertible(name: "Avenir-HeavyOblique", family: "Avenir", path: "Avenir.ttc")
    static let light = MyFontConvertible(name: "Avenir-Light", family: "Avenir", path: "Avenir.ttc")
    static let lightOblique = MyFontConvertible(name: "Avenir-LightOblique", family: "Avenir", path: "Avenir.ttc")
    static let medium = MyFontConvertible(name: "Avenir-Medium", family: "Avenir", path: "Avenir.ttc")
    static let mediumOblique = MyFontConvertible(name: "Avenir-MediumOblique", family: "Avenir", path: "Avenir.ttc")
    static let oblique = MyFontConvertible(name: "Avenir-Oblique", family: "Avenir", path: "Avenir.ttc")
    static let roman = MyFontConvertible(name: "Avenir-Roman", family: "Avenir", path: "Avenir.ttc")
    static let all: [MyFontConvertible] = [black, blackOblique, book, bookOblique, heavy, heavyOblique, light, lightOblique, medium, mediumOblique, oblique, roman]
  }
  enum ZapfDingbats {
    static let regular = MyFontConvertible(name: "ZapfDingbatsITC", family: "Zapf Dingbats", path: "ZapfDingbats.ttf")
    static let all: [MyFontConvertible] = [regular]
  }
  enum Public {
    static let `internal` = MyFontConvertible(name: "private", family: "public", path: "class.ttf")
    static let all: [MyFontConvertible] = [`internal`]
  }
  static let allCustomFonts: [MyFontConvertible] = [SFNSDisplay.all, SFNSText.all, Avenir.all, ZapfDingbats.all, Public.all].flatMap { $0 }
  static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

struct MyFontConvertible {
  let name: String
  let family: String
  let path: String

  #if os(macOS)
  typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  typealias Font = UIFont
  #endif

  func font(size: CGFloat) -> Font! {
    return Font(font: self, size: size)
  }

  func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

extension MyFontConvertible.Font {
  convenience init?(font: MyFontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(macOS)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

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
