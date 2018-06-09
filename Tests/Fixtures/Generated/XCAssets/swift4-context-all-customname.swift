// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable all

#if os(OSX)
  import AppKit.NSImage
  internal typealias XCTColor = NSColor
  internal typealias XCTImage = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias XCTColor = UIColor
  internal typealias XCTImage = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

internal struct XCTColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: XCTColor {
    return XCTColor(asset: self)
  }
}

internal extension XCTColor {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: XCTColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

@available(*, deprecated, renamed: "XCTImageAsset")
internal typealias XCTAssetsType = XCTImageAsset

internal struct XCTImageAsset {
  internal fileprivate(set) var name: String

  internal var image: XCTImage {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = XCTImage(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = XCTImage(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal extension XCTImage {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the XCTImageAsset.image property")
  convenience init!(asset: XCTImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// MARK: Assets

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum XCTAssets {
  internal enum Colors {
    internal enum _24Vision {
      internal static let background = XCTColorAsset(name: "24Vision/Background")
      internal static let primary = XCTColorAsset(name: "24Vision/Primary")
    }
    internal static let orange = XCTImageAsset(name: "Orange")
    internal enum Vengo {
      internal static let primary = XCTColorAsset(name: "Vengo/Primary")
      internal static let tint = XCTColorAsset(name: "Vengo/Tint")
    }
    // swiftlint:disable trailing_comma
    internal static let allColors: [XCTColorAsset] = [
      _24Vision.background,
      _24Vision.primary,
      Vengo.primary,
      Vengo.tint,
    ]
    internal static let allImages: [XCTImageAsset] = [
      orange,
    ]
    // swiftlint:enable trailing_comma
    @available(*, deprecated, renamed: "allImages")
    internal static let allValues: [XCTAssetsType] = allImages
  }
  internal enum Images {
    internal enum Exotic {
      internal static let banana = XCTImageAsset(name: "Exotic/Banana")
      internal static let mango = XCTImageAsset(name: "Exotic/Mango")
    }
    internal enum Round {
      internal static let apricot = XCTImageAsset(name: "Round/Apricot")
      internal enum Red {
        internal static let apple = XCTImageAsset(name: "Round/Apple")
        internal enum Double {
          internal static let cherry = XCTImageAsset(name: "Round/Double/Cherry")
        }
        internal static let tomato = XCTImageAsset(name: "Round/Tomato")
      }
    }
    internal static let `private` = XCTImageAsset(name: "private")
    // swiftlint:disable trailing_comma
    internal static let allColors: [XCTColorAsset] = [
    ]
    internal static let allImages: [XCTImageAsset] = [
      Exotic.banana,
      Exotic.mango,
      Round.apricot,
      Round.Red.apple,
      Round.Red.Double.cherry,
      Round.Red.tomato,
      `private`,
    ]
    // swiftlint:enable trailing_comma
    @available(*, deprecated, renamed: "allImages")
    internal static let allValues: [XCTAssetsType] = allImages
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

private final class BundleToken {}
