// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
internal enum L10n {
  internal enum Localizable {
    /// Some alert body there
    internal static let alertMessage = L10n.tr("Localizable", "alert_message")
    /// Title of the alert
    internal static let alertTitle = L10n.tr("Localizable", "alert_title")
    /// These are %3$@'s %1$d %2$@.
    internal static func objectOwnership(_ p1: Int, _ p2: String, _ p3: String) -> String {
      return L10n.tr("Localizable", "ObjectOwnership", p1, p2, p3)
    }
    /// Hello, my name is %@ and I'm %d
    internal static func `private`(_ p1: String, _ p2: Int) -> String {
      return L10n.tr("Localizable", "private", p1, p2)
    }

    internal enum Apples {
      /// You have %d apples
      internal static func count(_ p1: Int) -> String {
        return L10n.tr("Localizable", "apples.count", p1)
      }
    }

    internal enum Bananas {
      /// Those %d bananas belong to %@.
      internal static func owner(_ p1: Int, _ p2: String) -> String {
        return L10n.tr("Localizable", "bananas.owner", p1, p2)
      }
    }

    internal enum Settings {

      internal enum NavigationBar {
        /// Some Reserved Keyword there
        internal static let `self` = L10n.tr("Localizable", "settings.navigation-bar.self")

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
                            internal static let deep = L10n.tr("Localizable", "settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep")
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
            internal static let deeper = L10n.tr("Localizable", "settings.navigation-bar.title.even.deeper")
          }
        }
      }

      internal enum UserProfileSection {
        /// Here you can change some user profile settings.
        internal static let footerText = L10n.tr("Localizable", "seTTings.uSer-proFile-sectioN.footer_text")
        /// User Profile Settings
        internal static let headerTitle = L10n.tr("Localizable", "SETTINGS.USER_PROFILE_SECTION.HEADER_TITLE")
      }
    }
  }
  internal enum LocMultiline {
    /// multi\nline
    internal static let multiline = L10n.tr("LocMultiline", "MULTILINE")
    /// test
    internal static let multiLineKey = L10n.tr("LocMultiline", "multiLine\nKey")
    /// another\nmulti\n    line
    internal static let multiline2 = L10n.tr("LocMultiline", "MULTILINE2")
    /// single line
    internal static let singleline = L10n.tr("LocMultiline", "SINGLELINE")
    /// another single line
    internal static let singleline2 = L10n.tr("LocMultiline", "SINGLELINE2")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
