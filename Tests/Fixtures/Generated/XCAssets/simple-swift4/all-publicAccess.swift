// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
#endif


// MARK: - Asset Catalogs

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
  }
  public enum Data {
    public static let data = DataAsset(name: "Data")
    public enum Json {
      public static let data = DataAsset(name: "Json/Data")
    }
    public static let readme = DataAsset(name: "README")
  }
  public enum Images {
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
}

// MARK: - Implementation Details

private final class BundleToken {}
