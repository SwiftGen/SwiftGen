func toString(_ value: Any?) -> String? {
  if let value = value as? String {
    return value
  } else if let value = value as? CustomStringConvertible {
    return value.description
  }

  return nil
}

func capitalise(_ value: Any?) -> Any? {
  if let value = toString(value) {
    return value.capitalized
  }

  return value
}

func uppercase(_ value: Any?) -> Any? {
  if let value = toString(value) {
    return value.uppercased()
  }

  return value
}

func lowercase(_ value: Any?) -> Any? {
  if let value = toString(value) {
    return value.lowercased()
  }

  return value
}

func defaultFilter(value: Any?, arguments: [Any?]) -> Any? {
  if let value = value {
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
  guard arguments.count == 1 else {
    throw TemplateSyntaxError("'join' filter takes a single argument")
  }

  guard let separator = arguments.first as? String else {
    throw TemplateSyntaxError("'join' filter takes a separator as string")
  }

  if let value = value as? [String] {
    return value.joined(separator: separator)
  }

  return nil
}
