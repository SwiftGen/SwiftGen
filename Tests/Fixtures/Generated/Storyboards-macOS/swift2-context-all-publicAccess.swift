// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import AppKit
import FadeSegue
import PrefsWindowController

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

public protocol StoryboardType {
  static var storyboardName: String { get }
}

public extension StoryboardType {
  static var storyboard: NSStoryboard {
    return NSStoryboard(name: self.storyboardName, bundle: NSBundle(forClass: BundleToken.self))
  }
}

public struct SceneType<T: Any> {
  public let storyboard: StoryboardType.Type
  public let identifier: String

  public var controller: T {
    guard let controller = storyboard.storyboard.instantiateControllerWithIdentifier(identifier) as? T else {
      fatalError("Controller '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

public struct InitialSceneType<T: Any> {
  public let storyboard: StoryboardType.Type

  public var controller: T {
    guard let controller = storyboard.storyboard.instantiateInitialController() as? T else {
      fatalError("Controller is not of the expected class \(T.self).")
    }
    return controller
  }
}

public protocol SegueType: RawRepresentable { }

public extension NSSeguePerforming {
  func performSegue<S: SegueType where S.RawValue == String>(segue: S, sender: AnyObject? = nil) {
    performSegueWithIdentifier?(segue.rawValue, sender: sender)
  }
}

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
public enum StoryboardScene {
  public enum AdditionalImport: StoryboardType {
    public static let storyboardName = "AdditionalImport"

    public static let Private = SceneType<PrefsWindowController.DBPrefsWindowController>(AdditionalImport.self, identifier: "private")
  }
  public enum Anonymous: StoryboardType {
    public static let storyboardName = "Anonymous"
  }
  public enum Dependency: StoryboardType {
    public static let storyboardName = "Dependency"

    public static let Dependent = SceneType<AppKit.NSViewController>(Dependency.self, identifier: "Dependent")
  }
  public enum KnownTypes: StoryboardType {
    public static let storyboardName = "Known Types"

    public static let Item1 = SceneType<AppKit.NSWindowController>(KnownTypes.self, identifier: "item 1")

    public static let Item2 = SceneType<AppKit.NSSplitViewController>(KnownTypes.self, identifier: "item 2")

    public static let Item3 = SceneType<AppKit.NSViewController>(KnownTypes.self, identifier: "item 3")

    public static let Item4 = SceneType<AppKit.NSPagecontroller>(KnownTypes.self, identifier: "item 4")

    public static let Item5 = SceneType<AppKit.NSTabViewController>(KnownTypes.self, identifier: "item 5")
  }
  public enum Message: StoryboardType {
    public static let storyboardName = "Message"

    public static let MessageDetails = SceneType<AppKit.NSViewController>(Message.self, identifier: "MessageDetails")

    public static let MessageList = SceneType<AppKit.NSViewController>(Message.self, identifier: "MessageList")

    public static let MessageListFooter = SceneType<AppKit.NSViewController>(Message.self, identifier: "MessageListFooter")

    public static let MessagesTab = SceneType<CustomTabViewController>(Message.self, identifier: "MessagesTab")

    public static let SplitMessages = SceneType<AppKit.NSSplitViewController>(Message.self, identifier: "SplitMessages")

    public static let WindowCtrl = SceneType<AppKit.NSWindowController>(Message.self, identifier: "WindowCtrl")
  }
  public enum Placeholder: StoryboardType {
    public static let storyboardName = "Placeholder"

    public static let Window = SceneType<AppKit.NSWindowController>(Placeholder.self, identifier: "Window")
  }
}

public enum StoryboardSegue {
  public enum Message: String, SegueType {
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
