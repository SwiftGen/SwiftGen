// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Plist Files

// swiftlint:disable identifier_name line_length type_body_length
public enum PlistFiles {
  public enum Info {
    private static let _document = PlistDocument(path: "Info.plist")
    public static let userDate: Date = _document["User Date"]
    public static let userFloat: Double = _document["User Float"]
    public static let cfBundleDevelopmentRegion: String = _document["CFBundleDevelopmentRegion"]
    public static let userAmbiguousInteger: Bool = _document["User Ambiguous Integer"]
    public static let cfBundleIdentifier: String = _document["CFBundleIdentifier"]
    public static let cfBundleShortVersionString: String = _document["CFBundleShortVersionString"]
    public static let cfBundleExecutable: String = _document["CFBundleExecutable"]
    public static let lsRequiresIPhoneOS: Bool = _document["LSRequiresIPhoneOS"]
    public static let uiSupportedInterfaceOrientationsIpad: [String] = _document["UISupportedInterfaceOrientations~ipad"]
    public static let cfBundleVersion: String = _document["CFBundleVersion"]
    public static let userInteger: Int = _document["User Integer"]
    public static let uiLaunchStoryboardName: String = _document["UILaunchStoryboardName"]
    public static let cfBundleInfoDictionaryVersion: String = _document["CFBundleInfoDictionaryVersion"]
    public static let uiRequiresFullScreen: Bool = _document["UIRequiresFullScreen"]
    public static let uiStatusBarStyle: String = _document["UIStatusBarStyle"]
    public static let cfBundleSignature: String = _document["CFBundleSignature"]
    public static let cfBundleDisplayName: String = _document["CFBundleDisplayName"]
    public static let nsAppTransportSecurity: [String: Any] = _document["NSAppTransportSecurity"]
    public static let uiSupportedInterfaceOrientations: [String] = _document["UISupportedInterfaceOrientations"]
    public static let userBoolean: Bool = _document["User Boolean"]
    public static let itsAppUsesNonExemptEncryption: Bool = _document["ITSAppUsesNonExemptEncryption"]
    public static let fabric: [String: Any] = _document["Fabric"]
    public static let nsCameraUsageDescription: String = _document["NSCameraUsageDescription"]
    public static let nsPhotoLibraryUsageDescription: String = _document["NSPhotoLibraryUsageDescription"]
    public static let uiBackgroundModes: [String] = _document["UIBackgroundModes"]
    public static let uiMainStoryboardFile: String = _document["UIMainStoryboardFile"]
    public static let cfBundlePackageType: String = _document["CFBundlePackageType"]
    public static let cfBundleName: String = _document["CFBundleName"]
    public static let uiRequiredDeviceCapabilities: [String] = _document["UIRequiredDeviceCapabilities"]
  }
  public enum Array {
    public static let items: [String] = arrayFromPlist(at: "array.plist")
  }
  public enum Dictionary {
    private static let _document = PlistDocument(path: "dictionary.plist")
    public static let key2: [String: Any] = _document["key2"]
    public static let key1: String = _document["key1"]
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

private func arrayFromPlist<T>(at path: String) -> [T] {
  let bundle = Bundle(for: BundleToken.self)
  guard let url = bundle.url(forResource: path, withExtension: nil),
    let data = NSArray(contentsOf: url) as? [T] else {
    fatalError("Unable to load PLIST at path: \(path)")
  }
  return data
}

private struct PlistDocument {
  let data: [String: Any]

  init(path: String) {
    let bundle = Bundle(for: BundleToken.self)
    guard let url = bundle.url(forResource: path, withExtension: nil),
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

private final class BundleToken {}
