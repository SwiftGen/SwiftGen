//
// SwiftGen
//
// CLI surface for interacting with Prompt Remix Decks.
//

import ArgumentParser
import Foundation
import SwiftGenCLI

extension Commands {
  struct RemixDeck: ParsableCommand {
    static let configuration = CommandConfiguration(
      abstract: "Explore Prompt Remix Decks to remix drafts with guided constraints.",
      subcommands: [
        List.self,
        Show.self,
        Export.self
      ],
      defaultSubcommand: List.self
    )
  }
}

extension Commands.RemixDeck {
  struct List: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "List the available remix cards.")

    func run() throws {
      let deck = try RemixDeckProvider.loadDeck()
      logMessage(.info, "\(deck.name) (v\(deck.version)) — \(deck.description)")
      deck.cards.forEach { card in
        logMessage(.info, "• \(card.title) [\(card.id)] — \(card.summary)")
      }
    }
  }
}

extension Commands.RemixDeck {
  struct Show: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Display the details for a single remix card.")

    @Argument(help: "Identifier of the remix card to display.")
    var id: String

    func run() throws {
      let deck = try RemixDeckProvider.loadDeck()

      guard let card = deck.card(withID: id) else {
        throw ValidationError("Unknown remix card identifier `\(id)`.")
      }

      logMessage(.info, "\(card.title) [\(card.id)]")
      logMessage(.info, card.summary)

      if !card.instructions.isEmpty {
        logMessage(.info, "Instructions:")
        for (index, instruction) in card.instructions.enumerated() {
          logMessage(.info, "  \(index + 1). \(instruction)")
        }
      }

      if !card.constraints.isEmpty {
        logMessage(.info, "Constraints:")
        for (index, constraint) in card.constraints.enumerated() {
          logMessage(.info, "  \(index + 1). \(constraint)")
        }
      }

      if !card.tags.isEmpty {
        logMessage(.info, "Tags: \(card.tags.joined(separator: ", "))")
      }
    }
  }
}

extension Commands.RemixDeck {
  struct Export: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Export the remix deck as JSON for UI consumption.")

    @Flag(name: .shortAndLong, help: "Pretty-print the exported JSON.")
    var pretty: Bool = false

    func run() throws {
      let deck = try RemixDeckProvider.loadDeck()
      let encoder = JSONEncoder()
      encoder.outputFormatting.insert(.sortedKeys)
      if pretty {
        encoder.outputFormatting.insert(.prettyPrinted)
      }

      let data = try encoder.encode(deck)
      FileHandle.standardOutput.write(data)
      FileHandle.standardOutput.write(Data([0x0a]))
    }
  }
}
