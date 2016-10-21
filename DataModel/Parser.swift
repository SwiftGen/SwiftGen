//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation

struct Parser {
  let dictionary: [String: Any]?

  init(dictionary: [String: Any]?) {
    self.dictionary = dictionary
  }

  func fetch<T: DataConvertible>(_ key: String) throws -> T {
    let fetchedOptional = dictionary?[key]
    guard let fetched = fetchedOptional else  {
      throw ParserError(message: "The key '\(key)' was not found.")
    }
    return try T.parsed(data: fetched)
  }

  func fetch<T: DataConvertible>(_ key: String) throws -> T? {
    let fetchedOptional = dictionary?[key]
    guard let fetched = fetchedOptional else {
      return nil
    }
    return try T.parsed(data: fetched)
  }

  func fetch<T: DataConvertible>(_ key: String) throws -> [T] {
    let fetchedOptional = dictionary?[key]
    guard let fetched = fetchedOptional else {
      throw ParserError(message: "The key '\(key)' was not found.")
    }
    if let fetchedArray = fetched as? [AnyObject] {
      return try fetchedArray.map { try T.parsed(data: $0) }
    } else {
      throw ParserError(message: "The key '\(key)' was not found.")
    }
  }

  func fetch<T: DataConvertible>(_ key: String) throws -> [T]? {
    let fetchedOptional = dictionary?[key]
    guard let fetched = fetchedOptional else {
      return nil
    }
    if let fetchedArray = fetched as? [AnyObject] {
      return try fetchedArray.map { try T.parsed(data: $0) }
    } else {
      throw ParserError(message: "The key '\(key)' was not found.")
    }
  }
}

struct ParserError: ErrorType {
  let message: String
}

