// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum XCTLoc {
  /// Some alert body there
  internal static let alertMessage = XCTLoc.tr("Localizable", "alert__message")
  /// Title of the alert
  internal static let alertTitle = XCTLoc.tr("Localizable", "alert__title")
  /// These are %3$@'s %1$d %2$@.
  internal static func objectOwnership(_ p1: Int, _ p2: Any, _ p3: Any) -> String {
    return XCTLoc.tr("Localizable", "ObjectOwnership", p1, String(describing: p2), String(describing: p3))
  }
  /// This is a %% character.
  internal static let percent = XCTLoc.tr("Localizable", "percent")
  /// Hello, my name is %@ and I'm %d
  internal static func `private`(_ p1: Any, _ p2: Int) -> String {
    return XCTLoc.tr("Localizable", "private", String(describing: p1), p2)
  }
  /// Object: '%@', Character: '%c', Integer: '%d', Float: '%f', CString: '%s', Pointer: '%p'
  internal static func types(_ p1: Any, _ p2: CChar, _ p3: Int, _ p4: Float, _ p5: UnsafePointer<CChar>, _ p6: UnsafeRawPointer) -> String {
    return XCTLoc.tr("Localizable", "types", String(describing: p1), p2, p3, p4, p5, Int(bitPattern: p6))
  }

  internal enum Apples {
    /// You have %d apples
    internal static func count(_ p1: Int) -> String {
      return XCTLoc.tr("Localizable", "apples.count", p1)
    }
  }

  internal enum Bananas {
    /// Those %d bananas belong to %@.
    internal static func owner(_ p1: Int, _ p2: Any) -> String {
      return XCTLoc.tr("Localizable", "bananas.owner", p1, String(describing: p2))
    }
  }

  internal enum Settings {
    internal enum NavigationBar {
      /// Some Reserved Keyword there
      internal static let `self` = XCTLoc.tr("Localizable", "settings.navigation-bar.self")
      internal enum Title {
        internal enum Deeper {
          internal enum Than {
            internal enum We {
              internal enum Can {
                internal enum Handle {
                  internal enum No {
                    internal enum Really {
                      internal enum This {
                        internal enum Is {
                          /// DeepSettings
                          internal static let deep = XCTLoc.tr("Localizable", "settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep")
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        internal enum Even {
          /// Settings
          internal static let deeper = XCTLoc.tr("Localizable", "settings.navigation-bar.title.even.deeper")
        }
      }
    }
    internal enum UserProfileSection {
      /// Here you can change some user profile settings.
      internal static let footerText = XCTLoc.tr("Localizable", "settings.user__profile_section.footer_text")
      /// User Profile Settings
      internal static let headerTitle = XCTLoc.tr("Localizable", "settings.user__profile_section.HEADER_TITLE")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension XCTLoc {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
