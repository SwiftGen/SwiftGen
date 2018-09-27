public class TemplateDoesNotExist: Error, CustomStringConvertible {
  let templateNames: [String]
  let loader: Loader?

  public init(templateNames: [String], loader: Loader? = nil) {
    self.templateNames = templateNames
    self.loader = loader
  }

  public var description: String {
    let templates = templateNames.joined(separator: ", ")

    if let loader = loader {
      return "Template named `\(templates)` does not exist in loader \(loader)"
    }

    return "Template named `\(templates)` does not exist. No loaders found"
  }
}

public struct TemplateSyntaxError : Error, Equatable, CustomStringConvertible {
  public let reason: String
  public var description: String { return reason }
  public internal(set) var token: Token?
  public internal(set) var stackTrace: [Token]
  public var templateName: String? { return token?.sourceMap.filename }
  var allTokens: [Token] {
    return stackTrace + (token.map({ [$0] }) ?? [])
  }

  public init(reason: String, token: Token? = nil, stackTrace: [Token] = []) {
    self.reason = reason
    self.stackTrace = stackTrace
    self.token = token
  }

  public init(_ description: String) {
    self.init(reason: description)
  }
}

extension Error {
  func withToken(_ token: Token?) -> Error {
    if var error = self as? TemplateSyntaxError {
      error.token = error.token ?? token
      return error
    } else {
      return TemplateSyntaxError(reason: "\(self)", token: token)
    }
  }
}

public protocol ErrorReporter: class {
  func renderError(_ error: Error) -> String
}

open class SimpleErrorReporter: ErrorReporter {

  open func renderError(_ error: Error) -> String {
    guard let templateError = error as? TemplateSyntaxError else { return error.localizedDescription }

    func describe(token: Token) -> String {
      let templateName = token.sourceMap.filename ?? ""
      let location = token.sourceMap.location
      let highlight = """
        \(String(Array(repeating: " ", count: location.lineOffset)))\
        ^\(String(Array(repeating: "~", count: max(token.contents.count - 1, 0))))
        """

      return """
        \(templateName)\(location.lineNumber):\(location.lineOffset): error: \(templateError.reason)
        \(location.content)
        \(highlight)
        """
    }

    var descriptions = templateError.stackTrace.reduce([]) { $0 + [describe(token: $1)] }
    let description = templateError.token.map(describe(token:)) ?? templateError.reason
    descriptions.append(description)
    return descriptions.joined(separator: "\n")
  }

}
