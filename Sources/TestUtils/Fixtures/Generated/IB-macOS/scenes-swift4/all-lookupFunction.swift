// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import AppKit
import ExtraModule
import PrefsWindowController

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length implicit_return

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
enum StoryboardScene {
  enum AdditionalImport: StoryboardType {
    static let storyboardName = "AdditionalImport"

    static let `private` = SceneType<PrefsWindowController.DBPrefsWindowController>(storyboard: AdditionalImport.self, identifier: "private")
  }
  enum Anonymous: StoryboardType {
    static let storyboardName = "Anonymous"
  }
  enum Dependency: StoryboardType {
    static let storyboardName = "Dependency"

    static let dependent = SceneType<ExtraModule.LoginViewController>(storyboard: Dependency.self, identifier: "Dependent")
  }
  enum KnownTypes: StoryboardType {
    static let storyboardName = "Known Types"

    static let item1 = SceneType<AppKit.NSWindowController>(storyboard: KnownTypes.self, identifier: "item 1")

    static let item2 = SceneType<AppKit.NSSplitViewController>(storyboard: KnownTypes.self, identifier: "item 2")

    static let item3 = SceneType<AppKit.NSViewController>(storyboard: KnownTypes.self, identifier: "item 3")

    static let item4 = SceneType<AppKit.NSPageController>(storyboard: KnownTypes.self, identifier: "item 4")

    static let item5 = SceneType<AppKit.NSTabViewController>(storyboard: KnownTypes.self, identifier: "item 5")
  }
  enum Message: StoryboardType {
    static let storyboardName = "Message"

    static let messageDetails = SceneType<SwiftGen.DetailsViewController>(storyboard: Message.self, identifier: "MessageDetails")

    static let messageList = SceneType<AppKit.NSViewController>(storyboard: Message.self, identifier: "MessageList")

    static let messageListFooter = SceneType<AppKit.NSViewController>(storyboard: Message.self, identifier: "MessageListFooter")

    static let messagesTab = SceneType<SwiftGen.CustomTabViewController>(storyboard: Message.self, identifier: "MessagesTab")

    static let splitMessages = SceneType<AppKit.NSSplitViewController>(storyboard: Message.self, identifier: "SplitMessages")

    static let windowCtrl = SceneType<AppKit.NSWindowController>(storyboard: Message.self, identifier: "WindowCtrl")
  }
  enum Placeholder: StoryboardType {
    static let storyboardName = "Placeholder"

    static let window = SceneType<AppKit.NSWindowController>(storyboard: Placeholder.self, identifier: "Window")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

protocol StoryboardType {
  static var storyboardName: String { get }
}

extension StoryboardType {
  static var storyboard: NSStoryboard {
    let name = NSStoryboard.Name(self.storyboardName)
    return myStoryboardFinder(name:)(name)
  }
}

internal struct SceneType<T> {
  let storyboard: StoryboardType.Type
  let identifier: String

  internal func instantiate() -> T {
    let identifier = NSStoryboard.SceneIdentifier(self.identifier)
    guard let controller = storyboard.storyboard.instantiateController(withIdentifier: identifier) as? T else {
      fatalError("Controller '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(macOS 10.15, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T where T: NSViewController {
    return storyboard.storyboard.instantiateController(identifier: identifier, creator: block)
  }

  @available(macOS 10.15, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T where T: NSWindowController {
    return storyboard.storyboard.instantiateController(identifier: identifier, creator: block)
  }
}

internal struct InitialSceneType<T> {
  let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialController() as? T else {
      fatalError("Controller is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(macOS 10.15, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T where T: NSViewController {
    guard let controller = storyboard.storyboard.instantiateInitialController(creator: block) else {
      fatalError("Storyboard \(storyboard.storyboardName) does not have an initial scene.")
    }
    return controller
  }

  @available(macOS 10.15, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T where T: NSWindowController {
    guard let controller = storyboard.storyboard.instantiateInitialController(creator: block) else {
      fatalError("Storyboard \(storyboard.storyboardName) does not have an initial scene.")
    }
    return controller
  }
}
