// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Plist Files

// swiftlint:disable identifier_name line_length type_body_length
enum PlistFiles {
  enum Info {
    private static let _document = PlistDocument(path: "Info.plist")
    static let cfBundleDevelopmentRegion: String = _document["CFBundleDevelopmentRegion"]
    static let cfBundleDisplayName: String = _document["CFBundleDisplayName"]
    static let cfBundleExecutable: String = _document["CFBundleExecutable"]
    static let cfBundleIdentifier: String = _document["CFBundleIdentifier"]
    static let cfBundleInfoDictionaryVersion: String = _document["CFBundleInfoDictionaryVersion"]
    static let cfBundleName: String = _document["CFBundleName"]
    static let cfBundlePackageType: String = _document["CFBundlePackageType"]
    static let cfBundleShortVersionString: String = _document["CFBundleShortVersionString"]
    static let cfBundleSignature: String = _document["CFBundleSignature"]
    static let cfBundleVersion: String = _document["CFBundleVersion"]
    static let fabric: [String: Any] = _document["Fabric"]
    static let itsAppUsesNonExemptEncryption: Bool = _document["ITSAppUsesNonExemptEncryption"]
    static let lsRequiresIPhoneOS: Bool = _document["LSRequiresIPhoneOS"]
    static let nsAppTransportSecurity: [String: Any] = _document["NSAppTransportSecurity"]
    static let nsCameraUsageDescription: String = _document["NSCameraUsageDescription"]
    static let nsPhotoLibraryUsageDescription: String = _document["NSPhotoLibraryUsageDescription"]
    static let uiBackgroundModes: [String] = _document["UIBackgroundModes"]
    static let uiLaunchStoryboardName: String = _document["UILaunchStoryboardName"]
    static let uiMainStoryboardFile: String = _document["UIMainStoryboardFile"]
    static let uiRequiredDeviceCapabilities: [String] = _document["UIRequiredDeviceCapabilities"]
    static let uiRequiresFullScreen: Bool = _document["UIRequiresFullScreen"]
    static let uiStatusBarStyle: String = _document["UIStatusBarStyle"]
    static let uiSupportedInterfaceOrientations: [String] = _document["UISupportedInterfaceOrientations"]
    static let uiSupportedInterfaceOrientationsIpad: [String] = _document["UISupportedInterfaceOrientations~ipad"]
    static let userAmbiguousInteger: Int = _document["User Ambiguous Integer"]
    static let userBoolean: Bool = _document["User Boolean"]
    static let userDate: Date = _document["User Date"]
    static let userFloat: Double = _document["User Float"]
    static let userInteger: Int = _document["User Integer"]
  }
  enum Configuration {
    private static let _document = PlistDocument(path: "configuration.plist")
    static let environment: String = _document["Environment"]
    static let flags: [Bool] = _document["Flags"]
    static let mixed: [Any] = _document["Mixed"]
    static let mixed2: [Any] = _document["Mixed2"]
    static let names: [String] = _document["Names"]
    static let one: Int = _document["One"]
    static let options: [String: Any] = _document["Options"]
    static let primes: [Int] = _document["Primes"]
    static let zero: Int = _document["Zero"]
  }
  enum ShoppingList {
    static let items: [String] = arrayFromPlist(at: "shopping-list.plist")
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

private func arrayFromPlist<T>(at path: String) -> [T] {
  guard let url = myPlistFinder(path:)(path),
    let data = NSArray(contentsOf: url) as? [T] else {
    fatalError("Unable to load PLIST at path: \(path)")
  }
  return data
}

private struct PlistDocument {
  let data: [String: Any]

  init(path: String) {
    guard let url = myPlistFinder(path:)(path),
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
