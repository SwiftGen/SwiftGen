import XCTest
@testable import StoryboardCore

final class StoryGraphAlternateRealityTests: XCTestCase {
  private let canonicalOptionID = UUID(uuidString: "AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEE0")!
  private let retreatOptionID = UUID(uuidString: "AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEE1")!
  private let bargainOptionID = UUID(uuidString: "AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEE2")!

  private lazy var pipeline = StoryBeatPipeline { beat, context in
    switch context {
    case .canonical:
      return StoryNode(
        id: beat.id,
        beatID: beat.id,
        title: beat.title,
        synopsis: beat.summary,
        context: .canonical
      )
    case let .alternate(option):
      return StoryNode(
        id: option.id,
        beatID: beat.id,
        title: "\(beat.title) – What if \(option.title)?",
        synopsis: option.outcome,
        context: .alternate(optionID: option.id)
      )
    }
  }

  func testGenerateAlternateBranchesAddsExplorableNodes() {
    let incitingBeat = StoryBeat(
      id: UUID(uuidString: "11111111-2222-3333-4444-555555555555")!,
      title: "Inciting Incident",
      summary: "The hero is called to adventure."
    )

    let pivotalBeatID = UUID(uuidString: "66666666-7777-8888-9999-AAAAAAAAAAAA")!
    let decision = StoryDecision(
      kind: .pivotal,
      canonicalOption: StoryDecision.Option(
        id: canonicalOptionID,
        title: "Stand and Fight",
        outcome: "The hero defeats the invaders."
      ),
      alternatives: [
        StoryDecision.Option(
          id: retreatOptionID,
          title: "Retreat",
          outcome: "The village is lost but the hero survives."
        ),
        StoryDecision.Option(
          id: bargainOptionID,
          title: "Bargain",
          outcome: "A dark pact saves the day at a cost."
        ),
      ]
    )
    let pivotalBeat = StoryBeat(
      id: pivotalBeatID,
      title: "Defend the Village",
      summary: "The hero makes a crucial stand.",
      decision: decision
    )

    var graph = StoryGraph(pipeline: pipeline)
    graph.draftStory(with: [incitingBeat, pivotalBeat])

    let branches = graph.generateAlternateRealities()

    XCTAssertEqual(branches.count, 2)
    XCTAssertEqual(graph.alternateNodes(for: pivotalBeatID).count, 2)

    let childNodes = graph.children(of: graph.canonicalNodeID(for: pivotalBeatID)!)
    let childIDs = Set(childNodes.map(\.id))
    XCTAssertTrue(childIDs.contains(retreatOptionID))
    XCTAssertTrue(childIDs.contains(bargainOptionID))
  }

  func testGenerateAlternateBranchesIsIdempotent() {
    let pivotalBeatID = UUID(uuidString: "BBBBBBBB-CCCC-DDDD-EEEE-FFFFFFFFFFFF")!
    let decision = StoryDecision(
      kind: .pivotal,
      canonicalOption: StoryDecision.Option(
        id: canonicalOptionID,
        title: "Stand and Fight",
        outcome: "The hero defeats the invaders."
      ),
      alternatives: [
        StoryDecision.Option(
          id: retreatOptionID,
          title: "Retreat",
          outcome: "The village is lost but the hero survives."
        )
      ]
    )
    let pivotalBeat = StoryBeat(
      id: pivotalBeatID,
      title: "Defend the Village",
      summary: "The hero makes a crucial stand.",
      decision: decision
    )

    var graph = StoryGraph(pipeline: pipeline)
    graph.draftStory(with: [pivotalBeat])

    _ = graph.generateAlternateRealities()
    let secondPass = graph.generateAlternateRealities()

    XCTAssertEqual(secondPass.count, 1)
    XCTAssertEqual(graph.alternateNodes(for: pivotalBeatID).count, 1)
  }
}
