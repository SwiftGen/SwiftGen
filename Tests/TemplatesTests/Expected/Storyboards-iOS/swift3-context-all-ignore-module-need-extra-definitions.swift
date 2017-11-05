// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit
import CustomSegue
import LocationPicker

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    return UIStoryboard(name: self.storyboardName, bundle: Bundle(for: BundleToken.self))
  }
}

internal struct SceneType<T: Any> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: Any> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal protocol SegueType: RawRepresentable { }

internal extension UIViewController {
  func perform<S: SegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    performSegue(withIdentifier: segue.rawValue, sender: sender)
  }
}

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum AdditionalImport: StoryboardType {
    internal static let storyboardName = "AdditionalImport"

    internal static let initialScene = InitialSceneType<LocationPicker.LocationPickerViewController>(storyboard: AdditionalImport.self)

    internal static let `public` = SceneType<SLKTextViewController>(storyboard: AdditionalImport.self, identifier: "public")
  }
  internal enum Anonymous: StoryboardType {
    internal static let storyboardName = "Anonymous"

    internal static let initialScene = InitialSceneType<UINavigationController>(storyboard: Anonymous.self)
  }
  internal enum Dependency: StoryboardType {
    internal static let storyboardName = "Dependency"

    internal static let dependent = SceneType<UIViewController>(storyboard: Dependency.self, identifier: "Dependent")
  }
  internal enum Message: StoryboardType {
    internal static let storyboardName = "Message"

    internal static let initialScene = InitialSceneType<UIViewController>(storyboard: Message.self)

    internal static let composer = SceneType<UIViewController>(storyboard: Message.self, identifier: "Composer")

    internal static let messagesList = SceneType<UITableViewController>(storyboard: Message.self, identifier: "MessagesList")

    internal static let navCtrl = SceneType<UINavigationController>(storyboard: Message.self, identifier: "NavCtrl")

    internal static let urlChooser = SceneType<XXPickerViewController>(storyboard: Message.self, identifier: "URLChooser")
  }
  internal enum Placeholder: StoryboardType {
    internal static let storyboardName = "Placeholder"

    internal static let navigation = SceneType<UINavigationController>(storyboard: Placeholder.self, identifier: "Navigation")
  }
  internal enum Wizard: StoryboardType {
    internal static let storyboardName = "Wizard"

    internal static let initialScene = InitialSceneType<CreateAccViewController>(storyboard: Wizard.self)

    internal static let acceptCGU = SceneType<UIViewController>(storyboard: Wizard.self, identifier: "Accept-CGU")

    internal static let createAccount = SceneType<CreateAccViewController>(storyboard: Wizard.self, identifier: "CreateAccount")

    internal static let preferences = SceneType<UITableViewController>(storyboard: Wizard.self, identifier: "Preferences")

    internal static let validatePassword = SceneType<UIViewController>(storyboard: Wizard.self, identifier: "Validate_Password")
  }
}

internal enum StoryboardSegue {
  internal enum AdditionalImport: String, SegueType {
    case `private`
  }
  internal enum Message: String, SegueType {
    case customBack = "CustomBack"
    case embed = "Embed"
    case nonCustom = "NonCustom"
    case showNavCtrl = "Show-NavCtrl"
  }
  internal enum Wizard: String, SegueType {
    case showPassword = "ShowPassword"
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

private final class BundleToken {}
