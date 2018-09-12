import UIKit

// Extra for playgrounds
public var bundle: Bundle?

// MARK: - Implementation Details (scenes)

public protocol StoryboardType {
  static var storyboardName: String { get }
}

public extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: bundle)
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

  // Extra for playgrounds
  public init(storyboard: StoryboardType.Type, identifier: String) {
    self.storyboard = storyboard
    self.identifier = identifier
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

  // Extra for playgrounds
  public init(storyboard: StoryboardType.Type) {
    self.storyboard = storyboard
  }
}

// MARK: - Implementation Details (segues)

public protocol SegueType: RawRepresentable {}

public extension UIViewController {
  func perform<S: SegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    let identifier = segue.rawValue
    performSegue(withIdentifier: identifier, sender: sender)
  }
}

public extension SegueType where RawValue == String {
  init?(_ segue: UIStoryboardSegue) {
    guard let identifier = segue.identifier else { return nil }
    self.init(rawValue: identifier)
  }
}
