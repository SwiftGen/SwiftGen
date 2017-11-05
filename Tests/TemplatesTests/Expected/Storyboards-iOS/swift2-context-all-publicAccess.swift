// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit
import CustomSegue
import LocationPicker
import SlackTextViewController

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

public protocol StoryboardType {
  static var storyboardName: String { get }
}

public extension StoryboardType {
  static var storyboard: UIStoryboard {
    return UIStoryboard(name: self.storyboardName, bundle: NSBundle(forClass: BundleToken.self))
  }
}

public struct SceneType<T: Any> {
  public let storyboard: StoryboardType.Type
  public let identifier: String

  public var controller: T {
    guard let controller = storyboard.storyboard.instantiateViewControllerWithIdentifier(identifier) as? T else {
      fatalError("Controller '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

public struct InitialSceneType<T: Any> {
  public let storyboard: StoryboardType.Type

  public var controller: T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("Controller is not of the expected class \(T.self).")
    }
    return controller
  }
}

public protocol SegueType: RawRepresentable { }

public extension UIViewController {
  func performSegue<S: SegueType where S.RawValue == String>(segue: S, sender: AnyObject? = nil) {
    performSegueWithIdentifier(segue.rawValue, sender: sender)
  }
}

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
public enum StoryboardScene {
  public enum AdditionalImport: StoryboardType {
    public static let storyboardName = "AdditionalImport"

    public static let initialScene = InitialSceneType<LocationPicker.LocationPickerViewController>(AdditionalImport.self)

    public static let Public = SceneType<SlackTextViewController.SLKTextViewController>(AdditionalImport.self, identifier: "public")
  }
  public enum Anonymous: StoryboardType {
    public static let storyboardName = "Anonymous"

    public static let initialScene = InitialSceneType<UINavigationController>(Anonymous.self)
  }
  public enum Dependency: StoryboardType {
    public static let storyboardName = "Dependency"

    public static let Dependent = SceneType<UIViewController>(Dependency.self, identifier: "Dependent")
  }
  public enum Message: StoryboardType {
    public static let storyboardName = "Message"

    public static let initialScene = InitialSceneType<UIViewController>(Message.self)

    public static let Composer = SceneType<UIViewController>(Message.self, identifier: "Composer")

    public static let MessagesList = SceneType<UITableViewController>(Message.self, identifier: "MessagesList")

    public static let NavCtrl = SceneType<UINavigationController>(Message.self, identifier: "NavCtrl")

    public static let URLChooser = SceneType<XXPickerViewController>(Message.self, identifier: "URLChooser")
  }
  public enum Placeholder: StoryboardType {
    public static let storyboardName = "Placeholder"

    public static let Navigation = SceneType<UINavigationController>(Placeholder.self, identifier: "Navigation")
  }
  public enum Wizard: StoryboardType {
    public static let storyboardName = "Wizard"

    public static let initialScene = InitialSceneType<CreateAccViewController>(Wizard.self)

    public static let AcceptCGU = SceneType<UIViewController>(Wizard.self, identifier: "Accept-CGU")

    public static let CreateAccount = SceneType<CreateAccViewController>(Wizard.self, identifier: "CreateAccount")

    public static let Preferences = SceneType<UITableViewController>(Wizard.self, identifier: "Preferences")

    public static let ValidatePassword = SceneType<UIViewController>(Wizard.self, identifier: "Validate_Password")
  }
}

public enum StoryboardSegue {
  public enum AdditionalImport: String, SegueType {
    case Private = "private"
  }
  public enum Message: String, SegueType {
    case CustomBack
    case Embed
    case NonCustom
    case ShowNavCtrl = "Show-NavCtrl"
  }
  public enum Wizard: String, SegueType {
    case ShowPassword
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

private final class BundleToken {}
