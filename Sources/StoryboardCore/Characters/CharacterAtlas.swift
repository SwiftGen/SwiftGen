import Foundation

public struct CharacterAtlas: Codable, Equatable {
  public struct Board: Codable, Equatable, Identifiable {
    public var id: String
    public var title: String
    public var synopsis: String
    public var promptPreamble: String?
    public var promptStyle: [String]
    public var characters: [CharacterProfile]
    public var relationships: [CharacterRelationship]

    public init(
      id: String,
      title: String,
      synopsis: String = "",
      promptPreamble: String? = nil,
      promptStyle: [String] = [],
      characters: [CharacterProfile] = [],
      relationships: [CharacterRelationship] = []
    ) {
      self.id = id
      self.title = title
      self.synopsis = synopsis
      self.promptPreamble = promptPreamble
      self.promptStyle = promptStyle
      self.characters = characters
      self.relationships = relationships
    }

    public func characterLookup() -> [CharacterProfile.ID: CharacterProfile] {
      Dictionary(uniqueKeysWithValues: characters.map { ($0.id, $0) })
    }
  }

  public struct SceneBinding: Codable, Equatable {
    public var storyboardName: String?
    public var sceneIdentifier: String
    public var boardIDs: [String]
    public var promptNotes: [String]

    public init(
      storyboardName: String? = nil,
      sceneIdentifier: String,
      boardIDs: [String],
      promptNotes: [String] = []
    ) {
      self.storyboardName = storyboardName
      self.sceneIdentifier = sceneIdentifier
      self.boardIDs = boardIDs
      self.promptNotes = promptNotes
    }

    public func matches(sceneIdentifier: String, storyboardName: String) -> Bool {
      guard self.sceneIdentifier == sceneIdentifier else {
        return false
      }
      if let bindingStoryboard = storyboardNameOptionalNormalized(),
         !bindingStoryboard.isEmpty {
        return bindingStoryboard == storyboardName.trimmingCharacters(in: .whitespacesAndNewlines)
      }
      return true
    }

    private func storyboardNameOptionalNormalized() -> String? {
      guard let storyboardName = storyboardName?.trimmingCharacters(in: .whitespacesAndNewlines), !storyboardName.isEmpty else {
        return nil
      }
      return storyboardName
    }
  }

  public struct CharacterPromptPrimer: Codable, Equatable {
    public let sceneIdentifier: String
    public let boards: [Board]
    public let promptNotes: [String]

    public init(sceneIdentifier: String, boards: [Board], promptNotes: [String] = []) {
      self.sceneIdentifier = sceneIdentifier
      self.boards = boards
      self.promptNotes = promptNotes
    }

    public func renderPrompt() -> String {
      var sections: [String] = []

      for board in boards {
        var boardLines: [String] = []
        boardLines.append("### \(board.title)")
        if !board.synopsis.isEmpty {
          boardLines.append(board.synopsis)
        }
        if let preamble = board.promptPreamble, !preamble.isEmpty {
          boardLines.append(preamble)
        }
        if !board.promptStyle.isEmpty {
          boardLines.append("Style: \(board.promptStyle.joined(separator: ", "))")
        }
        if !board.characters.isEmpty {
          boardLines.append("Characters:")
          for character in board.characters {
            boardLines.append(" - \(character.promptSummary())")
          }
        }
        if !board.relationships.isEmpty {
          boardLines.append("Relationships:")
          let lookup = board.characterLookup()
          for relationship in board.relationships {
            boardLines.append(" - \(relationship.promptSummary(with: lookup))")
          }
        }
        sections.append(boardLines.joined(separator: "\n"))
      }

      if !promptNotes.isEmpty {
        var notesSection = ["Scene Notes:"]
        for note in promptNotes {
          notesSection.append(" - \(note)")
        }
        sections.append(notesSection.joined(separator: "\n"))
      }

      return sections.joined(separator: "\n\n")
    }

    public func contextDictionary() -> [String: Any] {
      var context: [String: Any] = [
        "sceneIdentifier": sceneIdentifier,
        "notes": promptNotes,
        "prompt": renderPrompt()
      ]

      context["boards"] = boards.map { board -> [String: Any] in
        var boardContext: [String: Any] = [
          "id": board.id,
          "title": board.title,
          "synopsis": board.synopsis,
          "promptPreamble": board.promptPreamble ?? "",
          "promptStyle": board.promptStyle
        ]

        boardContext["characters"] = board.characters.map { character -> [String: Any] in
          [
            "id": character.id,
            "displayName": character.displayName,
            "biography": character.biography,
            "traits": character.traits,
            "voiceSamples": character.voiceSamples.map { sample -> [String: Any] in
              [
                "label": sample.label,
                "url": sample.url?.absoluteString ?? "",
                "transcript": sample.transcript ?? ""
              ]
            },
            "promptSummary": character.promptSummary(),
            "promptPreamble": character.promptPreamble ?? ""
          ]
        }

        let lookup = board.characterLookup()
        boardContext["relationships"] = board.relationships.map { relationship -> [String: Any] in
          [
            "kind": relationship.kind.rawValue,
            "source": relationship.source,
            "target": relationship.target,
            "description": relationship.description,
            "label": relationship.label,
            "promptSummary": relationship.promptSummary(with: lookup)
          ]
        }

        return boardContext
      }

      return context
    }
  }

  public var boards: [Board]
  public var sceneBindings: [SceneBinding]

  public init(boards: [Board] = [], sceneBindings: [SceneBinding] = []) {
    self.boards = boards
    self.sceneBindings = sceneBindings
  }

  public func board(withID id: String) -> Board? {
    boards.first { $0.id == id }
  }

  public func boards(forScene identifier: String, storyboardName: String) -> [Board] {
    guard let binding = binding(forScene: identifier, storyboardName: storyboardName) else {
      return []
    }
    return binding.boardIDs.compactMap { board(withID: $0) }
  }

  public func promptPrimer(forScene identifier: String, storyboardName: String) -> CharacterPromptPrimer? {
    guard !identifier.isEmpty else {
      return nil
    }
    let matchedBoards = boards(forScene: identifier, storyboardName: storyboardName)
    guard !matchedBoards.isEmpty else {
      return nil
    }
    let notes = binding(forScene: identifier, storyboardName: storyboardName)?.promptNotes ?? []
    return CharacterPromptPrimer(sceneIdentifier: identifier, boards: matchedBoards, promptNotes: notes)
  }

  private func binding(forScene identifier: String, storyboardName: String) -> SceneBinding? {
    sceneBindings.first { $0.matches(sceneIdentifier: identifier, storyboardName: storyboardName) }
  }
}
