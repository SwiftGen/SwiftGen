// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import AppKit
import ExtraModule
import PrefsWindowController

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Segues

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardSegue {
  internal enum Message: String, SegueType {
    case embed = "Embed"
    case fade = "Fade"
    case login = "Login"
    case modal = "Modal"
    case popover = "Popover"
    case sheet = "Sheet"
    case show = "Show"
    case `private`
    case `public`
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol SegueType: RawRepresentable {}

internal extension NSSeguePerforming {
  func perform<S: SegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    let identifier = NSStoryboardSegue.Identifier(segue.rawValue)
    performSegue?(withIdentifier: identifier, sender: sender)
  }
}

internal extension SegueType where RawValue == String {
  init?(_ segue: NSStoryboardSegue) {
    #if swift(>=4.2)
    guard let identifier = segue.identifier else { return nil }
    #else
    guard let identifier = segue.identifier?.rawValue else { return nil }
    #endif
    self.init(rawValue: identifier)
  }
}
