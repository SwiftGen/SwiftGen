// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable identifier_name line_length type_body_length
public enum L10n {
  /// Some alert body there
  public static let AlertMessage = L10n.tr("Localizable", "alert_message")
  /// Title of the alert
  public static let AlertTitle = L10n.tr("Localizable", "alert_title")
  /// These are %3$@'s %1$d %2$@.
  public static func ObjectOwnership(p1: Int, p2: String, p3: String) -> String {
    return L10n.tr("Localizable", "ObjectOwnership", p1, p2, p3)
  }
  /// Hello, my name is %@ and I'm %d
  public static func Private(p1: String, p2: Int) -> String {
    return L10n.tr("Localizable", "private", p1, p2)
  }
  /// You have %d apples
  public static func ApplesCount(p1: Int) -> String {
    return L10n.tr("Localizable", "apples.count", p1)
  }
  /// Those %d bananas belong to %@.
  public static func BananasOwner(p1: Int, p2: String) -> String {
    return L10n.tr("Localizable", "bananas.owner", p1, p2)
  }
  /// Some Reserved Keyword there
  public static let SettingsNavigationBarSelf = L10n.tr("Localizable", "settings.navigation-bar.self")
  /// DeepSettings
  public static let SettingsNavigationBarTitleDeeperThanWeCanHandleNoReallyThisIsDeep = L10n.tr("Localizable", "settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep")
  /// Settings
  public static let SettingsNavigationBarTitleEvenDeeper = L10n.tr("Localizable", "settings.navigation-bar.title.even.deeper")
  /// Here you can change some user profile settings.
  public static let SettingsUserProfileSectionFooterText = L10n.tr("Localizable", "settings.user_profile_section.footer_text")
  /// User Profile Settings
  public static let SettingsUserProfileSectionHEADERTITLE = L10n.tr("Localizable", "settings.user_profile_section.HEADER_TITLE")
}
// swiftlint:enable identifier_name line_length type_body_length

extension L10n {
  private static func tr(table: String, _ key: String, _ args: CVarArgType...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: NSBundle(forClass: BundleToken.self), comment: "")
    return String(format: format, locale: NSLocale.currentLocale(), arguments: args)
  }
}

private final class BundleToken {}
