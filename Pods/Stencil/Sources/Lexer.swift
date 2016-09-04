public struct Lexer {
  public let templateString: String

  public init(templateString: String) {
    self.templateString = templateString
  }

  func createToken(string:String) -> Token {
    func strip() -> String {
      return string[string.startIndex.successor().successor()..<string.endIndex.predecessor().predecessor()].trim(" ")
    }

    if string.hasPrefix("{{") {
      return Token.Variable(value: strip())
    } else if string.hasPrefix("{%") {
      return Token.Block(value: strip())
    } else if string.hasPrefix("{#") {
      return Token.Comment(value: strip())
    }

    return Token.Text(value: string)
  }

  /// Returns an array of tokens from a given template string.
  public func tokenize() -> [Token] {
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
          tokens.append(createToken(text.1))
        }

        let end = map[text.0]!
        let result = scanner.scan(until: end, returnUntil: true)
        tokens.append(createToken(result))
      } else {
        tokens.append(createToken(scanner.content))
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

  func scan(until until: String, returnUntil: Bool = false) -> String {
    if until.isEmpty {
      return ""
    }

    var index = content.startIndex
    while index != content.endIndex {
      let substring = content.substringFromIndex(index)
      if substring.hasPrefix(until) {
        let result = content.substringToIndex(index)
        content = substring

        if returnUntil {
          content = content.substringFromIndex(until.endIndex)
          return result + until
        }

        return result
      }

      index = index.successor()
    }

    return ""
  }

  func scan(until until: [String]) -> (String, String)? {
    if until.isEmpty {
      return nil
    }

    var index = content.startIndex
    while index != content.endIndex {
      let substring = content.substringFromIndex(index)
      for string in until {
        if substring.hasPrefix(string) {
          let result = content.substringToIndex(index)
          content = substring
          return (string, result)
        }
      }

      index = index.successor()
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
      index = index.successor()
    }

    return nil
  }

  func findLastNot(character: Character) -> String.Index? {
    var index = endIndex.predecessor()
    while index != startIndex {
      if character != self[index] {
        return index.successor()
      }
      index = index.predecessor()
    }

    return nil
  }

  func trim(character: Character) -> String {
    let first = findFirstNot(character) ?? startIndex
    let last = findLastNot(character) ?? endIndex
    return self[first..<last]
  }
}
