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
enum XCTImages: String {
  case Exotic_Banana = "Exotic/Banana"
  case Exotic_Mango = "Exotic/Mango"
  case Lemon = "Lemon"
  case Round_Apple = "Round/Apple"
  case Round_Apricot = "Round/Apricot"
  case Round_Double_Cherry = "Round/Double/Cherry"
  case Round_Orange = "Round/Orange"
  case Round_Tomato = "Round/Tomato"

  var image: Image {
    return Image(asset: self)
  }
}
// swiftlint:enable type_body_length

extension Image {
  convenience init!(asset: XCTImages) {
    self.init(named: asset.rawValue)
  }
}
