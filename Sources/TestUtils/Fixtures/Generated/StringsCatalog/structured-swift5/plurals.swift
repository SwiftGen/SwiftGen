// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Apples {
    /// Plural format key: apples.count
    internal static func count(_ p1: Int) -> String {
      return L10n.tr("LocalizableDict", "apples.count", p1, fallback: "Plural format key: apples.count")
    }
  }
  internal enum Competition {
    internal enum Event {
      /// Plural format key: competition.event.number-of-matches
      internal static func numberOfMatches(_ p1: Int) -> String {
        return L10n.tr("LocalizableDict", "competition.event.number-of-matches", p1, fallback: "Plural format key: competition.event.number-of-matches")
      }
    }
    internal enum Tab {
      /// Key: competition.tab.favorite-players
      internal static let favoritePlayers = L10n.tr("LocalizableDict", "competition.tab.favorite-players", fallback: "Key: competition.tab.favorite-players")
      /// Key: competition.tab.favorite-teams
      internal static let favoriteTeams = L10n.tr("LocalizableDict", "competition.tab.favorite-teams", fallback: "Key: competition.tab.favorite-teams")
    }
  }
  internal enum Feed {
    internal enum Subscription {
      /// Plural format key: feed.subscription.count
      internal static func count(_ p1: Int) -> String {
        return L10n.tr("LocalizableDict", "feed.subscription.count", p1, fallback: "Plural format key: feed.subscription.count")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

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
