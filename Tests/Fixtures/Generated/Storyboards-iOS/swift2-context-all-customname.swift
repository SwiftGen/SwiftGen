// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit
import CustomSegue
import LocationPicker
import SlackTextViewController

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    return UIStoryboard(name: self.storyboardName, bundle: NSBundle(forClass: BundleToken.self))
  }
}

internal struct SceneType<T: Any> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal var controller: T {
    guard let controller = storyboard.storyboard.instantiateViewControllerWithIdentifier(identifier) as? T else {
      fatalError("Controller '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: Any> {
  internal let storyboard: StoryboardType.Type

  internal var controller: T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("Controller is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal protocol SegueType: RawRepresentable { }

internal extension UIViewController {
  func performSegue<S: SegueType where S.RawValue == String>(segue: S, sender: AnyObject? = nil) {
    performSegueWithIdentifier(segue.rawValue, sender: sender)
  }
}

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum XCTStoryboardsScene {
  internal enum AdditionalImport: StoryboardType {
    internal static let storyboardName = "AdditionalImport"

    internal static let initialScene = InitialSceneType<LocationPicker.LocationPickerViewController>(AdditionalImport.self)

    internal static let Public = SceneType<SlackTextViewController.SLKTextViewController>(AdditionalImport.self, identifier: "public")
  }
  internal enum Anonymous: StoryboardType {
    internal static let storyboardName = "Anonymous"

    internal static let initialScene = InitialSceneType<UINavigationController>(Anonymous.self)
  }
  internal enum Dependency: StoryboardType {
    internal static let storyboardName = "Dependency"

    internal static let Dependent = SceneType<UIViewController>(Dependency.self, identifier: "Dependent")
  }
  internal enum Message: StoryboardType {
    internal static let storyboardName = "Message"

    internal static let initialScene = InitialSceneType<UIViewController>(Message.self)

    internal static let Composer = SceneType<UIViewController>(Message.self, identifier: "Composer")

    internal static let MessagesList = SceneType<UITableViewController>(Message.self, identifier: "MessagesList")

    internal static let NavCtrl = SceneType<UINavigationController>(Message.self, identifier: "NavCtrl")

    internal static let URLChooser = SceneType<XXPickerViewController>(Message.self, identifier: "URLChooser")
  }
  internal enum Placeholder: StoryboardType {
    internal static let storyboardName = "Placeholder"

    internal static let Navigation = SceneType<UINavigationController>(Placeholder.self, identifier: "Navigation")
  }
  internal enum Wizard: StoryboardType {
    internal static let storyboardName = "Wizard"

    internal static let initialScene = InitialSceneType<CreateAccViewController>(Wizard.self)

    internal static let AcceptCGU = SceneType<UIViewController>(Wizard.self, identifier: "Accept-CGU")

    internal static let CreateAccount = SceneType<CreateAccViewController>(Wizard.self, identifier: "CreateAccount")

    internal static let Preferences = SceneType<UITableViewController>(Wizard.self, identifier: "Preferences")

    internal static let ValidatePassword = SceneType<UIViewController>(Wizard.self, identifier: "Validate_Password")
  }
}

internal enum XCTStoryboardsSegue {
  internal enum AdditionalImport: String, SegueType {
    case Private = "private"
  }
  internal enum Message: String, SegueType {
    case CustomBack
    case Embed
    case NonCustom
    case ShowNavCtrl = "Show-NavCtrl"
  }
  internal enum Wizard: String, SegueType {
    case ShowPassword
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

private final class BundleToken {}
