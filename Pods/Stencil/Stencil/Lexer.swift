import Foundation

public struct Lexer {
  public let templateString:String
  let regex = try! NSRegularExpression(pattern: "(\\{\\{.*?\\}\\}|\\{%.*?%\\}|\\{#.*?#\\})", options: [])

  public init(templateString:String) {
    self.templateString = templateString
  }

  func createToken(string:String) -> Token {
    func strip() -> String {
      return string[string.startIndex.successor().successor()..<string.endIndex.predecessor().predecessor()].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
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
    // Unfortunately NSRegularExpression doesn't have a split.
    // So here's a really terrible implementation

    var tokens = [Token]()

    let range = NSMakeRange(0, templateString.characters.count)
    var lastIndex = 0
    let nsTemplateString = templateString as NSString
    let options = NSMatchingOptions(rawValue: 0)
    regex.enumerateMatchesInString(templateString, options: options, range: range) { (result, flags, b) in
      if let result = result {
        if result.range.location != lastIndex {
          let previousMatch = nsTemplateString.substringWithRange(NSMakeRange(lastIndex, result.range.location - lastIndex))
          tokens.append(self.createToken(previousMatch))
        }

        let match = nsTemplateString.substringWithRange(result.range)
        tokens.append(self.createToken(match))

        lastIndex = result.range.location + result.range.length
      }
    }

    if lastIndex < templateString.characters.count {
      let substring = (templateString as NSString).substringFromIndex(lastIndex)
      tokens.append(Token.Text(value: substring))
    }

    return tokens
  }
}
