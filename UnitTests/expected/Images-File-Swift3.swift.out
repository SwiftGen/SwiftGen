// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  typealias Image = UIImage
#elseif os(OSX)
  import AppKit.NSImage
  typealias Image = NSImage
#endif

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum Asset: String {
  case exoticBanana = "Exotic/Banana"
  case exoticMango = "Exotic/Mango"
  case lemon = "Lemon"
  case roundApple = "Round/Apple"
  case roundApricot = "Round/Apricot"
  case roundDoubleCherry = "Round/Double/Cherry"
  case roundOrange = "Round/Orange"
  case roundTomato = "Round/Tomato"

  var image: Image {
    return Image(asset: self)
  }
}
// swiftlint:enable type_body_length

extension Image {
  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}
