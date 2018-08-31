// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias AssetColorTypeAlias = NSColor
  internal typealias Image = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias AssetColorTypeAlias = UIColor
  internal typealias Image = UIImage
#endif
#if os(iOS) || os(tvOS) || os(OSX)
internal typealias AssetDataTypeAlias = NSDataAsset
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

internal struct ColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

internal extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
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

internal struct DataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  internal var data: AssetDataTypeAlias {
    return AssetDataTypeAlias(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
internal extension AssetDataTypeAlias {
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  convenience init!(asset: DataAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(OSX)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

@available(*, deprecated, renamed: "ImageAsset")
internal typealias AssetType = ImageAsset

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: Image {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal extension Image {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
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
internal enum Asset {
  internal enum Colors {
    internal enum _24Vision {
      internal static let background = ColorAsset(name: "24Vision/Background")
      internal static let primary = ColorAsset(name: "24Vision/Primary")
    }
    internal static let orange = ImageAsset(name: "Orange")
    internal enum Vengo {
      internal static let primary = ColorAsset(name: "Vengo/Primary")
      internal static let tint = ColorAsset(name: "Vengo/Tint")
    }
    // swiftlint:disable trailing_comma
    internal static let allColors: [ColorAsset] = [
      _24Vision.background,
      _24Vision.primary,
      Vengo.primary,
      Vengo.tint,
    ]
    internal static let allDataAssets: [DataAsset] = [
    ]
    internal static let allImages: [ImageAsset] = [
      orange,
    ]
    // swiftlint:enable trailing_comma
    @available(*, deprecated, renamed: "allImages")
    internal static let allValues: [AssetType] = allImages
  }
  internal enum Data {
    internal static let data = DataAsset(name: "Data")
    internal enum Json {
      internal static let data = DataAsset(name: "Json/Data")
    }
    internal static let readme = DataAsset(name: "README")
    // swiftlint:disable trailing_comma
    internal static let allColors: [ColorAsset] = [
    ]
    internal static let allDataAssets: [DataAsset] = [
      data,
      Json.data,
      readme,
    ]
    internal static let allImages: [ImageAsset] = [
    ]
    // swiftlint:enable trailing_comma
    @available(*, deprecated, renamed: "allImages")
    internal static let allValues: [AssetType] = allImages
  }
  internal enum Images {
    internal enum Exotic {
      internal static let banana = ImageAsset(name: "Exotic/Banana")
      internal static let mango = ImageAsset(name: "Exotic/Mango")
    }
    internal enum Round {
      internal static let apricot = ImageAsset(name: "Round/Apricot")
      internal static let apple = ImageAsset(name: "Round/Apple")
      internal enum Double {
        internal static let cherry = ImageAsset(name: "Round/Double/Cherry")
      }
      internal static let tomato = ImageAsset(name: "Round/Tomato")
    }
    internal static let `private` = ImageAsset(name: "private")
    // swiftlint:disable trailing_comma
    internal static let allColors: [ColorAsset] = [
    ]
    internal static let allDataAssets: [DataAsset] = [
    ]
    internal static let allImages: [ImageAsset] = [
      Exotic.banana,
      Exotic.mango,
      Round.apricot,
      Round.apple,
      Round.Double.cherry,
      Round.tomato,
      `private`,
    ]
    // swiftlint:enable trailing_comma
    @available(*, deprecated, renamed: "allImages")
    internal static let allValues: [AssetType] = allImages
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

private final class BundleToken {}
