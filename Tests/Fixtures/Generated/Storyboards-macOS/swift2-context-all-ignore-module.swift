// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import Cocoa
import PrefsWindowController

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: NSStoryboard {
    return NSStoryboard(name: self.storyboardName, bundle: NSBundle(forClass: BundleToken.self))
  }
}

internal struct SceneType<T: Any> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal var controller: T {
    guard let controller = storyboard.storyboard.instantiateControllerWithIdentifier(identifier) as? T else {
      fatalError("Controller '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: Any> {
  internal let storyboard: StoryboardType.Type

  internal var controller: T {
    guard let controller = storyboard.storyboard.instantiateInitialController() as? T else {
      fatalError("Controller is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal protocol SegueType: RawRepresentable { }

internal extension NSSeguePerforming {
  func performSegue<S: SegueType where S.RawValue == String>(segue: S, sender: AnyObject? = nil) {
    performSegueWithIdentifier?(segue.rawValue, sender: sender)
  }
}

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum AdditionalImport: StoryboardType {
    internal static let storyboardName = "AdditionalImport"

    internal static let Private = SceneType<PrefsWindowController.DBPrefsWindowController>(AdditionalImport.self, identifier: "private")
  }
  internal enum Anonymous: StoryboardType {
    internal static let storyboardName = "Anonymous"
  }
  internal enum Dependency: StoryboardType {
    internal static let storyboardName = "Dependency"

    internal static let Dependent = SceneType<NSViewController>(Dependency.self, identifier: "Dependent")
  }
  internal enum Message: StoryboardType {
    internal static let storyboardName = "Message"

    internal static let MessageDetails = SceneType<NSViewController>(Message.self, identifier: "MessageDetails")

    internal static let MessageList = SceneType<NSViewController>(Message.self, identifier: "MessageList")

    internal static let MessageListFooter = SceneType<NSViewController>(Message.self, identifier: "MessageListFooter")

    internal static let MessagesTab = SceneType<CustomTabViewController>(Message.self, identifier: "MessagesTab")

    internal static let SplitMessages = SceneType<NSSplitViewController>(Message.self, identifier: "SplitMessages")

    internal static let WindowCtrl = SceneType<NSWindowController>(Message.self, identifier: "WindowCtrl")
  }
  internal enum Placeholder: StoryboardType {
    internal static let storyboardName = "Placeholder"

    internal static let Dependent = SceneType<NSControllerPlaceholder>(Placeholder.self, identifier: "Dependent")

    internal static let Window = SceneType<NSWindowController>(Placeholder.self, identifier: "Window")
  }
}

internal enum StoryboardSegue {
  internal enum Message: String, SegueType {
    case Embed
    case Modal
    case Popover
    case Sheet
    case Show
    case Public = "public"
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

private final class BundleToken {}
