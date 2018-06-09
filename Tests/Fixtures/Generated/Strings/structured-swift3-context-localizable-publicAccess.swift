// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable all

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
public enum L10n {
  /// Some alert body there
  public static let alertMessage = L10n.tr("Localizable", "alert_message")
  /// Title of the alert
  public static let alertTitle = L10n.tr("Localizable", "alert_title")
  /// These are %3$@'s %1$d %2$@.
  public static func objectOwnership(_ p1: Int, _ p2: String, _ p3: String) -> String {
    return L10n.tr("Localizable", "ObjectOwnership", p1, p2, p3)
  }
  /// Hello, my name is %@ and I'm %d
  public static func `private`(_ p1: String, _ p2: Int) -> String {
    return L10n.tr("Localizable", "private", p1, p2)
  }

  public enum Apples {
    /// You have %d apples
    public static func count(_ p1: Int) -> String {
      return L10n.tr("Localizable", "apples.count", p1)
    }
  }

  public enum Bananas {
    /// Those %d bananas belong to %@.
    public static func owner(_ p1: Int, _ p2: String) -> String {
      return L10n.tr("Localizable", "bananas.owner", p1, p2)
    }
  }

  public enum Settings {
    public enum NavigationBar {
      /// Some Reserved Keyword there
      public static let `self` = L10n.tr("Localizable", "settings.navigation-bar.self")
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
                          public static let deep = L10n.tr("Localizable", "settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep")
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
          public static let deeper = L10n.tr("Localizable", "settings.navigation-bar.title.even.deeper")
        }
      }
    }
    public enum UserProfileSection {
      /// Here you can change some user profile settings.
      public static let footerText = L10n.tr("Localizable", "settings.user_profile_section.footer_text")
      /// User Profile Settings
      public static let headerTitle = L10n.tr("Localizable", "settings.user_profile_section.HEADER_TITLE")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

extension L10n {
  fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
