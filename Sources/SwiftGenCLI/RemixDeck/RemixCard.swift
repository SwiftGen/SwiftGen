//
// SwiftGen
//
// Created for the Prompt Remix Deck feature.
//

import Foundation

public struct RemixCard: Codable, Hashable, Identifiable {
  enum CodingKeys: String, CodingKey {
    case id
    case title
    case summary
    case instructions
    case constraints
    case tags
  }

  public let id: String
  public let title: String
  public let summary: String
  public let instructions: [String]
  public let constraints: [String]
  public let tags: [String]

  public init(
    id: String,
    title: String,
    summary: String,
    instructions: [String],
    constraints: [String],
    tags: [String]
  ) {
    self.id = id
    self.title = title
    self.summary = summary
    self.instructions = instructions
    self.constraints = constraints
    self.tags = tags
  }
}
