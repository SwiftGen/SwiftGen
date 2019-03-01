// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
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

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum XCTAssets {
  internal enum Files {
    internal static let data = XCTDataAsset(name: "Data")
    internal enum Json {
      internal static let data = XCTDataAsset(name: "Json/Data")
    }
    internal static let readme = XCTDataAsset(name: "README")
  }
  internal enum Food {
    internal enum Exotic {
      internal static let banana = XCTImageAsset(name: "Exotic/Banana")
      internal static let mango = XCTImageAsset(name: "Exotic/Mango")
    }
    internal enum Round {
      internal static let apricot = XCTImageAsset(name: "Round/Apricot")
      internal static let apple = XCTImageAsset(name: "Round/Apple")
      internal enum Double {
        internal static let cherry = XCTImageAsset(name: "Round/Double/Cherry")
      }
      internal static let tomato = XCTImageAsset(name: "Round/Tomato")
    }
    internal static let `private` = XCTImageAsset(name: "private")
  }
  internal enum Styles {
    internal enum _24Vision {
      internal static let background = XCTColorAsset(name: "24Vision/Background")
      internal static let primary = XCTColorAsset(name: "24Vision/Primary")
    }
    internal static let orange = XCTImageAsset(name: "Orange")
    internal enum Vengo {
      internal static let primary = XCTColorAsset(name: "Vengo/Primary")
      internal static let tint = XCTColorAsset(name: "Vengo/Tint")
    }
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class XCTColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: XCTColor = XCTColor(asset: self)

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension XCTColor {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init!(asset: XCTColorAsset) {
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

internal struct XCTDataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(macOS)
  @available(iOS 9.0, macOS 10.11, *)
  internal var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(macOS)
@available(iOS 9.0, macOS 10.11, *)
internal extension NSDataAsset {
  convenience init!(asset: XCTDataAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(macOS)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

internal struct XCTImageAsset {
  internal fileprivate(set) var name: String

  internal var image: XCTImage {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = XCTImage(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = XCTImage(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal extension XCTImage {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the XCTImageAsset.image property")
  convenience init!(asset: XCTImageAsset) {
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
