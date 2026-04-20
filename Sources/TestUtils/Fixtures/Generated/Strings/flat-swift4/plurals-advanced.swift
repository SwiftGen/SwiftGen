// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// %d twos
  internal static func manyPlaceholdersPluralsBase(_ p1: Any, _ p2: Int, _ p3: Float, _ p4: Float, _ p5: Int, _ p6: Int, _ p7: Any, _ p8: Any, _ p9: Int, _ p10: Float) -> String {
    return L10n.tr("LocPluralAdvanced", "many.placeholders.plurals.base", String(describing: p1), p2, p3, p4, p5, p6, String(describing: p7), String(describing: p8), p9, p10, fallback: "%d twos")
  }
  /// %d twos
  internal static func manyPlaceholdersPluralsZero(_ p1: Any, _ p2: Int, _ p3: Float, _ p4: Float, _ p5: Int, _ p6: Int, _ p7: Any, _ p8: Any, _ p9: Int, _ p10: Float) -> String {
    return L10n.tr("LocPluralAdvanced", "many.placeholders.plurals.zero", String(describing: p1), p2, p3, p4, p5, p6, String(describing: p7), String(describing: p8), p9, p10, fallback: "%d twos")
  }
  /// has %d ratings
  internal static func mixedPlaceholdersAndVariablesPositionalstringPositional3int(_ p1: Any, _ p2: Int) -> String {
    return L10n.tr("LocPluralAdvanced", "mixed.placeholders-and-variables.positionalstring-positional3int", String(describing: p1), p2, fallback: "has %d ratings")
  }
  /// has %d ratings
  internal static func mixedPlaceholdersAndVariablesStringInt(_ p1: Any, _ p2: Int) -> String {
    return L10n.tr("LocPluralAdvanced", "mixed.placeholders-and-variables.string-int", String(describing: p1), p2, fallback: "has %d ratings")
  }
  /// has %d ratings
  internal static func mixedPlaceholdersAndVariablesStringPositional2int(_ p1: Any, _ p2: Int) -> String {
    return L10n.tr("LocPluralAdvanced", "mixed.placeholders-and-variables.string-positional2int", String(describing: p1), p2, fallback: "has %d ratings")
  }
  /// has %d ratings
  internal static func mixedPlaceholdersAndVariablesStringPositional3int(_ p1: Any, _ p2: Int) -> String {
    return L10n.tr("LocPluralAdvanced", "mixed.placeholders-and-variables.string-positional3int", String(describing: p1), p2, fallback: "has %d ratings")
  }
  /// %1$d items. You should buy them
  internal static func multiplePlaceholdersAndVariablesIntStringString(_ p1: Int, _ p2: Any, _ p3: Any) -> String {
    return L10n.tr("LocPluralAdvanced", "multiple.placeholders-and-variables.int-string-string", p1, String(describing: p2), String(describing: p3), fallback: "%1$d items. You should buy them")
  }
  /// %d files remaining
  internal static func multipleVariablesThreeVariablesInFormatkey(_ p1: Int, _ p2: Int, _ p3: Int) -> String {
    return L10n.tr("LocPluralAdvanced", "multiple.variables.three-variables-in-formatkey", p1, p2, p3, fallback: "%d files remaining")
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
