// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// Plural format key: apples.count
  internal static func applesCount(_ p1: Int) -> String {
    return L10n.tr("LocalizableDict", "apples.count", p1, fallback: "Plural format key: apples.count")
  }
  /// Plural format key: competition.event.number-of-matches
  internal static func competitionEventNumberOfMatches(_ p1: Int) -> String {
    return L10n.tr("LocalizableDict", "competition.event.number-of-matches", p1, fallback: "Plural format key: competition.event.number-of-matches")
  }
  /// Key: competition.tab.favorite-players
  internal static let competitionTabFavoritePlayers = L10n.tr("LocalizableDict", "competition.tab.favorite-players", fallback: "Key: competition.tab.favorite-players")
  /// Key: competition.tab.favorite-teams
  internal static let competitionTabFavoriteTeams = L10n.tr("LocalizableDict", "competition.tab.favorite-teams", fallback: "Key: competition.tab.favorite-teams")
  /// Plural format key: feed.subscription.count
  internal static func feedSubscriptionCount(_ p1: Int) -> String {
    return L10n.tr("LocalizableDict", "feed.subscription.count", p1, fallback: "Plural format key: feed.subscription.count")
  }
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
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
