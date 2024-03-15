// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum XCTLoc {
  /// Some /*alert body there
  internal static let alertMessage = XCTLoc.tr("Localizable", "alert__message", fallback: "Some /*alert body there")
  /// Title for an alert 1️⃣
  internal static let alertTitle = XCTLoc.tr("Localizable", "alert__title", fallback: "Title of the alert")
  /// value1	value
  internal static let key1 = XCTLoc.tr("Localizable", "key1", fallback: "value1\tvalue")
  /// These are %3$@'s %1$d %2$@.
  internal static func objectOwnership(_ p1: Int, _ p2: Any, _ p3: Any) -> String {
    return XCTLoc.tr("Localizable", "ObjectOwnership", p1, String(describing: p2), String(describing: p3), fallback: "These are %3$@'s %1$d %2$@.")
  }
  /// This is a %% character.
  internal static let percent = XCTLoc.tr("Localizable", "percent", fallback: "This is a %% character.")
  /// Hello, my name is "%@" and I'm %d
  internal static func `private`(_ p1: Any, _ p2: Int) -> String {
    return XCTLoc.tr("Localizable", "private", String(describing: p1), p2, fallback: "Hello, my name is \"%@\" and I'm %d")
  }
  /// Object: '%@', Character: '%c', Integer: '%d', Float: '%f', CString: '%s', Pointer: '%p'
  internal static func types(_ p1: Any, _ p2: CChar, _ p3: Int, _ p4: Float, _ p5: UnsafePointer<CChar>, _ p6: UnsafeRawPointer) -> String {
    return XCTLoc.tr("Localizable", "types", String(describing: p1), p2, p3, p4, p5, Int(bitPattern: p6), fallback: "Object: '%@', Character: '%c', Integer: '%d', Float: '%f', CString: '%s', Pointer: '%p'")
  }
  /// You have %d apples
  internal static func applesCount(_ p1: Int) -> String {
    return XCTLoc.tr("Localizable", "apples.count", p1, fallback: "You have %d apples")
  }
  /// A comment with no space above it
  internal static func bananasOwner(_ p1: Int, _ p2: Any) -> String {
    return XCTLoc.tr("Localizable", "bananas.owner", p1, String(describing: p2), fallback: "Those %d bananas belong to %@.")
  }
  /// Same as "key1" = "value1"; but in the context of user not logged in
  internal static let key1Anonymous = XCTLoc.tr("Localizable", "key1.anonymous", fallback: "value2")
  /// %@ %d %f %5$d %04$f %6$d %007$@ %8$3.2f %11$1.2f %9$@ %10$d
  internal static func manyPlaceholdersBase(_ p1: Any, _ p2: Int, _ p3: Float, _ p4: Float, _ p5: Int, _ p6: Int, _ p7: Any, _ p8: Float, _ p9: Any, _ p10: Int, _ p11: Float) -> String {
    return XCTLoc.tr("Localizable", "many.placeholders.base", String(describing: p1), p2, p3, p4, p5, p6, String(describing: p7), p8, String(describing: p9), p10, p11, fallback: "%@ %d %f %5$d %04$f %6$d %007$@ %8$3.2f %11$1.2f %9$@ %10$d")
  }
  /// %@ %d %0$@ %f %5$d %04$f %6$d %007$@ %8$3.2f %11$1.2f %9$@ %10$d
  internal static func manyPlaceholdersZero(_ p1: Any, _ p2: Int, _ p3: Float, _ p4: Float, _ p5: Int, _ p6: Int, _ p7: Any, _ p8: Float, _ p9: Any, _ p10: Int, _ p11: Float) -> String {
    return XCTLoc.tr("Localizable", "many.placeholders.zero", String(describing: p1), p2, p3, p4, p5, p6, String(describing: p7), p8, String(describing: p9), p10, p11, fallback: "%@ %d %0$@ %f %5$d %04$f %6$d %007$@ %8$3.2f %11$1.2f %9$@ %10$d")
  }
  /// Some Reserved Keyword there👍🏽
  internal static let settingsNavigationBarSelf_️ = XCTLoc.tr("Localizable", "settings.navigation-bar.self♦️", fallback: "Some Reserved Keyword there👍🏽")
  /// DeepSettings
  internal static let settingsNavigationBarTitleDeeperThanWeCanHandleNoReallyThisIsDeep = XCTLoc.tr("Localizable", "settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep", fallback: "DeepSettings")
  /// Settings
  internal static let settingsNavigationBarTitleEvenDeeper = XCTLoc.tr("Localizable", "settings.navigation-bar.title.even.deeper", fallback: "Settings")
  /// Here you can change some user profile settings.
  internal static let settingsUserProfileSectionFooterText = XCTLoc.tr("Localizable", "settings.user__profile_section.footer_text", fallback: "Here you can change some user profile settings.")
  /// User Profile Settings
  internal static let settingsUserProfileSectionHEADERTITLE = XCTLoc.tr("Localizable", "settings.user__profile_section.HEADER_TITLE", fallback: "User Profile Settings")
  /// some comment 👨‍👩‍👧‍👦
  internal static let whatHappensHere = XCTLoc.tr("Localizable", "what./*happens*/.here", fallback: "hello world! /* still in string */")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension XCTLoc {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
// swiftlint:enable all
