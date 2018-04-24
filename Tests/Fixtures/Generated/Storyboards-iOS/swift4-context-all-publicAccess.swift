// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import AVKit
import CustomSegue
import GLKit
import LocationPicker
import SlackTextViewController
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

public protocol StoryboardType {
  static var storyboardName: String { get }
}

public extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

public struct SceneType<T: Any> {
  public let storyboard: StoryboardType.Type
  public let identifier: String

  public func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

public struct InitialSceneType<T: Any> {
  public let storyboard: StoryboardType.Type

  public func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

public protocol SegueType: RawRepresentable { }

public extension UIViewController {
  func perform<S: SegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    let identifier = segue.rawValue
    performSegue(withIdentifier: identifier, sender: sender)
  }
}

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
public enum StoryboardScene {
  public enum AdditionalImport: StoryboardType {
    public static let storyboardName = "AdditionalImport"

    public static let initialScene = InitialSceneType<LocationPicker.LocationPickerViewController>(storyboard: AdditionalImport.self)

    public static let `public` = SceneType<SlackTextViewController.SLKTextViewController>(storyboard: AdditionalImport.self, identifier: "public")
  }
  public enum Anonymous: StoryboardType {
    public static let storyboardName = "Anonymous"

    public static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Anonymous.self)
  }
  public enum Dependency: StoryboardType {
    public static let storyboardName = "Dependency"

    public static let dependent = SceneType<UIKit.UIViewController>(storyboard: Dependency.self, identifier: "Dependent")
  }
  public enum Message: StoryboardType {
    public static let storyboardName = "Message"

    public static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: Message.self)

    public static let composer = SceneType<UIKit.UIViewController>(storyboard: Message.self, identifier: "Composer")

    public static let messagesList = SceneType<UIKit.UITableViewController>(storyboard: Message.self, identifier: "MessagesList")

    public static let navCtrl = SceneType<UIKit.UINavigationController>(storyboard: Message.self, identifier: "NavCtrl")

    public static let urlChooser = SceneType<XXPickerViewController>(storyboard: Message.self, identifier: "URLChooser")
  }
  public enum NoPrefix: StoryboardType {
    public static let storyboardName = "NoPrefix"

    public static let item1 = SceneType<GLKit.GLKViewController>(storyboard: NoPrefix.self, identifier: "item 1")

    public static let item2 = SceneType<AVKit.AVPlayerViewController>(storyboard: NoPrefix.self, identifier: "item 2")
  }
  public enum Placeholder: StoryboardType {
    public static let storyboardName = "Placeholder"

    public static let navigation = SceneType<UIKit.UINavigationController>(storyboard: Placeholder.self, identifier: "Navigation")
  }
  public enum Wizard: StoryboardType {
    public static let storyboardName = "Wizard"

    public static let initialScene = InitialSceneType<CreateAccViewController>(storyboard: Wizard.self)

    public static let acceptCGU = SceneType<UIKit.UIViewController>(storyboard: Wizard.self, identifier: "Accept-CGU")

    public static let createAccount = SceneType<CreateAccViewController>(storyboard: Wizard.self, identifier: "CreateAccount")

    public static let preferences = SceneType<UIKit.UITableViewController>(storyboard: Wizard.self, identifier: "Preferences")

    public static let validatePassword = SceneType<UIKit.UIViewController>(storyboard: Wizard.self, identifier: "Validate_Password")
  }
}

public enum StoryboardSegue {
  public enum AdditionalImport: String, SegueType {
    case `private`
  }
  public enum Message: String, SegueType {
    case customBack = "CustomBack"
    case embed = "Embed"
    case nonCustom = "NonCustom"
    case showNavCtrl = "Show-NavCtrl"
  }
  public enum Wizard: String, SegueType {
    case showPassword = "ShowPassword"
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

private final class BundleToken {}
