// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias Image = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias Image = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

@available(*, deprecated, renamed: "ImageAsset")
internal typealias AssetType = ImageAsset

internal struct ImageAsset {
  internal private(set) var name: String

  internal var image: Image {
    let bundle = NSBundle(forClass: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, inBundle: bundle, compatibleWithTraitCollection: nil)
    #elseif os(OSX)
    let image = bundle.imageForResource(name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal struct ColorAsset {
  internal fileprivate(set) var name: String
}

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Colors {
    internal enum _24Vision {
      internal static let Background = ColorAsset(name: "24Vision/Background")
      internal static let Primary = ColorAsset(name: "24Vision/Primary")
    }
    internal static let Orange = ImageAsset(name: "Orange")
    internal enum Vengo {
      internal static let Primary = ColorAsset(name: "Vengo/Primary")
      internal static let Tint = ColorAsset(name: "Vengo/Tint")
    }

    // swiftlint:disable trailing_comma
    internal static let allColors: [ColorAsset] = [
      _24Vision.Background,
      _24Vision.Primary,
      Vengo.Primary,
      Vengo.Tint,
    ]
    internal static let allImages: [ImageAsset] = [
      Orange,
    ]
    // swiftlint:enable trailing_comma
    @available(*, deprecated, renamed: "allImages")
    internal static let allValues: [AssetType] = allImages
  }
  internal enum Images {
    internal enum Exotic {
      internal static let Banana = ImageAsset(name: "Exotic/Banana")
      internal static let Mango = ImageAsset(name: "Exotic/Mango")
    }
    internal enum Round {
      internal static let Apricot = ImageAsset(name: "Round/Apricot")
      internal enum Red {
        internal static let Apple = ImageAsset(name: "Round/Apple")
        internal enum Double {
          internal static let Cherry = ImageAsset(name: "Round/Double/Cherry")
        }
        internal static let Tomato = ImageAsset(name: "Round/Tomato")
      }
    }
    internal static let Private = ImageAsset(name: "private")

    // swiftlint:disable trailing_comma
    internal static let allColors: [ColorAsset] = [
    ]
    internal static let allImages: [ImageAsset] = [
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
    internal static let allValues: [AssetType] = allImages
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

internal extension Image {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = NSBundle(forClass: BundleToken.self)
    self.init(named: asset.name, inBundle: bundle, compatibleWithTraitCollection: nil)
    #elseif os(OSX) || os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
