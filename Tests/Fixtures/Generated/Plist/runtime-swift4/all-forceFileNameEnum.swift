// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Plist Files

// swiftlint:disable identifier_name line_length type_body_length
internal enum PlistFiles {
  internal enum Info {
    private static let _document = PlistDocument(path: "Info.plist")
    internal static let cfBundleDevelopmentRegion: String = _document["CFBundleDevelopmentRegion"]
    internal static let cfBundleDisplayName: String = _document["CFBundleDisplayName"]
    internal static let cfBundleExecutable: String = _document["CFBundleExecutable"]
    internal static let cfBundleIdentifier: String = _document["CFBundleIdentifier"]
    internal static let cfBundleInfoDictionaryVersion: String = _document["CFBundleInfoDictionaryVersion"]
    internal static let cfBundleName: String = _document["CFBundleName"]
    internal static let cfBundlePackageType: String = _document["CFBundlePackageType"]
    internal static let cfBundleShortVersionString: String = _document["CFBundleShortVersionString"]
    internal static let cfBundleSignature: String = _document["CFBundleSignature"]
    internal static let cfBundleVersion: String = _document["CFBundleVersion"]
    internal static let fabric: [String: Any] = _document["Fabric"]
    internal static let itsAppUsesNonExemptEncryption: Bool = _document["ITSAppUsesNonExemptEncryption"]
    internal static let lsRequiresIPhoneOS: Bool = _document["LSRequiresIPhoneOS"]
    internal static let nsAppTransportSecurity: [String: Any] = _document["NSAppTransportSecurity"]
    internal static let nsCameraUsageDescription: String = _document["NSCameraUsageDescription"]
    internal static let nsPhotoLibraryUsageDescription: String = _document["NSPhotoLibraryUsageDescription"]
    internal static let uiBackgroundModes: [String] = _document["UIBackgroundModes"]
    internal static let uiLaunchStoryboardName: String = _document["UILaunchStoryboardName"]
    internal static let uiMainStoryboardFile: String = _document["UIMainStoryboardFile"]
    internal static let uiRequiredDeviceCapabilities: [String] = _document["UIRequiredDeviceCapabilities"]
    internal static let uiRequiresFullScreen: Bool = _document["UIRequiresFullScreen"]
    internal static let uiStatusBarStyle: String = _document["UIStatusBarStyle"]
    internal static let uiSupportedInterfaceOrientations: [String] = _document["UISupportedInterfaceOrientations"]
    internal static let uiSupportedInterfaceOrientationsIpad: [String] = _document["UISupportedInterfaceOrientations~ipad"]
    internal static let userAmbiguousInteger: Int = _document["User Ambiguous Integer"]
    internal static let userBoolean: Bool = _document["User Boolean"]
    internal static let userDate: Date = _document["User Date"]
    internal static let userFloat: Double = _document["User Float"]
    internal static let userInteger: Int = _document["User Integer"]
  }
  internal enum Configuration {
    private static let _document = PlistDocument(path: "configuration.plist")
    internal static let environment: String = _document["Environment"]
    internal static let flags: [Bool] = _document["Flags"]
    internal static let mixed: [Any] = _document["Mixed"]
    internal static let mixed2: [Any] = _document["Mixed2"]
    internal static let names: [String] = _document["Names"]
    internal static let one: Int = _document["One"]
    internal static let options: [String: Any] = _document["Options"]
    internal static let primes: [Int] = _document["Primes"]
    internal static let zero: Int = _document["Zero"]
  }
  internal enum ShoppingList {
    internal static let items: [String] = arrayFromPlist(at: "shopping-list.plist")
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
