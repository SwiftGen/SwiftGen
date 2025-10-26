//
// SwiftGen
//
// Tests for the Prompt Remix Deck loader.
//

@testable import SwiftGenCLI
import XCTest

final class RemixDeckTests: XCTestCase {
  func testDeckLoadsFromBundle() throws {
    let deck = try RemixDeckProvider.loadDeck()

    XCTAssertEqual(deck.name, "Prompt Remix Deck")
    XCTAssertEqual(deck.version, 1)
    XCTAssertEqual(deck.cards.count, 5)

    let genreSwap = try XCTUnwrap(deck.card(withID: "genre-swap"))
    XCTAssertEqual(genreSwap.title, "Genre Swap")
    XCTAssertFalse(genreSwap.constraints.isEmpty)
  }

  func testTagIndexProvidesLookup() throws {
    let deck = try RemixDeckProvider.loadDeck()
    let tagIndex = deck.tagIndex()

    XCTAssertTrue(tagIndex.keys.contains("genre"))
    XCTAssertFalse(tagIndex["genre", default: []].isEmpty)
    XCTAssertTrue(tagIndex.keys.contains("voice"))
  }
}
