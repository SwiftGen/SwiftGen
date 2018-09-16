import Foundation

struct Lexer {
  let templateName: String?
  let templateString: String

  init(templateName: String? = nil, templateString: String) {
    self.templateName = templateName
    self.templateString = templateString
  }

  func createToken(string: String, at range: Range<String.Index>) -> Token {
    func strip() -> String {
      guard string.characters.count > 4 else { return "" }
      let start = string.index(string.startIndex, offsetBy: 2)
      let end = string.index(string.endIndex, offsetBy: -2)
      let trimmed = String(string[start..<end])
        .components(separatedBy: "\n")
        .filter({ !$0.isEmpty })
        .map({ $0.trim(character: " ") })
        .joined(separator: " ")
      return trimmed
    }

    if string.hasPrefix("{{") || string.hasPrefix("{%") || string.hasPrefix("{#") {
      let value = strip()
      let range = templateString.range(of: value, range: range) ?? range
      let line = templateString.rangeLine(range)
      let sourceMap = SourceMap(filename: templateName, line: line)

      if string.hasPrefix("{{") {
        return .variable(value: value, at: sourceMap)
      } else if string.hasPrefix("{%") {
        return .block(value: value, at: sourceMap)
      } else if string.hasPrefix("{#") {
        return .comment(value: value, at: sourceMap)
      }
    }

    let line = templateString.rangeLine(range)
    let sourceMap = SourceMap(filename: templateName, line: line)
    return .text(value: string, at: sourceMap)
  }

  /// Returns an array of tokens from a given template string.
  func tokenize() -> [Token] {
    var tokens: [Token] = []

    let scanner = Scanner(templateString)

    let map = [
      "{{": "}}",
      "{%": "%}",
      "{#": "#}",
      ]

    while !scanner.isEmpty {
      if let text = scanner.scan(until: ["{{", "{%", "{#"]) {
        if !text.1.isEmpty {
          tokens.append(createToken(string: text.1, at: scanner.range))
        }

        let end = map[text.0]!
        let result = scanner.scan(until: end, returnUntil: true)
        tokens.append(createToken(string: result, at: scanner.range))
      } else {
        tokens.append(createToken(string: scanner.content, at: scanner.range))
        scanner.content = ""
      }
    }

    return tokens
  }

}

class Scanner {
  let originalContent: String
  var content: String
  var range: Range<String.Index>

  init(_ content: String) {
    self.originalContent = content
    self.content = content
    range = content.startIndex..<content.startIndex
  }

  var isEmpty: Bool {
    return content.isEmpty
  }

  func scan(until: String, returnUntil: Bool = false) -> String {
    var index = content.startIndex

    if until.isEmpty {
      return ""
    }

    range = range.upperBound..<range.upperBound
    while index != content.endIndex {
      let substring = content.substring(from: index)

      if substring.hasPrefix(until) {
        let result = content.substring(to: index)

        if returnUntil {
          range = range.lowerBound..<originalContent.index(range.upperBound, offsetBy: until.characters.count)
          content = substring.substring(from: until.endIndex)
          return result + until
        }

        content = substring
        return result
      }

      index = content.index(after: index)
      range = range.lowerBound..<originalContent.index(after: range.upperBound)
    }

    content = ""
    return ""
  }

  func scan(until: [String]) -> (String, String)? {
    if until.isEmpty {
      return nil
    }

    var index = content.startIndex
    range = range.upperBound..<range.upperBound
    while index != content.endIndex {
      let substring = content.substring(from: index)
      for string in until {
        if substring.hasPrefix(string) {
          let result = content.substring(to: index)
          content = substring
          return (string, result)
        }
      }

      index = content.index(after: index)
      range = range.lowerBound..<originalContent.index(after: range.upperBound)
    }

    return nil
  }
}


extension String {
  func findFirstNot(character: Character) -> String.Index? {
    var index = startIndex

    while index != endIndex {
      if character != self[index] {
        return index
      }
      index = self.index(after: index)
    }

    return nil
  }

  func findLastNot(character: Character) -> String.Index? {
    var index = self.index(before: endIndex)

    while index != startIndex {
      if character != self[index] {
        return self.index(after: index)
      }
      index = self.index(before: index)
    }

    return nil
  }

  func trim(character: Character) -> String {
    let first = findFirstNot(character: character) ?? startIndex
    let last = findLastNot(character: character) ?? endIndex
    return String(self[first..<last])
  }

  public func rangeLine(_ range: Range<String.Index>) -> RangeLine {
    var lineNumber: UInt = 0
    var offset: Int = 0
    var lineContent = ""

    for line in components(separatedBy: CharacterSet.newlines) {
      lineNumber += 1
      lineContent = line
      if let rangeOfLine = self.range(of: line), rangeOfLine.contains(range.lowerBound) {
        offset = distance(from: rangeOfLine.lowerBound, to: range.lowerBound)
        break
      }
    }

    return (lineContent, lineNumber, offset)
  }
}

public typealias RangeLine = (content: String, number: UInt, offset: Int)
