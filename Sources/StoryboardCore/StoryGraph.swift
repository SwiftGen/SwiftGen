import Foundation

public struct StoryBeat: Identifiable, Hashable {
  public let id: UUID
  public var title: String
  public var summary: String
  public var decision: StoryDecision?
  public var metadata: [String: String]

  public init(
    id: UUID = UUID(),
    title: String,
    summary: String,
    decision: StoryDecision? = nil,
    metadata: [String: String] = [:]
  ) {
    self.id = id
    self.title = title
    self.summary = summary
    self.decision = decision
    self.metadata = metadata
  }

  public var isPivotal: Bool {
    decision?.kind == .pivotal
  }

  public func alternate(using option: StoryDecision.Option) -> StoryBeat {
    var copy = self
    copy.metadata[StoryBeat.MetadataKey.alternateOptionID.rawValue] = option.id.uuidString
    copy.metadata[StoryBeat.MetadataKey.alternateOptionTitle.rawValue] = option.title
    copy.metadata[StoryBeat.MetadataKey.alternateOptionOutcome.rawValue] = option.outcome
    return copy
  }
}

public extension StoryBeat {
  enum MetadataKey: String {
    case alternateOptionID
    case alternateOptionTitle
    case alternateOptionOutcome
  }
}

public struct StoryDecision: Hashable {
  public enum Kind: String, Hashable {
    case pivotal
    case flavour
  }

  public struct Option: Identifiable, Hashable {
    public let id: UUID
    public var title: String
    public var outcome: String
    public var metadata: [String: String]

    public init(
      id: UUID = UUID(),
      title: String,
      outcome: String,
      metadata: [String: String] = [:]
    ) {
      self.id = id
      self.title = title
      self.outcome = outcome
      self.metadata = metadata
    }
  }

  public var kind: Kind
  public var canonicalOption: Option
  public var alternatives: [Option]

  public init(kind: Kind, canonicalOption: Option, alternatives: [Option]) {
    self.kind = kind
    self.canonicalOption = canonicalOption
    self.alternatives = alternatives
  }
}

public struct StoryNode: Identifiable, Hashable {
  public let id: UUID
  public let beatID: UUID
  public var title: String
  public var synopsis: String
  public var context: Context
  public var metadata: [String: String]

  public init(
    id: UUID = UUID(),
    beatID: UUID,
    title: String,
    synopsis: String,
    context: Context,
    metadata: [String: String] = [:]
  ) {
    self.id = id
    self.beatID = beatID
    self.title = title
    self.synopsis = synopsis
    self.context = context
    self.metadata = metadata
  }

  public enum Context: Hashable {
    case canonical
    case alternate(optionID: UUID)
  }
}

public struct StoryBeatPipeline {
  public enum Context {
    case canonical
    case alternate(option: StoryDecision.Option)
  }

  public typealias NodeBuilder = (_ beat: StoryBeat, _ context: Context) -> StoryNode

  private let builder: NodeBuilder

  public init(builder: @escaping NodeBuilder) {
    self.builder = builder
  }

  public func makeNode(from beat: StoryBeat, context: Context) -> StoryNode {
    builder(beat, context)
  }
}

public struct AlternateRealityBranch: Hashable {
  public let pivotNodeID: UUID
  public let option: StoryDecision.Option
  public let nodes: [StoryNode]
}

public struct StoryGraph {
  public private(set) var nodes: [UUID: StoryNode] = [:]
  public private(set) var edges: [UUID: Set<UUID>] = [:]
  public private(set) var beats: [StoryBeat] = []

  private let pipeline: StoryBeatPipeline
  private var canonicalIndex: [UUID: UUID] = [:]
  private var alternateIndex: [UUID: [UUID: UUID]] = [:]

  public init(pipeline: StoryBeatPipeline) {
    self.pipeline = pipeline
  }

  public mutating func draftStory(with beats: [StoryBeat]) {
    self.beats = beats
    nodes.removeAll(keepingCapacity: true)
    edges.removeAll(keepingCapacity: true)
    canonicalIndex.removeAll(keepingCapacity: true)
    alternateIndex.removeAll(keepingCapacity: true)

    var previousNodeID: UUID?
    for beat in beats {
      let node = pipeline.makeNode(from: beat, context: .canonical)
      nodes[node.id] = node
      canonicalIndex[beat.id] = node.id

      if let previous = previousNodeID {
        edges[previous, default: []].insert(node.id)
      }
      previousNodeID = node.id
    }
  }

  @discardableResult
  public mutating func generateAlternateRealities() -> [AlternateRealityBranch] {
    var branches: [AlternateRealityBranch] = []

    for beat in beats where beat.isPivotal {
      guard
        let decision = beat.decision,
        let pivotNodeID = canonicalIndex[beat.id]
      else { continue }

      for option in decision.alternatives {
        if
          let optionMap = alternateIndex[beat.id],
          let nodeID = optionMap[option.id],
          let existingNode = nodes[nodeID]
        {
          branches.append(
            AlternateRealityBranch(pivotNodeID: pivotNodeID, option: option, nodes: [existingNode])
          )
          continue
        }

        let alternateBeat = beat.alternate(using: option)
        let node = pipeline.makeNode(from: alternateBeat, context: .alternate(option: option))
        nodes[node.id] = node
        edges[pivotNodeID, default: []].insert(node.id)

        var optionMap = alternateIndex[beat.id, default: [:]]
        optionMap[option.id] = node.id
        alternateIndex[beat.id] = optionMap

        branches.append(AlternateRealityBranch(pivotNodeID: pivotNodeID, option: option, nodes: [node]))
      }
    }

    return branches
  }

  public func canonicalNodeID(for beatID: UUID) -> UUID? {
    canonicalIndex[beatID]
  }

  public func alternateNodes(for beatID: UUID) -> [StoryNode] {
    guard let optionMap = alternateIndex[beatID] else { return [] }
    return optionMap.values.compactMap { nodes[$0] }
  }

  public func children(of nodeID: UUID) -> [StoryNode] {
    guard let childIDs = edges[nodeID] else { return [] }
    return childIDs.compactMap { nodes[$0] }
  }
}
