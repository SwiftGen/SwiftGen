import Foundation

public struct CharacterRelationship: Codable, Equatable {
  public enum Kind: String, Codable, CaseIterable {
    case ally
    case antagonist
    case colleague
    case family
    case mentor
    case rival
    case romantic
    case custom
  }

  public var kind: Kind
  public var source: CharacterProfile.ID
  public var target: CharacterProfile.ID
  public var description: String
  public var customLabel: String?

  public init(
    kind: Kind = .custom,
    source: CharacterProfile.ID,
    target: CharacterProfile.ID,
    description: String = "",
    customLabel: String? = nil
  ) {
    self.kind = kind
    self.source = source
    self.target = target
    self.description = description
    self.customLabel = customLabel
  }

  public var label: String {
    if let customLabel = customLabel, !customLabel.isEmpty {
      return customLabel
    }
    return kind.rawValue.capitalized
  }

  public func promptSummary(with lookup: [CharacterProfile.ID: CharacterProfile]) -> String {
    let sourceName = lookup[source]?.displayName ?? source
    let targetName = lookup[target]?.displayName ?? target
    var components: [String] = ["\(sourceName) - \(label) - \(targetName)"]
    if !description.isEmpty {
      components.append(description)
    }
    return components.joined(separator: ": ")
  }
}
