// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import Cocoa
import FadeSegue

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: NSStoryboard {
    let name = NSStoryboard.Name(self.storyboardName)
    return NSStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

internal struct SceneType<T: Any> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = NSStoryboard.SceneIdentifier(self.identifier)
    guard let controller = storyboard.storyboard.instantiateController(withIdentifier: identifier) as? T else {
      fatalError("Controller '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: Any> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialController() as? T else {
      fatalError("Controller is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal protocol SegueType: RawRepresentable { }

internal extension NSSeguePerforming {
  func perform<S: SegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    let identifier = NSStoryboardSegue.Identifier(segue.rawValue)
    performSegue?(withIdentifier: identifier, sender: sender)
  }
}

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum AdditionalImport: StoryboardType {
    internal static let storyboardName = "AdditionalImport"

    internal static let `private` = SceneType<DBPrefsWindowController>(storyboard: AdditionalImport.self, identifier: "private")
  }
  internal enum Anonymous: StoryboardType {
    internal static let storyboardName = "Anonymous"
  }
  internal enum Dependency: StoryboardType {
    internal static let storyboardName = "Dependency"

    internal static let dependent = SceneType<NSViewController>(storyboard: Dependency.self, identifier: "Dependent")
  }
  internal enum Message: StoryboardType {
    internal static let storyboardName = "Message"

    internal static let messageDetails = SceneType<NSViewController>(storyboard: Message.self, identifier: "MessageDetails")

    internal static let messageList = SceneType<NSViewController>(storyboard: Message.self, identifier: "MessageList")

    internal static let messageListFooter = SceneType<NSViewController>(storyboard: Message.self, identifier: "MessageListFooter")

    internal static let messagesTab = SceneType<CustomTabViewController>(storyboard: Message.self, identifier: "MessagesTab")

    internal static let splitMessages = SceneType<NSSplitViewController>(storyboard: Message.self, identifier: "SplitMessages")

    internal static let windowCtrl = SceneType<NSWindowController>(storyboard: Message.self, identifier: "WindowCtrl")
  }
  internal enum Placeholder: StoryboardType {
    internal static let storyboardName = "Placeholder"

    internal static let dependent = SceneType<NSControllerPlaceholder>(storyboard: Placeholder.self, identifier: "Dependent")

    internal static let window = SceneType<NSWindowController>(storyboard: Placeholder.self, identifier: "Window")
  }
}

internal enum StoryboardSegue {
  internal enum Message: String, SegueType {
    case embed = "Embed"
    case modal = "Modal"
    case popover = "Popover"
    case sheet = "Sheet"
    case show = "Show"
    case `public`
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

private final class BundleToken {}
