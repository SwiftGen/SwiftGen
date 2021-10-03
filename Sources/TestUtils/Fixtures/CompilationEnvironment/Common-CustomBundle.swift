import Foundation

final class ResourcesBundle: Bundle {
  private static let current = Bundle(for: ResourcesBundle.self)

  static let bundle: Bundle = {
    guard let url = current.url(forResource: "SwiftGenResources", withExtension: "bundle"),
      let bundle = Bundle(url: url) else {
      fatalError("Can't find 'SwiftGenResources' resources bundle")
    }
    return bundle
  }()
}
