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
  convenience init!<FontType: FontConvertible
    where FontType: RawRepresentable, FontType.RawValue == String>
    (font: FontType, size: CGFloat) {
      self.init(name: font.rawValue, size: size)
  }
}

struct FontFamily {
  enum SFNSDisplay: String, FontConvertible {
    case Black = ".SFNSDisplay-Black"
    case Bold = ".SFNSDisplay-Bold"
    case Heavy = ".SFNSDisplay-Heavy"
    case Regular = ".SFNSDisplay-Regular"
  }
  enum SFNSText: String, FontConvertible {
    case Bold = ".SFNSText-Bold"
    case Heavy = ".SFNSText-Heavy"
    case Regular = ".SFNSText-Regular"
  }
  enum Avenir: String, FontConvertible {
    case Black = "Avenir-Black"
    case BlackOblique = "Avenir-BlackOblique"
    case Book = "Avenir-Book"
    case BookOblique = "Avenir-BookOblique"
    case Heavy = "Avenir-Heavy"
    case HeavyOblique = "Avenir-HeavyOblique"
    case Light = "Avenir-Light"
    case LightOblique = "Avenir-LightOblique"
    case Medium = "Avenir-Medium"
    case MediumOblique = "Avenir-MediumOblique"
    case Oblique = "Avenir-Oblique"
    case Roman = "Avenir-Roman"
  }
  enum ZapfDingbats: String, FontConvertible {
    case Regular = "ZapfDingbatsITC"
  }
}
