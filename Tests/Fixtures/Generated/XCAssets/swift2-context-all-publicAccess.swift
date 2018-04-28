// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  public typealias Image = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  public typealias Image = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

@available(*, deprecated, renamed: "ImageAsset")
public typealias AssetType = ImageAsset

public struct ImageAsset {
  public private(set) var name: String

  public var image: Image {
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

public struct ColorAsset {
  public fileprivate(set) var name: String
}

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Asset {
  public enum Colors {
    public enum _24Vision {
      public static let Background = ColorAsset(name: "24Vision/Background")
      public static let Primary = ColorAsset(name: "24Vision/Primary")
    }
    public static let Orange = ImageAsset(name: "Orange")
    public enum Vengo {
      public static let Primary = ColorAsset(name: "Vengo/Primary")
      public static let Tint = ColorAsset(name: "Vengo/Tint")
    }
    // swiftlint:disable trailing_comma
    public static let allColors: [ColorAsset] = [
      _24Vision.Background,
      _24Vision.Primary,
      Vengo.Primary,
      Vengo.Tint,
    ]
    public static let allImages: [ImageAsset] = [
      Orange,
    ]
    // swiftlint:enable trailing_comma
    @available(*, deprecated, renamed: "allImages")
    public static let allValues: [AssetType] = allImages
  }
  public enum Images {
    public enum Exotic {
      public static let Banana = ImageAsset(name: "Exotic/Banana")
      public static let Mango = ImageAsset(name: "Exotic/Mango")
    }
    public enum Round {
      public static let Apricot = ImageAsset(name: "Round/Apricot")
      public enum Red {
        public static let Apple = ImageAsset(name: "Round/Apple")
        public enum Double {
          public static let Cherry = ImageAsset(name: "Round/Double/Cherry")
        }
        public static let Tomato = ImageAsset(name: "Round/Tomato")
      }
    }
    public static let Private = ImageAsset(name: "private")
    // swiftlint:disable trailing_comma
    public static let allColors: [ColorAsset] = [
    ]
    public static let allImages: [ImageAsset] = [
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
    public static let allValues: [AssetType] = allImages
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

public extension Image {
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
