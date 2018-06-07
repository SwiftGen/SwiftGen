// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable all

#if os(OSX)
  import AppKit.NSImage
  public typealias AssetColorTypeAlias = NSColor
  public typealias Image = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  public typealias AssetColorTypeAlias = UIColor
  public typealias Image = UIImage
#endif


@available(*, deprecated, renamed: "ImageAsset")
public typealias AssetType = ImageAsset

public struct ImageAsset {
  public fileprivate(set) var name: String

  public var image: Image {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

public struct ColorAsset {
  public fileprivate(set) var name: String

  #if swift(>=3.2)
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  public var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
  #endif
}

public enum Asset {
  public enum Colors {
    public enum _24Vision {
      public static let background = ColorAsset(name: "24Vision/Background")
      public static let primary = ColorAsset(name: "24Vision/Primary")
    }
    public static let orange = ImageAsset(name: "Orange")
    public enum Vengo {
      public static let primary = ColorAsset(name: "Vengo/Primary")
      public static let tint = ColorAsset(name: "Vengo/Tint")
    }
    public static let allColors: [ColorAsset] = [
      _24Vision.background,
      _24Vision.primary,
      Vengo.primary,
      Vengo.tint,
    ]
    public static let allImages: [ImageAsset] = [
      orange,
    ]
    @available(*, deprecated, renamed: "allImages")
    public static let allValues: [AssetType] = allImages
  }
  public enum Images {
    public enum Exotic {
      public static let banana = ImageAsset(name: "Exotic/Banana")
      public static let mango = ImageAsset(name: "Exotic/Mango")
    }
    public enum Round {
      public static let apricot = ImageAsset(name: "Round/Apricot")
      public enum Red {
        public static let apple = ImageAsset(name: "Round/Apple")
        public enum Double {
          public static let cherry = ImageAsset(name: "Round/Double/Cherry")
        }
        public static let tomato = ImageAsset(name: "Round/Tomato")
      }
    }
    public static let `private` = ImageAsset(name: "private")
    public static let allColors: [ColorAsset] = [
    ]
    public static let allImages: [ImageAsset] = [
      Exotic.banana,
      Exotic.mango,
      Round.apricot,
      Round.Red.apple,
      Round.Red.Double.cherry,
      Round.Red.tomato,
      `private`,
    ]
    @available(*, deprecated, renamed: "allImages")
    public static let allValues: [AssetType] = allImages
  }
}

public extension Image {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX) || os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

public extension AssetColorTypeAlias {
  #if swift(>=3.2)
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: asset.name, bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
  #endif
}

private final class BundleToken {}
