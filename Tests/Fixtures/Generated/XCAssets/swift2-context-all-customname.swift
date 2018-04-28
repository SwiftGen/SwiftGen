// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias XCTImage = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias XCTImage = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

@available(*, deprecated, renamed: "XCTImageAsset")
internal typealias XCTAssetsType = XCTImageAsset

internal struct XCTImageAsset {
  internal private(set) var name: String

  internal var image: XCTImage {
    let bundle = NSBundle(forClass: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = XCTImage(named: name, inBundle: bundle, compatibleWithTraitCollection: nil)
    #elseif os(OSX)
    let image = bundle.imageForResource(name)
    #elseif os(watchOS)
    let image = XCTImage(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal struct XCTColorAsset {
  internal fileprivate(set) var name: String
}

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum XCTAssets {
  internal enum Colors {
    internal enum _24Vision {
      internal static let Background = XCTColorAsset(name: "24Vision/Background")
      internal static let Primary = XCTColorAsset(name: "24Vision/Primary")
    }
    internal static let Orange = XCTImageAsset(name: "Orange")
    internal enum Vengo {
      internal static let Primary = XCTColorAsset(name: "Vengo/Primary")
      internal static let Tint = XCTColorAsset(name: "Vengo/Tint")
    }
    // swiftlint:disable trailing_comma
    internal static let allColors: [XCTColorAsset] = [
      _24Vision.Background,
      _24Vision.Primary,
      Vengo.Primary,
      Vengo.Tint,
    ]
    internal static let allImages: [XCTImageAsset] = [
      Orange,
    ]
    // swiftlint:enable trailing_comma
    @available(*, deprecated, renamed: "allImages")
    internal static let allValues: [XCTAssetsType] = allImages
  }
  internal enum Images {
    internal enum Exotic {
      internal static let Banana = XCTImageAsset(name: "Exotic/Banana")
      internal static let Mango = XCTImageAsset(name: "Exotic/Mango")
    }
    internal enum Round {
      internal static let Apricot = XCTImageAsset(name: "Round/Apricot")
      internal enum Red {
        internal static let Apple = XCTImageAsset(name: "Round/Apple")
        internal enum Double {
          internal static let Cherry = XCTImageAsset(name: "Round/Double/Cherry")
        }
        internal static let Tomato = XCTImageAsset(name: "Round/Tomato")
      }
    }
    internal static let Private = XCTImageAsset(name: "private")
    // swiftlint:disable trailing_comma
    internal static let allColors: [XCTColorAsset] = [
    ]
    internal static let allImages: [XCTImageAsset] = [
      Exotic.Banana,
      Exotic.Mango,
      Round.Apricot,
      Round.Red.Apple,
      Round.Red.Double.Cherry,
      Round.Red.Tomato,
      Private,
    ]
    // swiftlint:enable trailing_comma
    @available(*, deprecated, renamed: "allImages")
    internal static let allValues: [XCTAssetsType] = allImages
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

internal extension XCTImage {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the XCTImageAsset.image property")
  convenience init!(asset: XCTImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = NSBundle(forClass: BundleToken.self)
    self.init(named: asset.name, inBundle: bundle, compatibleWithTraitCollection: nil)
    #elseif os(OSX) || os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
