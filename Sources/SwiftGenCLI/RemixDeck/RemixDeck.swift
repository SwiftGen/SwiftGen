//
// SwiftGen
//
// Core model representing a bundle of remix cards that can be displayed in the UI drawer.
//

import Foundation

public struct RemixDeck: Codable, Hashable {
  enum CodingKeys: String, CodingKey {
    case name
    case version
    case description
    case cards
  }

  public let name: String
  public let version: Int
  public let description: String
  public let cards: [RemixCard]

  public init(name: String, version: Int, description: String, cards: [RemixCard]) {
    self.name = name
    self.version = version
    self.description = description
    self.cards = cards
  }

  public func card(withID id: String) -> RemixCard? {
    cards.first { $0.id == id }
  }

  public func tagIndex() -> [String: [RemixCard]] {
    cards.reduce(into: [:]) { partialResult, card in
      if card.tags.isEmpty {
        partialResult["untagged", default: []].append(card)
      } else {
        for tag in card.tags {
          partialResult[tag, default: []].append(card)
        }
      }
    }
  }
}
