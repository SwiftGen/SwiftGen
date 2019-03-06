// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
#endif


// MARK: - Asset Catalogs

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
  }
  internal enum Data {
    internal static let data = DataAsset(name: "Data")
    internal enum Json {
      internal static let data = DataAsset(name: "Json/Data")
    }
    internal static let readme = DataAsset(name: "README")
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
  }
}

// MARK: - Implementation Details

private final class BundleToken {}
