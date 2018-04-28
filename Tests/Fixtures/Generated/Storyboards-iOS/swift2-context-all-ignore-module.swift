// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import AVKit
import GLKit
import LocationPicker
import SlackTextViewController
import UIKit

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
internal enum StoryboardScene {
  internal enum AdditionalImport: StoryboardType {
    internal static let storyboardName = "AdditionalImport"

    internal static let initialScene = InitialSceneType<LocationPicker.LocationPickerViewController>(AdditionalImport.self)

    internal static let Public = SceneType<SlackTextViewController.SLKTextViewController>(AdditionalImport.self, identifier: "public")
  }
  internal enum Anonymous: StoryboardType {
    internal static let storyboardName = "Anonymous"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(Anonymous.self)
  }
  internal enum Dependency: StoryboardType {
    internal static let storyboardName = "Dependency"

    internal static let Dependent = SceneType<UIKit.UIViewController>(Dependency.self, identifier: "Dependent")
  }
  internal enum KnownTypes: StoryboardType {
    internal static let storyboardName = "Known Types"

    internal static let Item1 = SceneType<GLKit.GLKViewController>(KnownTypes.self, identifier: "item 1")

    internal static let Item2 = SceneType<AVKit.AVPlayerViewController>(KnownTypes.self, identifier: "item 2")

    internal static let Item3 = SceneType<UIKit.UITabBarController>(KnownTypes.self, identifier: "item 3")

    internal static let Item4 = SceneType<UIKit.UINavigationController>(KnownTypes.self, identifier: "item 4")

    internal static let Item5 = SceneType<UIKit.UISplitViewController>(KnownTypes.self, identifier: "item 5")

    internal static let Item6 = SceneType<UIKit.UIPageViewController>(KnownTypes.self, identifier: "item 6")

    internal static let Item7 = SceneType<UIKit.UITableViewController>(KnownTypes.self, identifier: "item 7")

    internal static let Item8 = SceneType<UIKit.UICollectionViewController>(KnownTypes.self, identifier: "item 8")

    internal static let Item9 = SceneType<UIKit.UIViewController>(KnownTypes.self, identifier: "item 9")
  }
  internal enum Message: StoryboardType {
    internal static let storyboardName = "Message"

    internal static let initialScene = InitialSceneType<UIKit.UIViewController>(Message.self)

    internal static let Composer = SceneType<UIKit.UIViewController>(Message.self, identifier: "Composer")

    internal static let MessagesList = SceneType<UIKit.UITableViewController>(Message.self, identifier: "MessagesList")

    internal static let NavCtrl = SceneType<UIKit.UINavigationController>(Message.self, identifier: "NavCtrl")

    internal static let URLChooser = SceneType<XXPickerViewController>(Message.self, identifier: "URLChooser")
  }
  internal enum Placeholder: StoryboardType {
    internal static let storyboardName = "Placeholder"

    internal static let Navigation = SceneType<UIKit.UINavigationController>(Placeholder.self, identifier: "Navigation")
  }
  internal enum Wizard: StoryboardType {
    internal static let storyboardName = "Wizard"

    internal static let initialScene = InitialSceneType<CreateAccViewController>(Wizard.self)

    internal static let AcceptToS = SceneType<UIKit.UIViewController>(Wizard.self, identifier: "Accept-ToS")

    internal static let CreateAccount = SceneType<CreateAccViewController>(Wizard.self, identifier: "CreateAccount")

    internal static let Preferences = SceneType<UIKit.UITableViewController>(Wizard.self, identifier: "Preferences")

    internal static let ValidatePassword = SceneType<UIKit.UIViewController>(Wizard.self, identifier: "Validate_Password")
  }
}

internal enum StoryboardSegue {
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
