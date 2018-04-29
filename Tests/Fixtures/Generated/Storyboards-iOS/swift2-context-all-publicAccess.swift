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

    public static let initialScene = InitialSceneType<UIKit.UINavigationController>(Anonymous.self)
  }
  public enum Dependency: StoryboardType {
    public static let storyboardName = "Dependency"

    public static let Dependent = SceneType<UIKit.UIViewController>(Dependency.self, identifier: "Dependent")
  }
  public enum KnownTypes: StoryboardType {
    public static let storyboardName = "Known Types"

    public static let Item1 = SceneType<GLKit.GLKViewController>(KnownTypes.self, identifier: "item 1")

    public static let Item2 = SceneType<AVKit.AVPlayerViewController>(KnownTypes.self, identifier: "item 2")

    public static let Item3 = SceneType<UIKit.UITabBarController>(KnownTypes.self, identifier: "item 3")

    public static let Item4 = SceneType<UIKit.UINavigationController>(KnownTypes.self, identifier: "item 4")

    public static let Item5 = SceneType<UIKit.UISplitViewController>(KnownTypes.self, identifier: "item 5")

    public static let Item6 = SceneType<UIKit.UIPageViewController>(KnownTypes.self, identifier: "item 6")

    public static let Item7 = SceneType<UIKit.UITableViewController>(KnownTypes.self, identifier: "item 7")

    public static let Item8 = SceneType<UIKit.UICollectionViewController>(KnownTypes.self, identifier: "item 8")

    public static let Item9 = SceneType<UIKit.UIViewController>(KnownTypes.self, identifier: "item 9")
  }
  public enum Message: StoryboardType {
    public static let storyboardName = "Message"

    public static let initialScene = InitialSceneType<UIKit.UIViewController>(Message.self)

    public static let Composer = SceneType<UIKit.UIViewController>(Message.self, identifier: "Composer")

    public static let MessagesList = SceneType<UIKit.UITableViewController>(Message.self, identifier: "MessagesList")

    public static let NavCtrl = SceneType<UIKit.UINavigationController>(Message.self, identifier: "NavCtrl")

    public static let URLChooser = SceneType<XXPickerViewController>(Message.self, identifier: "URLChooser")
  }
  public enum Placeholder: StoryboardType {
    public static let storyboardName = "Placeholder"

    public static let Navigation = SceneType<UIKit.UINavigationController>(Placeholder.self, identifier: "Navigation")
  }
  public enum Wizard: StoryboardType {
    public static let storyboardName = "Wizard"

    public static let initialScene = InitialSceneType<CreateAccViewController>(Wizard.self)

    public static let AcceptToS = SceneType<UIKit.UIViewController>(Wizard.self, identifier: "Accept-ToS")

    public static let CreateAccount = SceneType<CreateAccViewController>(Wizard.self, identifier: "CreateAccount")

    public static let Preferences = SceneType<UIKit.UITableViewController>(Wizard.self, identifier: "Preferences")

    public static let ValidatePassword = SceneType<UIKit.UIViewController>(Wizard.self, identifier: "Validate_Password")
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
