// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// Plural format key: "Your %3$#@third@ list contains %1$#@first@ %2$#@second@."
  internal static func multiplePlaceholdersAndVariablesIntStringString(_ p1: Int, _ p2: Any, _ p3: Any) -> String {
    return L10n.tr("LocPluralAdvanced", "multiple.placeholders-and-variables.int-string-string", p1, String(describing: p2), String(describing: p3))
  }
  /// Plural format key: "%#@element@ %#@has_rating@"
  internal static func multiplePlaceholdersAndVariablesStringInt(_ p1: Any, _ p2: Int) -> String {
    return L10n.tr("LocPluralAdvanced", "multiple.placeholders-and-variables.string-int", String(describing: p1), p2)
  }
  /// Plural format key: "%#@files@ (%#@bytes@, %#@minutes@)"
  internal static func multipleVariablesThreeVariablesInFormatkey(_ p1: Int, _ p2: Int, _ p3: Int) -> String {
    return L10n.tr("LocPluralAdvanced", "multiple.variables.three-variables-in-formatkey", p1, p2, p3)
  }
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: BundleToken.bundle, comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle = Bundle(for: BundleToken.self)
}
// swiftlint:enable convenience_type
