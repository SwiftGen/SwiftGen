// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSFont
  public typealias Font = NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
  public typealias Font = UIFont
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

public struct FontConvertible {
  public let name: String
  public let family: String
  public let path: String

  public func font(size: CGFloat) -> Font! {
    return Font(font: self, size: size)
  }

  public func register() {
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .Process, nil)
  }

  fileprivate var url: NSURL? {
    let bundle = NSBundle(forClass: BundleToken.self)
    return bundle.URLForResource(path, withExtension: nil)
  }
}

public extension Font {
  convenience init!(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNamesForFamilyName(font.family).contains(font.name) {
      font.register()
    }
    #elseif os(OSX)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .None {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

// swiftlint:disable identifier_name line_length type_body_length
public enum FontFamily {
  public enum SFNSDisplay {
    public static let Black = FontConvertible(".SFNSDisplay-Black", family: ".SF NS Display", path: "SFNSDisplay-Black.otf")
    public static let Bold = FontConvertible(".SFNSDisplay-Bold", family: ".SF NS Display", path: "SFNSDisplay-Bold.otf")
    public static let Heavy = FontConvertible(".SFNSDisplay-Heavy", family: ".SF NS Display", path: "SFNSDisplay-Heavy.otf")
    public static let Regular = FontConvertible(".SFNSDisplay-Regular", family: ".SF NS Display", path: "SFNSDisplay-Regular.otf")
    public static let all: [FontConvertible] = [Black, Bold, Heavy, Regular]
  }
  public enum SFNSText {
    public static let Bold = FontConvertible(".SFNSText-Bold", family: ".SF NS Text", path: "SFNSText-Bold.otf")
    public static let Heavy = FontConvertible(".SFNSText-Heavy", family: ".SF NS Text", path: "SFNSText-Heavy.otf")
    public static let Regular = FontConvertible(".SFNSText-Regular", family: ".SF NS Text", path: "SFNSText-Regular.otf")
    public static let all: [FontConvertible] = [Bold, Heavy, Regular]
  }
  public enum Avenir {
    public static let Black = FontConvertible("Avenir-Black", family: "Avenir", path: "Avenir.ttc")
    public static let BlackOblique = FontConvertible("Avenir-BlackOblique", family: "Avenir", path: "Avenir.ttc")
    public static let Book = FontConvertible("Avenir-Book", family: "Avenir", path: "Avenir.ttc")
    public static let BookOblique = FontConvertible("Avenir-BookOblique", family: "Avenir", path: "Avenir.ttc")
    public static let Heavy = FontConvertible("Avenir-Heavy", family: "Avenir", path: "Avenir.ttc")
    public static let HeavyOblique = FontConvertible("Avenir-HeavyOblique", family: "Avenir", path: "Avenir.ttc")
    public static let Light = FontConvertible("Avenir-Light", family: "Avenir", path: "Avenir.ttc")
    public static let LightOblique = FontConvertible("Avenir-LightOblique", family: "Avenir", path: "Avenir.ttc")
    public static let Medium = FontConvertible("Avenir-Medium", family: "Avenir", path: "Avenir.ttc")
    public static let MediumOblique = FontConvertible("Avenir-MediumOblique", family: "Avenir", path: "Avenir.ttc")
    public static let Oblique = FontConvertible("Avenir-Oblique", family: "Avenir", path: "Avenir.ttc")
    public static let Roman = FontConvertible("Avenir-Roman", family: "Avenir", path: "Avenir.ttc")
    public static let all: [FontConvertible] = [Black, BlackOblique, Book, BookOblique, Heavy, HeavyOblique, Light, LightOblique, Medium, MediumOblique, Oblique, Roman]
  }
  public enum ZapfDingbats {
    public static let Regular = FontConvertible("ZapfDingbatsITC", family: "Zapf Dingbats", path: "ZapfDingbats.ttf")
    public static let all: [FontConvertible] = [Regular]
  }
  public enum Public {
    public static let Internal = FontConvertible("private", family: "public", path: "class.ttf")
    public static let all: [FontConvertible] = [Internal]
  }
  public static let allCustomFonts: [FontConvertible] = [SFNSDisplay.all, SFNSText.all, Avenir.all, ZapfDingbats.all, Public.all].flatMap { $0 }
  public static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

private final class BundleToken {}
