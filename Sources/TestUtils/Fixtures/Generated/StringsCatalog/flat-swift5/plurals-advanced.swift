// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// %@ - %#@d2@ - %#@f3@ - %#@d5@ - %04$#@f4@ - %#@d6@ - %007$@ - %8$3.2#@f8@ - %#@f11@ - %9$@ - %#@d10@
  internal static func manyPlaceholdersPluralsBase(_ p1: Any, _ p2: Any, _ p3: Any, _ p4: Any, _ p5: Any, _ p6: Any, _ p7: Any, _ p8: Any) -> String {
    return L10n.tr("LocPluralAdvanced", "many.placeholders.plurals.base", String(describing: p1), String(describing: p2), String(describing: p3), String(describing: p4), String(describing: p5), String(describing: p6), String(describing: p7), String(describing: p8), fallback: "%@ - %#@d2@ - %#@f3@ - %#@d5@ - %04$#@f4@ - %#@d6@ - %007$@ - %8$3.2#@f8@ - %#@f11@ - %9$@ - %#@d10@")
  }
  /// %@ - %#@d2@ - %0$#@zero@ - %#@f3@ - %#@d5@ - %04$#@f4@ - %#@d6@ - %007$@ - %8$3.2#@f8@ - %#@f11@ - %9$@ - %#@d10@
  internal static func manyPlaceholdersPluralsZero(_ p1: Any, _ p2: Any, _ p3: Any, _ p4: Any, _ p5: Any, _ p6: Any, _ p7: Any, _ p8: Any) -> String {
    return L10n.tr("LocPluralAdvanced", "many.placeholders.plurals.zero", String(describing: p1), String(describing: p2), String(describing: p3), String(describing: p4), String(describing: p5), String(describing: p6), String(describing: p7), String(describing: p8), fallback: "%@ - %#@d2@ - %0$#@zero@ - %#@f3@ - %#@d5@ - %04$#@f4@ - %#@d6@ - %007$@ - %8$3.2#@f8@ - %#@f11@ - %9$@ - %#@d10@")
  }
  /// %1$@ %#@has_rating@
  internal static func mixedPlaceholdersAndVariablesPositionalstringPositional3int(_ p1: Any) -> String {
    return L10n.tr("LocPluralAdvanced", "mixed.placeholders-and-variables.positionalstring-positional3int", String(describing: p1), fallback: "%1$@ %#@has_rating@")
  }
  /// %@ %#@has_rating@
  internal static func mixedPlaceholdersAndVariablesStringInt(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("LocPluralAdvanced", "mixed.placeholders-and-variables.string-int", String(describing: p1), String(describing: p2), fallback: "%@ %#@has_rating@")
  }
  /// %@ %#@has_rating@
  internal static func mixedPlaceholdersAndVariablesStringPositional2int(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("LocPluralAdvanced", "mixed.placeholders-and-variables.string-positional2int", String(describing: p1), String(describing: p2), fallback: "%@ %#@has_rating@")
  }
  /// %@ %#@has_rating@
  internal static func mixedPlaceholdersAndVariablesStringPositional3int(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("LocPluralAdvanced", "mixed.placeholders-and-variables.string-positional3int", String(describing: p1), String(describing: p2), fallback: "%@ %#@has_rating@")
  }
  /// Your %3$@ list contains %#@first@ %2$@.
  internal static func multiplePlaceholdersAndVariablesIntStringString(_ p1: Any, _ p2: Any, _ p3: Any) -> String {
    return L10n.tr("LocPluralAdvanced", "multiple.placeholders-and-variables.int-string-string", String(describing: p1), String(describing: p2), String(describing: p3), fallback: "Your %3$@ list contains %#@first@ %2$@.")
  }
  /// %#@files@ (%#@bytes@, %#@minutes@)
  internal static func multipleVariablesThreeVariablesInFormatkey(_ p1: Any, _ p2: Any, _ p3: Any) -> String {
    return L10n.tr("LocPluralAdvanced", "multiple.variables.three-variables-in-formatkey", String(describing: p1), String(describing: p2), String(describing: p3), fallback: "%#@files@ (%#@bytes@, %#@minutes@)")
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
