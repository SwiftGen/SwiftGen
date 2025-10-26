//
// SwiftGenKit UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Foundation
@testable import SwiftGenKit
import TestUtils
import XCTest

final class InterfaceBuilderiOSTests: XCTestCase {
  func testEmpty() throws {
    let parser = try InterfaceBuilder.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .interfaceBuilderiOS)
  }

  func testMessageStoryboard() throws {
    let parser = try InterfaceBuilder.Parser()
    do {
      try parser.searchAndParse(path: Fixtures.resource(for: "Message.storyboard", sub: .interfaceBuilderiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "messages", sub: .interfaceBuilderiOS)
  }

  func testAnonymousStoryboard() throws {
    let parser = try InterfaceBuilder.Parser()
    do {
      try parser.searchAndParse(path: Fixtures.resource(for: "Anonymous.storyboard", sub: .interfaceBuilderiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "anonymous", sub: .interfaceBuilderiOS)
  }

  func testAllStoryboards() throws {
    let parser = try InterfaceBuilder.Parser()
    do {
      try parser.searchAndParse(path: Fixtures.resourceDirectory(sub: .interfaceBuilderiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "all", sub: .interfaceBuilderiOS)
  }

  func testCharacterAtlasPromptInjection() throws {
    let atlasJSON = """
    {
      "boards": [
        {
          "id": "crew",
          "title": "Bridge Crew",
          "synopsis": "The Aurora's command crew.",
          "promptPreamble": "Keep dialogue witty and strategic.",
          "promptStyle": ["snappy", "space opera"],
          "characters": [
            {
              "id": "rhea",
              "displayName": "Captain Rhea",
              "biography": "Veteran leader of the starship Aurora.",
              "traits": ["decisive", "protective"],
              "voiceSamples": [
                {
                  "label": "Captain's log",
                  "url": "https://example.com/rhea-log.mp3",
                  "transcript": "Crew, hold the line."
                }
              ],
              "promptPreamble": "Always addresses the team collectively."
            },
            {
              "id": "jax",
              "displayName": "Jax Helios",
              "biography": "Ace pilot with a mischievous grin.",
              "traits": ["reckless", "loyal"]
            }
          ],
          "relationships": [
            {
              "kind": "ally",
              "source": "rhea",
              "target": "jax",
              "description": "Bonded during the Siege of Vega."
            }
          ]
        }
      ],
      "sceneBindings": [
        {
          "storyboardName": "Message",
          "sceneIdentifier": "MessagesList",
          "boardIDs": ["crew"],
          "promptNotes": ["Scene opens on the bridge monitoring transmissions."]
        }
      ]
    }
    """

    let tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
      .appendingPathComponent("character-atlas-\(UUID().uuidString).json")
    defer { try? FileManager.default.removeItem(at: tempURL) }

    try atlasJSON.write(to: tempURL, atomically: true, encoding: .utf8)

    let parser = try InterfaceBuilder.Parser(options: ["characterAtlas": tempURL.path])
    try parser.searchAndParse(path: Fixtures.resource(for: "Message.storyboard", sub: .interfaceBuilderiOS))

    let context = parser.stencilContext()
    guard
      let storyboards = context["storyboards"] as? [[String: Any]],
      let message = storyboards.first(where: { ($0["name"] as? String) == "Message" }),
      let scenes = message["scenes"] as? [[String: Any]],
      let messagesList = scenes.first(where: { ($0["identifier"] as? String) == "MessagesList" })
    else {
      XCTFail("Unable to resolve storyboard context for character atlas test")
      return
    }

    let prompt = messagesList["characterPrompt"] as? String
    XCTAssertNotNil(prompt)
    XCTAssertTrue(prompt?.contains("Captain Rhea") ?? false)
    XCTAssertTrue(prompt?.contains("Relationships:") ?? false)

    guard
      let atlas = messagesList["characterAtlas"] as? [String: Any],
      let boards = atlas["boards"] as? [[String: Any]],
      let crew = boards.first(where: { ($0["id"] as? String) == "crew" }),
      let characters = crew["characters"] as? [[String: Any]],
      let relationships = crew["relationships"] as? [[String: Any]],
      let notes = atlas["notes"] as? [String]
    else {
      XCTFail("Atlas payload missing expected structure")
      return
    }

    XCTAssertEqual(atlas["sceneIdentifier"] as? String, "MessagesList")
    XCTAssertEqual(characters.count, 2)
    XCTAssertEqual(relationships.count, 1)
    XCTAssertEqual(notes.first, "Scene opens on the bridge monitoring transmissions.")
  }

  // ensure we still have a test case for checking support of module placeholders
  func testConsistencyOfModules() throws {
    let fakeModuleName = "NotCurrentModule"

    let parser = try InterfaceBuilder.Parser()
    try parser.searchAndParse(path: Fixtures.resourceDirectory(sub: .interfaceBuilderiOS))

    XCTAssert(
      parser.storyboards.contains { storyboard in
        storyboard.scenes.contains { $0.moduleIsPlaceholder && $0.module == fakeModuleName } &&
        storyboard.segues.contains { $0.moduleIsPlaceholder && $0.module == fakeModuleName }
      }
    )
  }

  // MARK: - Custom options

  func testUnknownOption() throws {
    do {
      _ = try InterfaceBuilder.Parser(options: ["SomeOptionThatDoesntExist": "foo"])
      XCTFail("Parser successfully created with an invalid option")
    } catch ParserOptionList.Error.unknownOption(let key, _) {
      // That's the expected exception we want to happen
      XCTAssertEqual(key, "SomeOptionThatDoesntExist", "Failed for unexpected option \(key)")
    } catch let error {
      XCTFail("Unexpected error occured: \(error)")
    }
  }
}
