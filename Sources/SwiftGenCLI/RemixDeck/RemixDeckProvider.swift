//
// SwiftGen
//
// Loader that exposes remix card bundles to the rest of the application/UI layer.
//

import Foundation

public enum RemixDeckProvider {
  public enum Error: Swift.Error, LocalizedError {
    case missingResource(String)
    case decodingFailed(Swift.Error)

    public var errorDescription: String? {
      switch self {
      case .missingResource(let resource):
        return "Unable to locate remix deck resource named \(resource)."
      case .decodingFailed(let error):
        return "Failed to decode remix deck: \(error.localizedDescription)"
      }
    }
  }

  private static let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()

  public static func loadDeck(named resourceName: String = "deck", bundle: Foundation.Bundle = .module) throws -> RemixDeck {
    guard let url = bundle.url(forResource: resourceName, withExtension: "json", subdirectory: "RemixDeck") else {
      throw Error.missingResource(resourceName)
    }

    do {
      let data = try Data(contentsOf: url)
      return try decoder.decode(RemixDeck.self, from: data)
    } catch let decodingError {
      throw Error.decodingFailed(decodingError)
    }
  }

  public static func availableCards(bundle: Foundation.Bundle = .module) throws -> [RemixCard] {
    try loadDeck(bundle: bundle).cards
  }
}
