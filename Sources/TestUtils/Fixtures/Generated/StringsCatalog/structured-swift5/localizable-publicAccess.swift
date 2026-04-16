// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// Some /*alert body there
  public static let alertMessage = L10n.tr("Localizable", "alert__message", fallback: "Some /*alert body there")
  /// Title for an alert 1️⃣
  public static let alertTitle = L10n.tr("Localizable", "alert__title", fallback: "Title of the alert")
  /// value1	value
  public static let key1 = L10n.tr("Localizable", "key1", fallback: "value1\tvalue")
  /// These are %3$@'s %1$d %2$@.
  public static func objectOwnership(_ p1: Int, _ p2: Any, _ p3: Any) -> String {
    return L10n.tr("Localizable", "ObjectOwnership", p1, String(describing: p2), String(describing: p3), fallback: "These are %3$@'s %1$d %2$@.")
  }
  /// This is a %% character.
  public static let percent = L10n.tr("Localizable", "percent", fallback: "This is a %% character.")
  /// Hello, my name is "%@" and I'm %d
  public static func `private`(_ p1: Any, _ p2: Int) -> String {
    return L10n.tr("Localizable", "private", String(describing: p1), p2, fallback: "Hello, my name is \"%@\" and I'm %d")
  }
  /// Object: '%@', Character: '%c', Integer: '%d', Float: '%f', CString: '%s', Pointer: '%p'
  public static func types(_ p1: Any, _ p2: CChar, _ p3: Int, _ p4: Float, _ p5: UnsafePointer<CChar>, _ p6: UnsafeRawPointer) -> String {
    return L10n.tr("Localizable", "types", String(describing: p1), p2, p3, p4, p5, Int(bitPattern: p6), fallback: "Object: '%@', Character: '%c', Integer: '%d', Float: '%f', CString: '%s', Pointer: '%p'")
  }
  public enum Apples {
    /// You have %d apples
    public static func count(_ p1: Int) -> String {
      return L10n.tr("Localizable", "apples.count", p1, fallback: "You have %d apples")
    }
  }
  public enum Bananas {
    /// A comment with no space above it
    public static func owner(_ p1: Int, _ p2: Any) -> String {
      return L10n.tr("Localizable", "bananas.owner", p1, String(describing: p2), fallback: "Those %d bananas belong to %@.")
    }
  }
  public enum Key1 {
    /// Same as "key1" = "value1"; but in the context of user not logged in
    public static let anonymous = L10n.tr("Localizable", "key1.anonymous", fallback: "value2")
  }
  public enum Many {
    public enum Placeholders {
      /// %@ %d %f %5$d %04$f %6$d %007$@ %8$3.2f %11$1.2f %9$@ %10$d
      public static func base(_ p1: Any, _ p2: Int, _ p3: Float, _ p4: Float, _ p5: Int, _ p6: Int, _ p7: Any, _ p8: Float, _ p9: Any, _ p10: Int, _ p11: Float) -> String {
        return L10n.tr("Localizable", "many.placeholders.base", String(describing: p1), p2, p3, p4, p5, p6, String(describing: p7), p8, String(describing: p9), p10, p11, fallback: "%@ %d %f %5$d %04$f %6$d %007$@ %8$3.2f %11$1.2f %9$@ %10$d")
      }
      /// %@ %d %0$@ %f %5$d %04$f %6$d %007$@ %8$3.2f %11$1.2f %9$@ %10$d
      public static func zero(_ p1: Any, _ p2: Int, _ p3: Float, _ p4: Float, _ p5: Int, _ p6: Int, _ p7: Any, _ p8: Float, _ p9: Any, _ p10: Int, _ p11: Float) -> String {
        return L10n.tr("Localizable", "many.placeholders.zero", String(describing: p1), p2, p3, p4, p5, p6, String(describing: p7), p8, String(describing: p9), p10, p11, fallback: "%@ %d %0$@ %f %5$d %04$f %6$d %007$@ %8$3.2f %11$1.2f %9$@ %10$d")
      }
    }
  }
  public enum Settings {
    public enum NavigationBar {
      /// Some Reserved Keyword there👍🏽
      public static let self_️ = L10n.tr("Localizable", "settings.navigation-bar.self♦️", fallback: "Some Reserved Keyword there👍🏽")
      public enum Title {
        public enum Deeper {
          public enum Than {
            public enum We {
              public enum Can {
                public enum Handle {
                  public enum No {
                    public enum Really {
                      public enum This {
                        public enum Is {
                          /// DeepSettings
                          public static let deep = L10n.tr("Localizable", "settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep", fallback: "DeepSettings")
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        public enum Even {
          /// Settings
          public static let deeper = L10n.tr("Localizable", "settings.navigation-bar.title.even.deeper", fallback: "Settings")
        }
      }
    }
    public enum UserProfileSection {
      /// Here you can change some user profile settings.
      public static let footerText = L10n.tr("Localizable", "settings.user__profile_section.footer_text", fallback: "Here you can change some user profile settings.")
      /// User Profile Settings
      public static let headerTitle = L10n.tr("Localizable", "settings.user__profile_section.HEADER_TITLE", fallback: "User Profile Settings")
    }
  }
  public enum What {
    public enum Happens {
      /// some comment 👨‍👩‍👧‍👦
      public static let here = L10n.tr("Localizable", "what./*happens*/.here", fallback: "hello world! /* still in string */")
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
