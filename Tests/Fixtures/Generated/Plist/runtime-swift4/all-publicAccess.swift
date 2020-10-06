// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Plist Files

// swiftlint:disable identifier_name line_length type_body_length
public enum PlistFiles {
  public enum Info {
    private static let _document = PlistDocument(path: "Info.plist")
    public static let cfBundleDevelopmentRegion: String = _document["CFBundleDevelopmentRegion"]
    public static let cfBundleDisplayName: String = _document["CFBundleDisplayName"]
    public static let cfBundleExecutable: String = _document["CFBundleExecutable"]
    public static let cfBundleIdentifier: String = _document["CFBundleIdentifier"]
    public static let cfBundleInfoDictionaryVersion: String = _document["CFBundleInfoDictionaryVersion"]
    public static let cfBundleName: String = _document["CFBundleName"]
    public static let cfBundlePackageType: String = _document["CFBundlePackageType"]
    public static let cfBundleShortVersionString: String = _document["CFBundleShortVersionString"]
    public static let cfBundleSignature: String = _document["CFBundleSignature"]
    public static let cfBundleVersion: String = _document["CFBundleVersion"]
    public static let fabric: [String: Any] = _document["Fabric"]
    public static let itsAppUsesNonExemptEncryption: Bool = _document["ITSAppUsesNonExemptEncryption"]
    public static let lsRequiresIPhoneOS: Bool = _document["LSRequiresIPhoneOS"]
    public static let nsAppTransportSecurity: [String: Any] = _document["NSAppTransportSecurity"]
    public static let nsCameraUsageDescription: String = _document["NSCameraUsageDescription"]
    public static let nsPhotoLibraryUsageDescription: String = _document["NSPhotoLibraryUsageDescription"]
    public static let uiBackgroundModes: [String] = _document["UIBackgroundModes"]
    public static let uiLaunchStoryboardName: String = _document["UILaunchStoryboardName"]
    public static let uiMainStoryboardFile: String = _document["UIMainStoryboardFile"]
    public static let uiRequiredDeviceCapabilities: [String] = _document["UIRequiredDeviceCapabilities"]
    public static let uiRequiresFullScreen: Bool = _document["UIRequiresFullScreen"]
    public static let uiStatusBarStyle: String = _document["UIStatusBarStyle"]
    public static let uiSupportedInterfaceOrientations: [String] = _document["UISupportedInterfaceOrientations"]
    public static let uiSupportedInterfaceOrientationsIpad: [String] = _document["UISupportedInterfaceOrientations~ipad"]
    public static let userAmbiguousInteger: Int = _document["User Ambiguous Integer"]
    public static let userBoolean: Bool = _document["User Boolean"]
    public static let userDate: Date = _document["User Date"]
    public static let userFloat: Double = _document["User Float"]
    public static let userInteger: Int = _document["User Integer"]
  }
  public enum Configuration {
    private static let _document = PlistDocument(path: "configuration.plist")
    public static let environment: String = _document["Environment"]
    public static let flags: [Bool] = _document["Flags"]
    public static let mixed: [Any] = _document["Mixed"]
    public static let mixed2: [Any] = _document["Mixed2"]
    public static let names: [String] = _document["Names"]
    public static let one: Int = _document["One"]
    public static let options: [String: Any] = _document["Options"]
    public static let primes: [Int] = _document["Primes"]
    public static let zero: Int = _document["Zero"]
  }
  public enum ShoppingList {
    public static let items: [String] = arrayFromPlist(at: "shopping-list.plist")
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

private func arrayFromPlist<T>(at path: String) -> [T] {
  guard let url = BundleToken.bundle.url(forResource: path, withExtension: nil),
    let data = NSArray(contentsOf: url) as? [T] else {
    fatalError("Unable to load PLIST at path: \(path)")
  }
  return data
}

private struct PlistDocument {
  let data: [String: Any]

  init(path: String) {
    guard let url = BundleToken.bundle.url(forResource: path, withExtension: nil),
      let data = NSDictionary(contentsOf: url) as? [String: Any] else {
        fatalError("Unable to load PLIST at path: \(path)")
    }
    self.data = data
  }

  subscript<T>(key: String) -> T {
    guard let result = data[key] as? T else {
      fatalError("Property '\(key)' is not of type \(T.self)")
    }
    return result
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
