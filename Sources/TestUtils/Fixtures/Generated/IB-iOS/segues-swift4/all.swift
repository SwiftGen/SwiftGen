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
// swiftlint:disable file_length

// MARK: - Storyboard Segues

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal extension SwiftGen.PickerViewController {
  internal enum StoryboardSegue: String {
    case customBack = "CustomBack"
    case embed = "Embed"
    case nonCustom = "NonCustom"
    case showNavCtrl = "Show-NavCtrl"
  }

  internal func perform(segue: StoryboardSegue, sender: Any? = nil) {
    let identifier = segue.rawValue
    performSegue(withIdentifier: identifier, sender: sender)
  }

  internal enum TypedStoryboardSegue {
    case customBack(destination: UIKit.UIViewController, segue: SwiftGen.SlideLeftSegue)
    case embed(destination: UIKit.UIViewController)
    case nonCustom(destination: UIKit.UIViewController)
    case showNavCtrl(destination: UIKit.UINavigationController, segue: SwiftGen.CustomSegueClass)
    case unnamedSegue

    // swiftlint:disable cyclomatic_complexity
    init(segue: StoryboardSegue) {
      switch segue.identifier ?? "" {
      case "CustomBack":
        guard let segue = segue as? SwiftGen.SlideLeftSegue else {
          fatalError("Segue 'CustomBack' is not of the expected type SwiftGen.SlideLeftSegue.")
        }
        let vc = segue.destination
        self = .customBack(destination: vc, segue: segue)
      case "Embed":
        let vc = segue.destination
        self = .embed(destination: vc)
      case "NonCustom":
        let vc = segue.destination
        self = .nonCustom(destination: vc)
      case "Show-NavCtrl":
        guard let segue = segue as? SwiftGen.CustomSegueClass else {
          fatalError("Segue 'Show-NavCtrl' is not of the expected type SwiftGen.CustomSegueClass.")
        }
        guard let vc = segue.destination as? UIKit.UINavigationController else {
          fatalError("Destination of segue 'Show-NavCtrl' is not of the expected type UIKit.UINavigationController.")
        }
        self = .showNavCtrl(destination: vc, segue: segue)
      case "":
        self = .unnamedSegue
      default:
        fatalError("Unrecognized segue '\(segue.identifier ?? "")' in SwiftGen.PickerViewController")
      }
    }
    // swiftlint:enable cyclomatic_complexity
  }
}

internal extension ExtraModule.ValidatePasswordViewController {
  internal enum StoryboardSegue: String {
    case showPassword = "ShowPassword"
  }

  internal func perform(segue: StoryboardSegue, sender: Any? = nil) {
    let identifier = segue.rawValue
    performSegue(withIdentifier: identifier, sender: sender)
  }

  internal enum TypedStoryboardSegue {
    case showPassword(destination: ExtraModule.ValidatePasswordViewController)
    case unnamedSegue

    // swiftlint:disable cyclomatic_complexity
    init(segue: StoryboardSegue) {
      switch segue.identifier ?? "" {
      case "ShowPassword":
        guard let vc = segue.destination as? ExtraModule.ValidatePasswordViewController else {
          fatalError("Destination of segue 'ShowPassword' is not of the expected type ExtraModule.ValidatePasswordViewController.")
        }
        self = .showPassword(destination: vc)
      case "":
        self = .unnamedSegue
      default:
        fatalError("Unrecognized segue '\(segue.identifier ?? "")' in ExtraModule.ValidatePasswordViewController")
      }
    }
    // swiftlint:enable cyclomatic_complexity
  }
}

internal extension LocationPicker.LocationPickerViewController {
  internal enum StoryboardSegue: String {
    case afterDelay = "After Delay"
    case `open`
    case `private`
    case `public`
  }

  internal func perform(segue: StoryboardSegue, sender: Any? = nil) {
    let identifier = segue.rawValue
    performSegue(withIdentifier: identifier, sender: sender)
  }

  internal enum TypedStoryboardSegue {
    case afterDelay(destination: SlackTextViewController.SLKTextViewController, segue: SwiftGen.SlideLeftSegue)
    case `open`(destination: SlackTextViewController.SLKTextViewController, segue: SlackTextViewController.SLKCrossoverSegue)
    case `private`(destination: SlackTextViewController.SLKTextViewController, segue: ExtraModule.SlideDownSegue)
    case `public`(destination: SlackTextViewController.SLKTextViewController, segue: SwiftGen.SlideUpSegue)
    case unnamedSegue

    // swiftlint:disable cyclomatic_complexity
    init(segue: StoryboardSegue) {
      switch segue.identifier ?? "" {
      case "After Delay":
        guard let segue = segue as? SwiftGen.SlideLeftSegue else {
          fatalError("Segue 'After Delay' is not of the expected type SwiftGen.SlideLeftSegue.")
        }
        guard let vc = segue.destination as? SlackTextViewController.SLKTextViewController else {
          fatalError("Destination of segue 'After Delay' is not of the expected type SlackTextViewController.SLKTextViewController.")
        }
        self = .afterDelay(destination: vc, segue: segue)
      case "open":
        guard let segue = segue as? SlackTextViewController.SLKCrossoverSegue else {
          fatalError("Segue 'open' is not of the expected type SlackTextViewController.SLKCrossoverSegue.")
        }
        guard let vc = segue.destination as? SlackTextViewController.SLKTextViewController else {
          fatalError("Destination of segue 'open' is not of the expected type SlackTextViewController.SLKTextViewController.")
        }
        self = .`open`(destination: vc, segue: segue)
      case "private":
        guard let segue = segue as? ExtraModule.SlideDownSegue else {
          fatalError("Segue 'private' is not of the expected type ExtraModule.SlideDownSegue.")
        }
        guard let vc = segue.destination as? SlackTextViewController.SLKTextViewController else {
          fatalError("Destination of segue 'private' is not of the expected type SlackTextViewController.SLKTextViewController.")
        }
        self = .`private`(destination: vc, segue: segue)
      case "public":
        guard let segue = segue as? SwiftGen.SlideUpSegue else {
          fatalError("Segue 'public' is not of the expected type SwiftGen.SlideUpSegue.")
        }
        guard let vc = segue.destination as? SlackTextViewController.SLKTextViewController else {
          fatalError("Destination of segue 'public' is not of the expected type SlackTextViewController.SLKTextViewController.")
        }
        self = .`public`(destination: vc, segue: segue)
      case "":
        self = .unnamedSegue
      default:
        fatalError("Unrecognized segue '\(segue.identifier ?? "")' in LocationPicker.LocationPickerViewController")
      }
    }
    // swiftlint:enable cyclomatic_complexity
  }
}

internal extension SlackTextViewController.SLKTextViewController {
  internal enum StoryboardSegue: String {
    case afterDelay = "After Delay"
    case `open`
    case `private`
    case `public`
  }

  internal func perform(segue: StoryboardSegue, sender: Any? = nil) {
    let identifier = segue.rawValue
    performSegue(withIdentifier: identifier, sender: sender)
  }

  internal enum TypedStoryboardSegue {
    case afterDelay(destination: SlackTextViewController.SLKTextViewController, segue: SwiftGen.SlideLeftSegue)
    case `open`(destination: SlackTextViewController.SLKTextViewController, segue: SlackTextViewController.SLKCrossoverSegue)
    case `private`(destination: SlackTextViewController.SLKTextViewController, segue: ExtraModule.SlideDownSegue)
    case `public`(destination: SlackTextViewController.SLKTextViewController, segue: SwiftGen.SlideUpSegue)
    case unnamedSegue

    // swiftlint:disable cyclomatic_complexity
    init(segue: StoryboardSegue) {
      switch segue.identifier ?? "" {
      case "After Delay":
        guard let segue = segue as? SwiftGen.SlideLeftSegue else {
          fatalError("Segue 'After Delay' is not of the expected type SwiftGen.SlideLeftSegue.")
        }
        guard let vc = segue.destination as? SlackTextViewController.SLKTextViewController else {
          fatalError("Destination of segue 'After Delay' is not of the expected type SlackTextViewController.SLKTextViewController.")
        }
        self = .afterDelay(destination: vc, segue: segue)
      case "open":
        guard let segue = segue as? SlackTextViewController.SLKCrossoverSegue else {
          fatalError("Segue 'open' is not of the expected type SlackTextViewController.SLKCrossoverSegue.")
        }
        guard let vc = segue.destination as? SlackTextViewController.SLKTextViewController else {
          fatalError("Destination of segue 'open' is not of the expected type SlackTextViewController.SLKTextViewController.")
        }
        self = .`open`(destination: vc, segue: segue)
      case "private":
        guard let segue = segue as? ExtraModule.SlideDownSegue else {
          fatalError("Segue 'private' is not of the expected type ExtraModule.SlideDownSegue.")
        }
        guard let vc = segue.destination as? SlackTextViewController.SLKTextViewController else {
          fatalError("Destination of segue 'private' is not of the expected type SlackTextViewController.SLKTextViewController.")
        }
        self = .`private`(destination: vc, segue: segue)
      case "public":
        guard let segue = segue as? SwiftGen.SlideUpSegue else {
          fatalError("Segue 'public' is not of the expected type SwiftGen.SlideUpSegue.")
        }
        guard let vc = segue.destination as? SlackTextViewController.SLKTextViewController else {
          fatalError("Destination of segue 'public' is not of the expected type SlackTextViewController.SLKTextViewController.")
        }
        self = .`public`(destination: vc, segue: segue)
      case "":
        self = .unnamedSegue
      default:
        fatalError("Unrecognized segue '\(segue.identifier ?? "")' in SlackTextViewController.SLKTextViewController")
      }
    }
    // swiftlint:enable cyclomatic_complexity
  }
}

internal extension SwiftGen.CreateAccViewController {
  internal enum StoryboardSegue: String {
    case showPassword = "ShowPassword"
  }

  internal func perform(segue: StoryboardSegue, sender: Any? = nil) {
    let identifier = segue.rawValue
    performSegue(withIdentifier: identifier, sender: sender)
  }

  internal enum TypedStoryboardSegue {
    case showPassword(destination: ExtraModule.ValidatePasswordViewController)
    case unnamedSegue

    // swiftlint:disable cyclomatic_complexity
    init(segue: StoryboardSegue) {
      switch segue.identifier ?? "" {
      case "ShowPassword":
        guard let vc = segue.destination as? ExtraModule.ValidatePasswordViewController else {
          fatalError("Destination of segue 'ShowPassword' is not of the expected type ExtraModule.ValidatePasswordViewController.")
        }
        self = .showPassword(destination: vc)
      case "":
        self = .unnamedSegue
      default:
        fatalError("Unrecognized segue '\(segue.identifier ?? "")' in SwiftGen.CreateAccViewController")
      }
    }
    // swiftlint:enable cyclomatic_complexity
  }
}

internal enum StoryboardSegue {
  internal enum AdditionalImport: String, SegueType {
    case afterDelay = "After Delay"
    case `open`
    case `private`
    case `public`
  }
  internal enum Message: String, SegueType {
    case customBack = "CustomBack"
    case embed = "Embed"
    case nonCustom = "NonCustom"
    case showNavCtrl = "Show-NavCtrl"
  }
  internal enum Wizard: String, SegueType {
    case showPassword = "ShowPassword"
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol SegueType: RawRepresentable {}

internal extension UIViewController {
  func perform<S: SegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    let identifier = segue.rawValue
    performSegue(withIdentifier: identifier, sender: sender)
  }
}

internal extension SegueType where RawValue == String {
  init?(_ segue: UIStoryboardSegue) {
    guard let identifier = segue.identifier else { return nil }
    self.init(rawValue: identifier)
  }
}
