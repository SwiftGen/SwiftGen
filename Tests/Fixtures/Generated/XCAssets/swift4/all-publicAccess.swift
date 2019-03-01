// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSImage
  public typealias AssetColorTypeAlias = NSColor
  public typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  public typealias AssetColorTypeAlias = UIColor
  public typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Asset {
  public enum Files {
    public static let data = DataAsset(name: "Data")
    public enum Json {
      public static let data = DataAsset(name: "Json/Data")
    }
    public static let readme = DataAsset(name: "README")
  }
  public enum Food {
    public enum Exotic {
      public static let banana = ImageAsset(name: "Exotic/Banana")
      public static let mango = ImageAsset(name: "Exotic/Mango")
    }
    public enum Round {
      public static let apricot = ImageAsset(name: "Round/Apricot")
      public static let apple = ImageAsset(name: "Round/Apple")
      public enum Double {
        public static let cherry = ImageAsset(name: "Round/Double/Cherry")
      }
      public static let tomato = ImageAsset(name: "Round/Tomato")
    }
    public static let `private` = ImageAsset(name: "private")
  }
  public enum Styles {
    public enum _24Vision {
      public static let background = ColorAsset(name: "24Vision/Background")
      public static let primary = ColorAsset(name: "24Vision/Primary")
    }
    public static let orange = ImageAsset(name: "Orange")
    public enum Vengo {
      public static let primary = ColorAsset(name: "Vengo/Primary")
      public static let tint = ColorAsset(name: "Vengo/Tint")
    }
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset {
  public fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: AssetColorTypeAlias = AssetColorTypeAlias(asset: self)

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

public struct DataAsset {
  public fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(macOS)
  @available(iOS 9.0, macOS 10.11, *)
  public var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(macOS)
@available(iOS 9.0, macOS 10.11, *)
public extension NSDataAsset {
  convenience init!(asset: DataAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(macOS)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

public struct ImageAsset {
  public fileprivate(set) var name: String

  public var image: AssetImageTypeAlias {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = AssetImageTypeAlias(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

public extension AssetImageTypeAlias {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
