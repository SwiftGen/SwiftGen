// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Mixed {
    internal enum PlaceholdersAndVariables {
      /// Plural format key: "%1$@ %3$#@has_rating@"
      internal static func positionalstringPositional3int(_ p1: Any, _ p2: Int) -> String {
        return L10n.tr("LocPluralAdvanced", "mixed.placeholders-and-variables.positionalstring-positional3int", String(describing: p1), p2)
      }
      /// Plural format key: "%@ %#@has_rating@"
      internal static func stringInt(_ p1: Any, _ p2: Int) -> String {
        return L10n.tr("LocPluralAdvanced", "mixed.placeholders-and-variables.string-int", String(describing: p1), p2)
      }
      /// Plural format key: "%@ %2$#@has_rating@"
      internal static func stringPositional2int(_ p1: Any, _ p2: Int) -> String {
        return L10n.tr("LocPluralAdvanced", "mixed.placeholders-and-variables.string-positional2int", String(describing: p1), p2)
      }
      /// Plural format key: "%@ %3$#@has_rating@"
      internal static func stringPositional3int(_ p1: Any, _ p2: Int) -> String {
        return L10n.tr("LocPluralAdvanced", "mixed.placeholders-and-variables.string-positional3int", String(describing: p1), p2)
      }
    }
  }

  internal enum Multiple {
    internal enum PlaceholdersAndVariables {
      /// Plural format key: "Your %3$@ list contains %1$#@first@ %2$@."
      internal static func intStringString(_ p1: Int, _ p2: Any, _ p3: Any) -> String {
        return L10n.tr("LocPluralAdvanced", "multiple.placeholders-and-variables.int-string-string", p1, String(describing: p2), String(describing: p3))
      }
    }
    internal enum Variables {
      /// Plural format key: "%#@files@ (%#@bytes@, %#@minutes@)"
      internal static func threeVariablesInFormatkey(_ p1: Int, _ p2: Int, _ p3: Int) -> String {
        return L10n.tr("LocPluralAdvanced", "multiple.variables.three-variables-in-formatkey", p1, p2, p3)
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

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
