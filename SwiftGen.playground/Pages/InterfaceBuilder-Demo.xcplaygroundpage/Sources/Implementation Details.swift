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
  #if swift(>=5.6)
  public let storyboard: any StoryboardType.Type
  #else
  public let storyboard: StoryboardType.Type
  #endif
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

  #if swift(>=5.6)
  // Extra for playgrounds
  public init(storyboard: any StoryboardType.Type, identifier: String) {
    self.storyboard = storyboard
    self.identifier = identifier
  }
  #else
  // Extra for playgrounds
  public init(storyboard: StoryboardType.Type, identifier: String) {
    self.storyboard = storyboard
    self.identifier = identifier
  }
  #endif
}

public struct InitialSceneType<T: UIViewController> {
  #if swift(>=5.6)
  public let storyboard: any StoryboardType.Type
  #else
  public let storyboard: StoryboardType.Type
  #endif

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

  #if swift(>=5.6)
  // Extra for playgrounds
  public init(storyboard: any StoryboardType.Type) {
    self.storyboard = storyboard
  }
  #else
  // Extra for playgrounds
  public init(storyboard: StoryboardType.Type) {
    self.storyboard = storyboard
  }
  #endif
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
