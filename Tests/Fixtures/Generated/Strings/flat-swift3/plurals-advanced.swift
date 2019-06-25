// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// Plural case 'other': %@ has %d ratings
  internal static func multiplePlaceholdersStringInt(_ p1: Int) -> String {
    return L10n.tr("LocPluralAdvanced", "multiple.placeholders.string-int", p1)
  }
  /// Plural case 'other': %d files remaining (%d bytes, %d minutes)
  internal static func multipleVariablesThreeVariablesInFormatkey(_ p1: Int, _ p2: Int, _ p3: Int) -> String {
    return L10n.tr("LocPluralAdvanced", "multiple.variables.three-variables-in-formatkey", p1, p2, p3)
  }
  /// Plural case 'other': %1$#@geese@
  internal static func nestedFormatkeyInVariable(_ p1: Int, _ p2: Int, _ p3: Int) -> String {
    return L10n.tr("LocPluralAdvanced", "nested.formatkey-in-variable", p1, p2, p3)
  }
  /// Plural case 'other': %1$#@first_level@
  internal static func nestedFormatkeyInVariableDeep(_ p1: Int, _ p2: Int, _ p3: Int) -> String {
    return L10n.tr("LocPluralAdvanced", "nested.formatkey-in-variable-deep", p1, p2, p3)
  }
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: BundleToken.bundle, comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
