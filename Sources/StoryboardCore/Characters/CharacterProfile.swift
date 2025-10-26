import Foundation

public struct CharacterProfile: Codable, Equatable, Identifiable {
  public struct VoiceSample: Codable, Equatable {
    public var label: String
    public var url: URL?
    public var transcript: String?

    public init(label: String, url: URL? = nil, transcript: String? = nil) {
      self.label = label
      self.url = url
      self.transcript = transcript
    }

    public func promptFragment() -> String {
      var components: [String] = [label]
      if let transcript = transcript, !transcript.isEmpty {
        components.append(transcript)
      } else if let url = url {
        components.append(url.absoluteString)
      }
      return components.joined(separator: ": ")
    }
  }

  public typealias ID = String

  public var id: ID
  public var displayName: String
  public var biography: String
  public var traits: [String]
  public var voiceSamples: [VoiceSample]
  public var promptPreamble: String?

  public init(
    id: ID? = nil,
    displayName: String,
    biography: String,
    traits: [String] = [],
    voiceSamples: [VoiceSample] = [],
    promptPreamble: String? = nil
  ) {
    self.id = CharacterProfile.resolveIdentifier(from: id, fallback: displayName)
    self.displayName = displayName
    self.biography = biography
    self.traits = traits
    self.voiceSamples = voiceSamples
    self.promptPreamble = promptPreamble
  }

  public func promptSummary() -> String {
    var segments: [String] = ["\(displayName): \(biography)"]

    if !traits.isEmpty {
      segments.append("Traits: \(traits.joined(separator: ", "))")
    }

    if !voiceSamples.isEmpty {
      let samples = voiceSamples.map { $0.promptFragment() }.joined(separator: "; ")
      segments.append("Voice: \(samples)")
    }

    if let promptPreamble = promptPreamble, !promptPreamble.isEmpty {
      segments.append(promptPreamble)
    }

    return segments.joined(separator: " ")
  }

  private static func resolveIdentifier(from id: ID?, fallback: String) -> ID {
    if let id, !id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      return id
    }

    let components = fallback
      .lowercased()
      .split { !$0.isLetter && !$0.isNumber }
      .filter { !$0.isEmpty }
    if components.isEmpty {
      return UUID().uuidString
    }
    return components.joined(separator: "-")
  }
}
