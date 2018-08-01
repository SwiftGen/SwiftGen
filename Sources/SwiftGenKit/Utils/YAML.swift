//
//  YAML.swift
//  SwiftGenKit
//
//  Created by David Jennes on 30/07/2018.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import PathKit
import Yams

public enum YAML {
  /// Read the contents of a YAML file located at the given path (only the first document).
  ///
  /// - parameter path: The path to the YAML file
  /// - returns: The decoded document
  public static func read(path: Path) throws -> Any? {
    let contents: String = try path.read()
    return try decode(string: contents)
  }

  /// Decode the contents of YAML string (only the first document).
  ///
  /// - parameter string: The YAML string
  /// - returns: The decoded document
  public static func decode(string: String) throws -> Any? {
    return try Yams.load(yaml: string)
  }

  /// Encode the given object to YAML and write it to the given path
  ///
  /// - parameter object: The object to encode
  /// - parameter path: The path to the output file
  public static func write(object: Any, to path: Path) throws {
    let string = try encode(object: object)
    try path.write(string)
  }

  /// Encode the given object to YAML and return it as a string
  ///
  /// - parameter object: The object to encode
  /// - returns: The encoded YAML string
  public static func encode(object: Any) throws -> String {
    let node = try represent(object: object)
    return try Yams.serialize(node: node)
  }

  private static func represent(object: Any) throws -> Node {
    switch object {
    case let string as String:
      return Node(string, .implicit, .doubleQuoted)
    case let array as [Any]:
      return Node(try array.map(represent), Tag(.seq))
    case let dictionary as [String: Any]:
      let pairs = try dictionary.map { (Node($0.key), try represent(object: $0.value)) }
      return Node(pairs.sorted { $0.0 < $1.0 }, Tag(.map))
    case let representable as NodeRepresentable:
      return try representable.represented()
    default:
      throw YamlError.representer(problem: "Failed to represent \(object) as a Yams.Node")
    }
  }
}
