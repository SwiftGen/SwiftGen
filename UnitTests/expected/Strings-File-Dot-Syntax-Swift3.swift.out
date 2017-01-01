// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
// swiftlint:disable nesting
// swiftlint:disable variable_name
// swiftlint:disable valid_docs

enum L10n {
  /// Some alert body there
  static let alertMessage = L10n.tr("alert_message")
  /// Title of the alert
  static let alertTitle = L10n.tr("alert_title")
  /// Hello, my name is %@ and I'm %d
  static func greetings(_ p1: String, _ p2: Int) -> String {
    return L10n.tr("greetings", p1, p2)
  }
  /// These are %3$@'s %1$d %2$@.
  static func objectOwnership(_ p1: Int, _ p2: String, _ p3: String) -> String {
    return L10n.tr("ObjectOwnership", p1, p2, p3)
  }

  enum Apples {
    /// You have %d apples
    static func count(_ p1: Int) -> String {
      return L10n.tr("apples.count", p1)
    }
  }

  enum Bananas {
    /// Those %d bananas belong to %@.
    static func owner(_ p1: Int, _ p2: String) -> String {
      return L10n.tr("bananas.owner", p1, p2)
    }
  }

  enum Settings {

    enum NavigationBar {
      /// Some Reserved Keyword there
      static let `self` = L10n.tr("settings.navigation-bar.self")

      enum Title {

        enum Even {
          /// Settings
          static let deeper = L10n.tr("settings.navigation-bar.title.even.deeper")

          enum Deeper {

            enum Than {

              enum We {

                enum Can {
                  /// DeepSettings
                  static let handle = L10n.tr("settings.navigation-bar.title.even.deeper.than.we.can.handle")
                }
              }
            }
          }
        }
      }
    }

    enum UserProfileSection {
      /// Here you can change some user profile settings.
      static let footerText = L10n.tr("seTTings.uSer-proFile-sectioN.footer_text")
      /// User Profile Settings
      static let headerTitle = L10n.tr("SETTINGS.USER_PROFILE_SECTION.HEADER_TITLE")
    }
  }
}

extension L10n {
  fileprivate static func tr(_ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:enable type_body_length
// swiftlint:enable nesting
// swiftlint:enable variable_name
// swiftlint:enable valid_docs
