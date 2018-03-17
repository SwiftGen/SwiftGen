struct Lexer {
  let templateString: String

  init(templateString: String) {
    self.templateString = templateString
  }

  func createToken(string: String) -> Token {
    func strip() -> String {
      guard string.characters.count > 4 else { return "" }
      let start = string.index(string.startIndex, offsetBy: 2)
      let end = string.index(string.endIndex, offsetBy: -2)
      return String(string[start..<end]).trim(character: " ")
    }

    if string.hasPrefix("{{") {
      return .variable(value: strip())
    } else if string.hasPrefix("{%") {
      return .block(value: strip())
    } else if string.hasPrefix("{#") {
      return .comment(value: strip())
    }

    return .text(value: string)
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
          tokens.append(createToken(string: text.1))
        }

        let end = map[text.0]!
        let result = scanner.scan(until: end, returnUntil: true)
        tokens.append(createToken(string: result))
      } else {
        tokens.append(createToken(string: scanner.content))
        scanner.content = ""
      }
    }

    return tokens
  }
}


class Scanner {
  var content: String

  init(_ content: String) {
    self.content = content
  }

  var isEmpty: Bool {
    return content.isEmpty
  }

  func scan(until: String, returnUntil: Bool = false) -> String {
    if until.isEmpty {
      return ""
    }

    var index = content.startIndex
    while index != content.endIndex {
      let substring = content.substring(from: index)

      if substring.hasPrefix(until) {
        let result = content.substring(to: index)
        content = substring

        if returnUntil {
          content = content.substring(from: until.endIndex)
          return result + until
        }

        return result
      }

      index = content.index(after: index)
    }

    content = ""
    return ""
  }

  func scan(until: [String]) -> (String, String)? {
    if until.isEmpty {
      return nil
    }

    var index = content.startIndex
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
}
