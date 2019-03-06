// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
#endif


// MARK: - Asset Catalogs

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
  }
  internal enum Data {
    internal static let data = XCTDataAsset(name: "Data")
    internal enum Json {
      internal static let data = XCTDataAsset(name: "Json/Data")
    }
    internal static let readme = XCTDataAsset(name: "README")
  }
  internal enum Images {
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
}

// MARK: - Implementation Details

private final class BundleToken {}
