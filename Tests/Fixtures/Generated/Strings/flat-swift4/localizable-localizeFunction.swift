// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// Some alert body there
  internal static var alertMessage: String { return L10n.tr("Localizable", "alert__message") }
  /// Title of the alert
  internal static var alertTitle: String { return L10n.tr("Localizable", "alert__title") }
  /// These are %3$@'s %1$d %2$@.
  internal static func objectOwnership(_ p1: Int, _ p2: Any, _ p3: Any) -> String {
    return L10n.tr("Localizable", "ObjectOwnership", p1, String(describing: p2), String(describing: p3))
  }
  /// This is a %% character.
  internal static var percent: String { return L10n.tr("Localizable", "percent") }
  /// Hello, my name is %@ and I'm %d
  internal static func `private`(_ p1: Any, _ p2: Int) -> String {
    return L10n.tr("Localizable", "private", String(describing: p1), p2)
  }
  /// Object: '%@', Character: '%c', Integer: '%d', Float: '%f', CString: '%s', Pointer: '%p'
  internal static func types(_ p1: Any, _ p2: CChar, _ p3: Int, _ p4: Float, _ p5: UnsafePointer<CChar>, _ p6: UnsafeRawPointer) -> String {
    return L10n.tr("Localizable", "types", String(describing: p1), p2, p3, p4, p5, Int(bitPattern: p6))
  }
  /// You have %d apples
  internal static func applesCount(_ p1: Int) -> String {
    return L10n.tr("Localizable", "apples.count", p1)
  }
  /// Those %d bananas belong to %@.
  internal static func bananasOwner(_ p1: Int, _ p2: Any) -> String {
    return L10n.tr("Localizable", "bananas.owner", p1, String(describing: p2))
  }
  /// Some Reserved Keyword there
  internal static var settingsNavigationBarSelf: String { return L10n.tr("Localizable", "settings.navigation-bar.self") }
  /// DeepSettings
  internal static var settingsNavigationBarTitleDeeperThanWeCanHandleNoReallyThisIsDeep: String { return L10n.tr("Localizable", "settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep") }
  /// Settings
  internal static var settingsNavigationBarTitleEvenDeeper: String { return L10n.tr("Localizable", "settings.navigation-bar.title.even.deeper") }
  /// Here you can change some user profile settings.
  internal static var settingsUserProfileSectionFooterText: String { return L10n.tr("Localizable", "settings.user__profile_section.footer_text") }
  /// User Profile Settings
  internal static var settingsUserProfileSectionHEADERTITLE: String { return L10n.tr("Localizable", "settings.user__profile_section.HEADER_TITLE") }
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = XCTLocFunc(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
