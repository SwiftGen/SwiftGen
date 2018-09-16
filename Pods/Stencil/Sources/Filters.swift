func capitalise(_ value: Any?) -> Any? {
  if let array = value as? [Any?] {
    return array.map { stringify($0).capitalized }
  } else {
    return stringify(value).capitalized
  }
}

func uppercase(_ value: Any?) -> Any? {
  if let array = value as? [Any?] {
    return array.map { stringify($0).uppercased() }
  } else {
    return stringify(value).uppercased()
  }
}

func lowercase(_ value: Any?) -> Any? {
  if let array = value as? [Any?] {
    return array.map { stringify($0).lowercased() }
  } else {
    return stringify(value).lowercased()
  }
}

func defaultFilter(value: Any?, arguments: [Any?]) -> Any? {
  // value can be optional wrapping nil, so this way we check for underlying value
  if let value = value, String(describing: value) != "nil" {
    return value
  }

  for argument in arguments {
    if let argument = argument {
      return argument
    }
  }

  return nil
}

func joinFilter(value: Any?, arguments: [Any?]) throws -> Any? {
  guard arguments.count < 2 else {
    throw TemplateSyntaxError("'join' filter takes a single argument")
  }

  let separator = stringify(arguments.first ?? "")

  if let value = value as? [Any] {
    return value
      .map(stringify)
      .joined(separator: separator)
  }

  return value
}

func splitFilter(value: Any?, arguments: [Any?]) throws -> Any? {
  guard arguments.count < 2 else {
    throw TemplateSyntaxError("'split' filter takes a single argument")
  }

  let separator = stringify(arguments.first ?? " ")
  if let value = value as? String {
    return value.components(separatedBy: separator)
  }

  return value
}

func indentFilter(value: Any?, arguments: [Any?]) throws -> Any? {
  guard arguments.count <= 3 else {
    throw TemplateSyntaxError("'indent' filter can take at most 3 arguments")
  }

  var indentWidth = 4
  if arguments.count > 0 {
    guard let value = arguments[0] as? Int else {
      throw TemplateSyntaxError("'indent' filter width argument must be an Integer (\(String(describing: arguments[0])))")
    }
    indentWidth = value
  }

  var indentationChar = " "
  if arguments.count > 1 {
    guard let value = arguments[1] as? String else {
      throw TemplateSyntaxError("'indent' filter indentation argument must be a String (\(String(describing: arguments[1]))")
    }
    indentationChar = value
  }

  var indentFirst = false
  if arguments.count > 2 {
    guard let value = arguments[2] as? Bool else {
      throw TemplateSyntaxError("'indent' filter indentFirst argument must be a Bool")
    }
    indentFirst = value
  }

  let indentation = [String](repeating: indentationChar, count: indentWidth).joined(separator: "")
  return indent(stringify(value), indentation: indentation, indentFirst: indentFirst)
}


func indent(_ content: String, indentation: String, indentFirst: Bool) -> String {
  guard !indentation.isEmpty else { return content }

  var lines = content.components(separatedBy: .newlines)
  let firstLine = (indentFirst ? indentation : "") + lines.removeFirst()
  let result = lines.reduce([firstLine]) { (result, line) in
    return result + [(line.isEmpty ? "" : "\(indentation)\(line)")]
  }
  return result.joined(separator: "\n")
}

