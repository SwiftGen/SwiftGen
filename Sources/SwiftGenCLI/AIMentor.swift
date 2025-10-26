//
// SwiftGen
//
// Created for AI Story Coach feature.
//

import Foundation

/// Provides narrative suggestions based on the user's prompts and the
/// upcoming template rendering. The mentor keeps a lightweight history so
/// it can notice repeated runs and nudge the user toward creative twists.
public final class AIMentor {
  public struct PromptSnapshot {
    public let commandName: String
    public let templateName: String
    public let filter: String?
    public let optionSignature: [String]
    public let parameterSignature: [String]
    public let inputCount: Int
    public let inputDigest: String

    init(
      commandName: String,
      templateName: String,
      filter: String?,
      optionSignature: [String],
      parameterSignature: [String],
      inputCount: Int,
      inputDigest: String
    ) {
      self.commandName = commandName
      self.templateName = templateName
      self.filter = filter
      self.optionSignature = optionSignature
      self.parameterSignature = parameterSignature
      self.inputCount = inputCount
      self.inputDigest = inputDigest
    }
  }

  public struct ProposedOutput {
    public let commandName: String
    public let templateName: String
    public let filter: String?
    public let optionSignature: [String]
    public let parameterSignature: [String]
    public let inputCount: Int
    public let inputDigest: String
    public let contextKeys: [String]
    public let contextHighlights: [String]
    public let outputDescription: String

    init(
      commandName: String,
      templateName: String,
      filter: String?,
      optionSignature: [String],
      parameterSignature: [String],
      inputCount: Int,
      inputDigest: String,
      context: [String: Any],
      outputDescription: String
    ) {
      self.commandName = commandName
      self.templateName = templateName
      self.filter = filter
      self.optionSignature = optionSignature
      self.parameterSignature = parameterSignature
      self.inputCount = inputCount
      self.inputDigest = inputDigest
      self.contextKeys = context.keys.sorted()
      self.contextHighlights = AIMentor.contextHighlights(from: context)
      self.outputDescription = outputDescription
    }
  }

  private let queue = DispatchQueue(label: "swiftgen.aiMentor.queue", attributes: .concurrent)
  private var history: [PromptSnapshot] = []

  public init() {}

  public func observe(prompt: PromptSnapshot) {
    queue.sync(flags: .barrier) {
      history.append(prompt)
    }
  }

  public func advice(for proposedOutput: ProposedOutput) -> [String] {
    let history = queue.sync { self.history }
    let similarPrompts = history.filter {
      $0.commandName == proposedOutput.commandName &&
        $0.templateName == proposedOutput.templateName
    }

    var tips: [String] = []

    if proposedOutput.parameterSignature.isEmpty {
      tips.append("No template parameters detected—add a tone, theme, or constraint so the mentor can riff on it.")
    }

    if !proposedOutput.parameterSignature.isEmpty,
       similarPrompts.count > 1,
       similarPrompts.allSatisfy({ $0.parameterSignature == proposedOutput.parameterSignature }) {
      tips.append("Template parameters mirror earlier runs. Tweak one to steer the story in a surprising direction.")
    }

    if !proposedOutput.optionSignature.isEmpty,
       similarPrompts.count > 1,
       similarPrompts.allSatisfy({ $0.optionSignature == proposedOutput.optionSignature }) {
      tips.append("Parser options haven't changed across runs—toggle one to explore a different angle.")
    }

    if similarPrompts.count >= 3 {
      tips.append("You've asked for the \(proposedOutput.templateName) template \(similarPrompts.count) times. Mash in a contrasting data source for a fresh twist.")
    }

    if proposedOutput.inputCount > 0,
       similarPrompts.count > 1,
       similarPrompts.allSatisfy({ $0.inputDigest == proposedOutput.inputDigest }) {
      tips.append("You're feeding the same \(proposedOutput.inputCount) input(s) each time. Swap in a contrasting source file for a new beat.")
    }

    if let filter = proposedOutput.filter,
       !filter.isEmpty,
       similarPrompts.count > 1,
       similarPrompts.allSatisfy({ $0.filter == filter }) {
      tips.append("The filter '" + filter + "' has been reused. Broaden or flip it to surface unexpected material.")
    }

    if proposedOutput.contextKeys.isEmpty {
      tips.append("The parsed context is empty—feed the mentor more story beats or verify your inputs before generating.")
    } else if proposedOutput.contextKeys.count == 1, let key = proposedOutput.contextKeys.first {
      tips.append("Only the '" + key + "' context is present. Layer another dataset (characters, locations, goals) for richer coaching.")
    }

    let loweredKeys = proposedOutput.contextKeys.map { $0.lowercased() }
    if loweredKeys.contains(where: { $0.contains("scene") || $0.contains("story") }) {
      tips.append("Try spiking the next scene with a reversal or ticking clock to surprise your audience.")
    }
    if loweredKeys.contains(where: { $0.contains("character") }) {
      tips.append("Give each character a secret or conflicting agenda the finale can pay off.")
    }
    if loweredKeys.contains(where: { $0.contains("color") }) {
      tips.append("Tie your color palettes to emotional beats for deeper resonance.")
    }

    switch proposedOutput.commandName.lowercased() {
    case "strings":
      tips.append("Mix in playful localization variants—emoji, slang, or alternate cultural references keep it lively.")
    case "ib":
      tips.append("Experiment with storyboard flow—branching paths or nonlinear sequences can heighten drama.")
    default:
      break
    }

    if let highlight = proposedOutput.contextHighlights.first {
      tips.append("Spotlight \(" + highlight + ") by escalating the conflict or stakes around it in the next pass.")
    }

    if proposedOutput.outputDescription.lowercased().hasSuffix(".swift") {
      tips.append("Drop a TODO in the generated Swift to remind teammates where to riff on the mentor's twist.")
    }

    if tips.isEmpty {
      tips.append("Experiment with a bold narrative device—time jumps, unreliable narrators, or parallel timelines keep things electric.")
    }

    let unique = AIMentor.uniqueSuggestions(from: tips)
    return Array(unique.prefix(3))
  }
}

public extension AIMentor {
  static func makeOptionSignature(from dictionary: [String: Any]) -> [String] {
    dictionary.map { key, value in
      "\(key)=\(describe(value))"
    }.sorted()
  }

  static func makeParameterSignature(from dictionary: [String: Any]) -> [String] {
    dictionary.map { key, value in
      "\(key)=\(describe(value))"
    }.sorted()
  }

  static func makeParameterSignature(from tokens: [String]) -> [String] {
    tokens
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .filter { !$0.isEmpty }
      .sorted()
  }

  static func makeInputDigest(from inputs: [String]) -> String {
    guard !inputs.isEmpty else { return "(none)" }
    let condensed = inputs.map { input -> String in
      if let last = input.split(separator: "/").last {
        return String(last)
      } else {
        return input
      }
    }
    if condensed.count <= 3 {
      return condensed.joined(separator: ", ")
    } else {
      let head = condensed.prefix(2).joined(separator: ", ")
      return head + ", …, " + (condensed.last ?? "")
    }
  }
}

private extension AIMentor {
  static func uniqueSuggestions(from tips: [String]) -> [String] {
    var seen = Set<String>()
    var result: [String] = []
    for tip in tips where seen.insert(tip).inserted {
      result.append(tip)
    }
    return result
  }

  static func describe(_ value: Any) -> String {
    switch value {
    case let string as String:
      return string
    case let convertible as CustomStringConvertible:
      return convertible.description
    case let array as [Any]:
      let inner = array.map { describe($0) }.joined(separator: ", ")
      return "[" + inner + "]"
    case let dictionary as [String: Any]:
      let inner = dictionary
        .sorted(by: { $0.key < $1.key })
        .map { "\($0.key)=\(describe($0.value))" }
        .joined(separator: ", ")
      return "{" + inner + "}"
    case is NSNull:
      return "null"
    default:
      return String(describing: value)
    }
  }

  static func contextHighlights(from context: [String: Any]) -> [String] {
    var highlights: [String] = []
    for key in context.keys.sorted() {
      guard let value = context[key] else { continue }
      gatherHighlights(from: value, into: &highlights, limit: 3)
      if highlights.count >= 3 { break }
    }
    return highlights
  }

  static func gatherHighlights(from value: Any, into highlights: inout [String], limit: Int) {
    guard highlights.count < limit else { return }

    if let string = value as? String {
      appendHighlight(string, into: &highlights, limit: limit)
    } else if let number = value as? NSNumber {
      appendHighlight(number.stringValue, into: &highlights, limit: limit)
    } else if let array = value as? [Any] {
      for element in array {
        gatherHighlights(from: element, into: &highlights, limit: limit)
        if highlights.count >= limit { break }
      }
    } else if let dictionary = value as? [String: Any] {
      for key in dictionary.keys.sorted() {
        if let element = dictionary[key] {
          gatherHighlights(from: element, into: &highlights, limit: limit)
          if highlights.count >= limit { break }
        }
      }
    } else if let convertible = value as? CustomStringConvertible {
      appendHighlight(convertible.description, into: &highlights, limit: limit)
    }
  }

  static func appendHighlight(_ raw: String, into highlights: inout [String], limit: Int) {
    guard highlights.count < limit else { return }
    let collapsed = raw.replacingOccurrences(of: "\n", with: " ")
      .trimmingCharacters(in: .whitespacesAndNewlines)
    guard !collapsed.isEmpty else { return }
    let clipped = collapsed.count > 60 ? String(collapsed.prefix(57)) + "…" : collapsed
    if !highlights.contains(clipped) {
      highlights.append(clipped)
    }
  }
}
