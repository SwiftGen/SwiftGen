// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// Plural case 'other': %ld matches
  internal static func competitionEventNumberOfMatches(_ p1: Int) -> String {
    return L10n.tr("Localizable", "competition.event.number-of-matches", p1)
  }
  /// Plural case 'other': %ld subscriptions
  internal static func feedSubscriptionCount(_ p1: Int) -> String {
    return L10n.tr("Localizable", "feed.subscription.count", p1)
  }
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
