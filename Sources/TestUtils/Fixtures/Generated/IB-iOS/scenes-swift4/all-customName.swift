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
enum XCTStoryboardCustom {
  enum AdditionalImport: StoryboardType {
    static let storyboardName = "AdditionalImport"

    static let initialScene = InitialSceneType<LocationPicker.LocationPickerViewController>(storyboard: AdditionalImport.self)

    static let `public` = SceneType<SlackTextViewController.SLKTextViewController>(storyboard: AdditionalImport.self, identifier: "public")
  }
  enum Anonymous: StoryboardType {
    static let storyboardName = "Anonymous"

    static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Anonymous.self)
  }
  enum Dependency: StoryboardType {
    static let storyboardName = "Dependency"

    static let dependent = SceneType<ExtraModule.ValidatePasswordViewController>(storyboard: Dependency.self, identifier: "Dependent")
  }
  enum KnownTypes: StoryboardType {
    static let storyboardName = "Known Types"

    static let item1 = SceneType<GLKit.GLKViewController>(storyboard: KnownTypes.self, identifier: "item 1")

    static let item2 = SceneType<AVKit.AVPlayerViewController>(storyboard: KnownTypes.self, identifier: "item 2")

    static let item3 = SceneType<UIKit.UITabBarController>(storyboard: KnownTypes.self, identifier: "item 3")

    static let item4 = SceneType<UIKit.UINavigationController>(storyboard: KnownTypes.self, identifier: "item 4")

    static let item5 = SceneType<UIKit.UISplitViewController>(storyboard: KnownTypes.self, identifier: "item 5")

    static let item6 = SceneType<UIKit.UIPageViewController>(storyboard: KnownTypes.self, identifier: "item 6")

    static let item7 = SceneType<UIKit.UITableViewController>(storyboard: KnownTypes.self, identifier: "item 7")

    static let item8 = SceneType<UIKit.UICollectionViewController>(storyboard: KnownTypes.self, identifier: "item 8")

    static let item9 = SceneType<UIKit.UIViewController>(storyboard: KnownTypes.self, identifier: "item 9")
  }
  enum Message: StoryboardType {
    static let storyboardName = "Message"

    static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: Message.self)

    static let composer = SceneType<UIKit.UIViewController>(storyboard: Message.self, identifier: "Composer")

    static let messagesList = SceneType<UIKit.UITableViewController>(storyboard: Message.self, identifier: "MessagesList")

    static let navCtrl = SceneType<UIKit.UINavigationController>(storyboard: Message.self, identifier: "NavCtrl")

    static let urlChooser = SceneType<SwiftGen.PickerViewController>(storyboard: Message.self, identifier: "URLChooser")
  }
  enum Placeholder: StoryboardType {
    static let storyboardName = "Placeholder"

    static let navigation = SceneType<UIKit.UINavigationController>(storyboard: Placeholder.self, identifier: "Navigation")
  }
  enum Wizard: StoryboardType {
    static let storyboardName = "Wizard"

    static let initialScene = InitialSceneType<SwiftGen.CreateAccViewController>(storyboard: Wizard.self)

    static let acceptToS = SceneType<UIKit.UIViewController>(storyboard: Wizard.self, identifier: "Accept-ToS")

    static let createAccount = SceneType<SwiftGen.CreateAccViewController>(storyboard: Wizard.self, identifier: "CreateAccount")

    static let preferences = SceneType<UIKit.UITableViewController>(storyboard: Wizard.self, identifier: "Preferences")

    static let validatePassword = SceneType<ExtraModule.ValidatePasswordViewController>(storyboard: Wizard.self, identifier: "Validate_Password")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

protocol StoryboardType {
  static var storyboardName: String { get }
}

extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: BundleToken.bundle)
  }
}

struct SceneType<T: UIViewController> {
  let storyboard: StoryboardType.Type
  let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    return storyboard.storyboard.instantiateViewController(identifier: identifier, creator: block)
  }
}

struct InitialSceneType<T: UIViewController> {
  let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
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
