// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable identifier_name line_length type_body_length
internal enum XCTLoc {
  /// Some alert body there
  internal static let alertMessage = XCTLoc.tr("Localizable", "alert_message")
  /// Title of the alert
  internal static let alertTitle = XCTLoc.tr("Localizable", "alert_title")
  /// These are %3$@'s %1$d %2$@.
  internal static func objectOwnership(_ p1: Int, _ p2: String, _ p3: String) -> String {
    return XCTLoc.tr("Localizable", "ObjectOwnership", p1, p2, p3)
  }
  /// Hello, my name is %@ and I'm %d
  internal static func `private`(_ p1: String, _ p2: Int) -> String {
    return XCTLoc.tr("Localizable", "private", p1, p2)
  }
  /// You have %d apples
  internal static func applesCount(_ p1: Int) -> String {
    return XCTLoc.tr("Localizable", "apples.count", p1)
  }
  /// Those %d bananas belong to %@.
  internal static func bananasOwner(_ p1: Int, _ p2: String) -> String {
    return XCTLoc.tr("Localizable", "bananas.owner", p1, p2)
  }
  /// Some Reserved Keyword there
  internal static let settingsNavigationBarSelf = XCTLoc.tr("Localizable", "settings.navigation-bar.self")
  /// DeepSettings
  internal static let settingsNavigationBarTitleDeeperThanWeCanHandleNoReallyThisIsDeep = XCTLoc.tr("Localizable", "settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep")
  /// Settings
  internal static let settingsNavigationBarTitleEvenDeeper = XCTLoc.tr("Localizable", "settings.navigation-bar.title.even.deeper")
  /// Here you can change some user profile settings.
  internal static let seTTingsUSerProFileSectioNFooterText = XCTLoc.tr("Localizable", "seTTings.uSer-proFile-sectioN.footer_text")
  /// User Profile Settings
  internal static let settingsUserProfileSectionHeaderTitle = XCTLoc.tr("Localizable", "SETTINGS.USER_PROFILE_SECTION.HEADER_TITLE")
}
// swiftlint:enable identifier_name line_length type_body_length

extension XCTLoc {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
