// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Plist Files

// swiftlint:disable identifier_name line_length number_separator type_body_length
enum CustomPlist {
  enum Info {
    static let cfBundleDevelopmentRegion: String = "en"
    static let cfBundleDisplayName: String = "${PRODUCT_NAME}"
    static let cfBundleExecutable: String = "${EXECUTABLE_NAME}"
    static let cfBundleIdentifier: String = "$(PRODUCT_BUNDLE_IDENTIFIER)"
    static let cfBundleInfoDictionaryVersion: String = "6.0"
    static let cfBundleName: String = "${PRODUCT_NAME}"
    static let cfBundlePackageType: String = "APPL"
    static let cfBundleShortVersionString: String = "1.2.0"
    static let cfBundleSignature: String = "????"
    static let cfBundleVersion: String = "0"
    static let fabric: [String: Any] = ["APIKey": "512345678900aaafffff", "Kits": [["KitInfo": [:], "KitName": "Crashlytics"]]]
    static let itsAppUsesNonExemptEncryption: Bool = false
    static let lsRequiresIPhoneOS: Bool = true
    static let nsAppTransportSecurity: [String: Any] = [:]
    static let nsCameraUsageDescription: String = "24 Vision needs access to your camera for uploading photos for caes, or for your profile picture."
    static let nsPhotoLibraryUsageDescription: String = "24 Vision needs access to your photo library for uploading photos for caes, or for your profile picture."
    static let uiBackgroundModes: [String] = ["remote-notification"]
    static let uiLaunchStoryboardName: String = "LaunchScreen"
    static let uiMainStoryboardFile: String = "Start"
    static let uiRequiredDeviceCapabilities: [String] = ["armv7"]
    static let uiRequiresFullScreen: Bool = true
    static let uiStatusBarStyle: String = "UIStatusBarStyleDefault"
    static let uiSupportedInterfaceOrientations: [String] = ["UIInterfaceOrientationPortrait", "UIInterfaceOrientationPortraitUpsideDown", "UIInterfaceOrientationLandscapeRight", "UIInterfaceOrientationLandscapeLeft"]
    static let uiSupportedInterfaceOrientationsIpad: [String] = ["UIInterfaceOrientationLandscapeLeft", "UIInterfaceOrientationLandscapeRight", "UIInterfaceOrientationPortraitUpsideDown", "UIInterfaceOrientationPortrait"]
    static let userAmbiguousInteger: Int = 1
    static let userBoolean: Bool = false
    static let userDate: Date = Date(timeIntervalSinceReferenceDate: 547184366)
    static let userFloat: Double = 3.14
    static let userInteger: Int = 5
  }
  enum Configuration {
    static let environment: String = "development"
    static let flags: [Bool] = [true, false, true]
    static let mixed: [Any] = ["One", 1, true]
    static let mixed2: [Any] = [0.1, 1, true]
    static let names: [String] = ["John", "Peter", "Nick"]
    static let one: Int = 1
    static let options: [String: Any] = ["Animation Style": "Party Mode"]
    static let primes: [Int] = [2, 3, 5, 7]
    static let zero: Int = 0
  }
  enum ShoppingList {
    static let items: [String] = ["Eggs", "Bread", "Milk"]
  }
}
// swiftlint:enable identifier_name line_length number_separator type_body_length
