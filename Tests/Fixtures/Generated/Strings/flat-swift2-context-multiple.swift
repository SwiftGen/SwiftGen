// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable identifier_name line_length type_body_length
internal enum L10n {
  internal enum Localizable {
    /// Some alert body there
    internal static let AlertMessage = L10n.tr("Localizable", "alert_message")
    /// Title of the alert
    internal static let AlertTitle = L10n.tr("Localizable", "alert_title")
    /// These are %3$@'s %1$d %2$@.
    internal static func ObjectOwnership(p1: Int, p2: String, p3: String) -> String {
      return L10n.tr("Localizable", "ObjectOwnership", p1, p2, p3)
    }
    /// Hello, my name is %@ and I'm %d
    internal static func Private(p1: String, p2: Int) -> String {
      return L10n.tr("Localizable", "private", p1, p2)
    }
    /// You have %d apples
    internal static func ApplesCount(p1: Int) -> String {
      return L10n.tr("Localizable", "apples.count", p1)
    }
    /// Those %d bananas belong to %@.
    internal static func BananasOwner(p1: Int, p2: String) -> String {
      return L10n.tr("Localizable", "bananas.owner", p1, p2)
    }
    /// Some Reserved Keyword there
    internal static let SettingsNavigationBarSelf = L10n.tr("Localizable", "settings.navigation-bar.self")
    /// DeepSettings
    internal static let SettingsNavigationBarTitleDeeperThanWeCanHandleNoReallyThisIsDeep = L10n.tr("Localizable", "settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep")
    /// Settings
    internal static let SettingsNavigationBarTitleEvenDeeper = L10n.tr("Localizable", "settings.navigation-bar.title.even.deeper")
    /// Here you can change some user profile settings.
    internal static let SeTTingsUSerProFileSectioNFooterText = L10n.tr("Localizable", "seTTings.uSer-proFile-sectioN.footer_text")
    /// User Profile Settings
    internal static let SettingsUserProfileSectionHeaderTitle = L10n.tr("Localizable", "SETTINGS.USER_PROFILE_SECTION.HEADER_TITLE")
  }
  internal enum LocMultiline {
    /// multi\nline
    internal static let Multiline = L10n.tr("LocMultiline", "MULTILINE")
    /// test
    internal static let MultiLineNKey = L10n.tr("LocMultiline", "multiLine\nKey")
    /// another\nmulti\n    line
    internal static let Multiline2 = L10n.tr("LocMultiline", "MULTILINE2")
    /// single line
    internal static let Singleline = L10n.tr("LocMultiline", "SINGLELINE")
    /// another single line
    internal static let Singleline2 = L10n.tr("LocMultiline", "SINGLELINE2")
  }
}
// swiftlint:enable identifier_name line_length type_body_length

extension L10n {
  private static func tr(table: String, _ key: String, _ args: CVarArgType...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: NSBundle(forClass: BundleToken.self), comment: "")
    return String(format: format, locale: NSLocale.currentLocale(), arguments: args)
  }
}

private final class BundleToken {}
