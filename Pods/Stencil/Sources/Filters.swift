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
