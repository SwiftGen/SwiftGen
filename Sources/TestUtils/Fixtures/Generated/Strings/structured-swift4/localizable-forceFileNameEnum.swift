// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
enum L10n {
  enum Localizable {
    /// Some alert body there
    static let alertMessage = L10n.tr("Localizable", "alert__message")
    /// Title of the alert
    static let alertTitle = L10n.tr("Localizable", "alert__title")
    /// These are %3$@'s %1$d %2$@.
    static func objectOwnership(_ p1: Int, _ p2: Any, _ p3: Any) -> String {
      return L10n.tr("Localizable", "ObjectOwnership", p1, String(describing: p2), String(describing: p3))
    }
    /// This is a %% character.
    static let percent = L10n.tr("Localizable", "percent")
    /// Hello, my name is %@ and I'm %d
    static func `private`(_ p1: Any, _ p2: Int) -> String {
      return L10n.tr("Localizable", "private", String(describing: p1), p2)
    }
    /// Object: '%@', Character: '%c', Integer: '%d', Float: '%f', CString: '%s', Pointer: '%p'
    static func types(_ p1: Any, _ p2: CChar, _ p3: Int, _ p4: Float, _ p5: UnsafePointer<CChar>, _ p6: UnsafeRawPointer) -> String {
      return L10n.tr("Localizable", "types", String(describing: p1), p2, p3, p4, p5, Int(bitPattern: p6))
    }
    enum Apples {
      /// You have %d apples
      static func count(_ p1: Int) -> String {
        return L10n.tr("Localizable", "apples.count", p1)
      }
    }
    enum Bananas {
      /// Those %d bananas belong to %@.
      static func owner(_ p1: Int, _ p2: Any) -> String {
        return L10n.tr("Localizable", "bananas.owner", p1, String(describing: p2))
      }
    }
    enum Many {
      enum Placeholders {
        /// %@ %d %f %5$d %04$f %6$d %007$@ %8$3.2f %11$1.2f %9$@ %10$d
        static func base(_ p1: Any, _ p2: Int, _ p3: Float, _ p4: Float, _ p5: Int, _ p6: Int, _ p7: Any, _ p8: Float, _ p9: Any, _ p10: Int, _ p11: Float) -> String {
          return L10n.tr("Localizable", "many.placeholders.base", String(describing: p1), p2, p3, p4, p5, p6, String(describing: p7), p8, String(describing: p9), p10, p11)
        }
        /// %@ %d %0$@ %f %5$d %04$f %6$d %007$@ %8$3.2f %11$1.2f %9$@ %10$d
        static func zero(_ p1: Any, _ p2: Int, _ p3: Float, _ p4: Float, _ p5: Int, _ p6: Int, _ p7: Any, _ p8: Float, _ p9: Any, _ p10: Int, _ p11: Float) -> String {
          return L10n.tr("Localizable", "many.placeholders.zero", String(describing: p1), p2, p3, p4, p5, p6, String(describing: p7), p8, String(describing: p9), p10, p11)
        }
      }
    }
    enum Settings {
      enum NavigationBar {
        /// Some Reserved Keyword there
        static let `self` = L10n.tr("Localizable", "settings.navigation-bar.self")
        enum Title {
          enum Deeper {
            enum Than {
              enum We {
                enum Can {
                  enum Handle {
                    enum No {
                      enum Really {
                        enum This {
                          enum Is {
                            /// DeepSettings
                            static let deep = L10n.tr("Localizable", "settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep")
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
          enum Even {
            /// Settings
            static let deeper = L10n.tr("Localizable", "settings.navigation-bar.title.even.deeper")
          }
        }
      }
      enum UserProfileSection {
        /// Here you can change some user profile settings.
        static let footerText = L10n.tr("Localizable", "settings.user__profile_section.footer_text")
        /// User Profile Settings
        static let headerTitle = L10n.tr("Localizable", "settings.user__profile_section.HEADER_TITLE")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
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
