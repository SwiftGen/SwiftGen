// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSFont
  internal typealias Font = NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
  internal typealias Font = UIFont
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  internal func font(size: CGFloat) -> Font! {
    return Font(font: self, size: size)
  }

  internal func register() {
    guard let url = url else { return }
    var errorRef: Unmanaged<CFError>?
    CTFontManagerRegisterFontsForURL(url as CFURL, .Process, &errorRef)
  }

  fileprivate var url: NSURL? {
    let bundle = NSBundle(forClass: BundleToken.self)
    return bundle.URLForResource(path, withExtension: nil)
  }
}

internal extension Font {
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
internal enum CustomFamily {
  internal enum SFNSDisplay {
    internal static let Black = FontConvertible(".SFNSDisplay-Black", family: ".SF NS Display", path: "SFNSDisplay-Black.otf")
    internal static let Bold = FontConvertible(".SFNSDisplay-Bold", family: ".SF NS Display", path: "SFNSDisplay-Bold.otf")
    internal static let Heavy = FontConvertible(".SFNSDisplay-Heavy", family: ".SF NS Display", path: "SFNSDisplay-Heavy.otf")
    internal static let Regular = FontConvertible(".SFNSDisplay-Regular", family: ".SF NS Display", path: "SFNSDisplay-Regular.otf")
  }
  internal enum SFNSText {
    internal static let Bold = FontConvertible(".SFNSText-Bold", family: ".SF NS Text", path: "SFNSText-Bold.otf")
    internal static let Heavy = FontConvertible(".SFNSText-Heavy", family: ".SF NS Text", path: "SFNSText-Heavy.otf")
    internal static let Regular = FontConvertible(".SFNSText-Regular", family: ".SF NS Text", path: "SFNSText-Regular.otf")
  }
  internal enum Avenir {
    internal static let Black = FontConvertible("Avenir-Black", family: "Avenir", path: "Avenir.ttc")
    internal static let BlackOblique = FontConvertible("Avenir-BlackOblique", family: "Avenir", path: "Avenir.ttc")
    internal static let Book = FontConvertible("Avenir-Book", family: "Avenir", path: "Avenir.ttc")
    internal static let BookOblique = FontConvertible("Avenir-BookOblique", family: "Avenir", path: "Avenir.ttc")
    internal static let Heavy = FontConvertible("Avenir-Heavy", family: "Avenir", path: "Avenir.ttc")
    internal static let HeavyOblique = FontConvertible("Avenir-HeavyOblique", family: "Avenir", path: "Avenir.ttc")
    internal static let Light = FontConvertible("Avenir-Light", family: "Avenir", path: "Avenir.ttc")
    internal static let LightOblique = FontConvertible("Avenir-LightOblique", family: "Avenir", path: "Avenir.ttc")
    internal static let Medium = FontConvertible("Avenir-Medium", family: "Avenir", path: "Avenir.ttc")
    internal static let MediumOblique = FontConvertible("Avenir-MediumOblique", family: "Avenir", path: "Avenir.ttc")
    internal static let Oblique = FontConvertible("Avenir-Oblique", family: "Avenir", path: "Avenir.ttc")
    internal static let Roman = FontConvertible("Avenir-Roman", family: "Avenir", path: "Avenir.ttc")
  }
  internal enum ZapfDingbats {
    internal static let Regular = FontConvertible("ZapfDingbatsITC", family: "Zapf Dingbats", path: "ZapfDingbats.ttf")
  }
  internal enum Public {
    internal static let Internal = FontConvertible("private", family: "public", path: "class.ttf")
  }
}
// swiftlint:enable identifier_name line_length type_body_length

private final class BundleToken {}
