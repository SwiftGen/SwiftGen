// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import AVKit
import ExtraModule
import GLKit
import LocationPicker
import SlackTextViewController
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length implicit_return

// MARK: - Storyboard Scenes

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

    public static let dependent = SceneType<ExtraModule.ValidatePasswordViewController>(storyboard: Dependency.self, identifier: "Dependent")
  }
  public enum KnownTypes: StoryboardType {
    public static let storyboardName = "Known Types"

    public static let item1 = SceneType<GLKit.GLKViewController>(storyboard: KnownTypes.self, identifier: "item 1")

    public static let item2 = SceneType<AVKit.AVPlayerViewController>(storyboard: KnownTypes.self, identifier: "item 2")

    public static let item3 = SceneType<UIKit.UITabBarController>(storyboard: KnownTypes.self, identifier: "item 3")

    public static let item4 = SceneType<UIKit.UINavigationController>(storyboard: KnownTypes.self, identifier: "item 4")

    public static let item5 = SceneType<UIKit.UISplitViewController>(storyboard: KnownTypes.self, identifier: "item 5")

    public static let item6 = SceneType<UIKit.UIPageViewController>(storyboard: KnownTypes.self, identifier: "item 6")

    public static let item7 = SceneType<UIKit.UITableViewController>(storyboard: KnownTypes.self, identifier: "item 7")

    public static let item8 = SceneType<UIKit.UICollectionViewController>(storyboard: KnownTypes.self, identifier: "item 8")

    public static let item9 = SceneType<UIKit.UIViewController>(storyboard: KnownTypes.self, identifier: "item 9")
  }
  public enum Message: StoryboardType {
    public static let storyboardName = "Message"

    public static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: Message.self)

    public static let composer = SceneType<UIKit.UIViewController>(storyboard: Message.self, identifier: "Composer")

    public static let messagesList = SceneType<UIKit.UITableViewController>(storyboard: Message.self, identifier: "MessagesList")

    public static let navCtrl = SceneType<UIKit.UINavigationController>(storyboard: Message.self, identifier: "NavCtrl")

    public static let urlChooser = SceneType<SwiftGen.PickerViewController>(storyboard: Message.self, identifier: "URLChooser")
  }
  public enum Placeholder: StoryboardType {
    public static let storyboardName = "Placeholder"

    public static let navigation = SceneType<UIKit.UINavigationController>(storyboard: Placeholder.self, identifier: "Navigation")
  }
  public enum Wizard: StoryboardType {
    public static let storyboardName = "Wizard"

    public static let initialScene = InitialSceneType<SwiftGen.CreateAccViewController>(storyboard: Wizard.self)

    public static let acceptToS = SceneType<UIKit.UIViewController>(storyboard: Wizard.self, identifier: "Accept-ToS")

    public static let createAccount = SceneType<SwiftGen.CreateAccViewController>(storyboard: Wizard.self, identifier: "CreateAccount")

    public static let preferences = SceneType<UIKit.UITableViewController>(storyboard: Wizard.self, identifier: "Preferences")

    public static let validatePassword = SceneType<ExtraModule.ValidatePasswordViewController>(storyboard: Wizard.self, identifier: "Validate_Password")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

public protocol StoryboardType {
  static var storyboardName: String { get }
}

public extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: BundleToken.bundle)
  }
}

public struct SceneType<T: UIViewController> {
  public let storyboard: StoryboardType.Type
  public let identifier: String

  public func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  public func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    return storyboard.storyboard.instantiateViewController(identifier: identifier, creator: block)
  }
}

public struct InitialSceneType<T: UIViewController> {
  public let storyboard: StoryboardType.Type

  public func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  public func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController(creator: block) else {
      fatalError("Storyboard \(storyboard.storyboardName) does not have an initial scene.")
    }
    return controller
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
