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
public enum StoryboardScene {
  public enum AdditionalImport: StoryboardType {
    public static let storyboardName = "AdditionalImport"

    public static let `private` = SceneType<PrefsWindowController.DBPrefsWindowController>(storyboard: AdditionalImport.self, identifier: "private")
  }
  public enum Anonymous: StoryboardType {
    public static let storyboardName = "Anonymous"
  }
  public enum Dependency: StoryboardType {
    public static let storyboardName = "Dependency"

    public static let dependent = SceneType<ExtraModule.LoginViewController>(storyboard: Dependency.self, identifier: "Dependent")
  }
  public enum KnownTypes: StoryboardType {
    public static let storyboardName = "Known Types"

    public static let item1 = SceneType<AppKit.NSWindowController>(storyboard: KnownTypes.self, identifier: "item 1")

    public static let item2 = SceneType<AppKit.NSSplitViewController>(storyboard: KnownTypes.self, identifier: "item 2")

    public static let item3 = SceneType<AppKit.NSViewController>(storyboard: KnownTypes.self, identifier: "item 3")

    public static let item4 = SceneType<AppKit.NSPageController>(storyboard: KnownTypes.self, identifier: "item 4")

    public static let item5 = SceneType<AppKit.NSTabViewController>(storyboard: KnownTypes.self, identifier: "item 5")
  }
  public enum Message: StoryboardType {
    public static let storyboardName = "Message"

    public static let messageDetails = SceneType<SwiftGen.DetailsViewController>(storyboard: Message.self, identifier: "MessageDetails")

    public static let messageList = SceneType<AppKit.NSViewController>(storyboard: Message.self, identifier: "MessageList")

    public static let messageListFooter = SceneType<AppKit.NSViewController>(storyboard: Message.self, identifier: "MessageListFooter")

    public static let messagesTab = SceneType<SwiftGen.CustomTabViewController>(storyboard: Message.self, identifier: "MessagesTab")

    public static let splitMessages = SceneType<AppKit.NSSplitViewController>(storyboard: Message.self, identifier: "SplitMessages")

    public static let windowCtrl = SceneType<AppKit.NSWindowController>(storyboard: Message.self, identifier: "WindowCtrl")
  }
  public enum Placeholder: StoryboardType {
    public static let storyboardName = "Placeholder"

    public static let window = SceneType<AppKit.NSWindowController>(storyboard: Placeholder.self, identifier: "Window")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

public protocol StoryboardType {
  static var storyboardName: String { get }
}

public extension StoryboardType {
  static var storyboard: NSStoryboard {
    let name = NSStoryboard.Name(self.storyboardName)
    return NSStoryboard(name: name, bundle: BundleToken.bundle)
  }
}

public struct SceneType<T> {
  public let storyboard: StoryboardType.Type
  public let identifier: String

  public func instantiate() -> T {
    let identifier = NSStoryboard.SceneIdentifier(self.identifier)
    guard let controller = storyboard.storyboard.instantiateController(withIdentifier: identifier) as? T else {
      fatalError("Controller '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(macOS 10.15, *)
  public func instantiate(creator block: @escaping (NSCoder) -> T?) -> T where T: NSViewController {
    let identifier = NSStoryboard.SceneIdentifier(self.identifier)
    return storyboard.storyboard.instantiateController(identifier: identifier, creator: block)
  }

  @available(macOS 10.15, *)
  public func instantiate(creator block: @escaping (NSCoder) -> T?) -> T where T: NSWindowController {
    let identifier = NSStoryboard.SceneIdentifier(self.identifier)
    return storyboard.storyboard.instantiateController(identifier: identifier, creator: block)
  }
}

public struct InitialSceneType<T> {
  public let storyboard: StoryboardType.Type

  public func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialController() as? T else {
      fatalError("Controller is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(macOS 10.15, *)
  public func instantiate(creator block: @escaping (NSCoder) -> T?) -> T where T: NSViewController {
    guard let controller = storyboard.storyboard.instantiateInitialController(creator: block) else {
      fatalError("Storyboard \(storyboard.storyboardName) does not have an initial scene.")
    }
    return controller
  }

  @available(macOS 10.15, *)
  public func instantiate(creator block: @escaping (NSCoder) -> T?) -> T where T: NSWindowController {
    guard let controller = storyboard.storyboard.instantiateInitialController(creator: block) else {
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
