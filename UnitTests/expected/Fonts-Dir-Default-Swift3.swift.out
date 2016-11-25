// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
  typealias Font = UIFont
#elseif os(OSX)
  import AppKit.NSFont
  typealias Font = NSFont
#endif

// swiftlint:disable file_length
// swiftlint:disable line_length

protocol FontConvertible {
  func font(size: CGFloat) -> Font!
}

extension FontConvertible where Self: RawRepresentable, Self.RawValue == String {
  func font(size: CGFloat) -> Font! {
    return Font(font: self, size: size)
  }
}

extension Font {
  convenience init!<FontType: FontConvertible>
    (font: FontType, size: CGFloat)
    where FontType: RawRepresentable, FontType.RawValue == String {
      self.init(name: font.rawValue, size: size)
  }
}

struct FontFamily {
  enum SFNSDisplay: String, FontConvertible {
    case black = ".SFNSDisplay-Black"
    case bold = ".SFNSDisplay-Bold"
    case heavy = ".SFNSDisplay-Heavy"
    case regular = ".SFNSDisplay-Regular"
  }
  enum SFNSText: String, FontConvertible {
    case bold = ".SFNSText-Bold"
    case heavy = ".SFNSText-Heavy"
    case regular = ".SFNSText-Regular"
  }
  enum Avenir: String, FontConvertible {
    case black = "Avenir-Black"
    case blackOblique = "Avenir-BlackOblique"
    case book = "Avenir-Book"
    case bookOblique = "Avenir-BookOblique"
    case heavy = "Avenir-Heavy"
    case heavyOblique = "Avenir-HeavyOblique"
    case light = "Avenir-Light"
    case lightOblique = "Avenir-LightOblique"
    case medium = "Avenir-Medium"
    case mediumOblique = "Avenir-MediumOblique"
    case oblique = "Avenir-Oblique"
    case roman = "Avenir-Roman"
  }
  enum ZapfDingbats: String, FontConvertible {
    case regular = "ZapfDingbatsITC"
  }
}
