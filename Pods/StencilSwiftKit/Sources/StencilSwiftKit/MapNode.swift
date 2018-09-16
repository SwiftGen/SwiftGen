//
// StencilSwiftKit
// Copyright (c) 2017 Olivier Halligon
// Created by Peter Livesey.
// MIT Licence
//

import Stencil

class MapNode: NodeType {
  let resolvable: Resolvable
  let resultName: String
  let mapVariable: String?
  let nodes: [NodeType]
  let token: Token?

  class func parse(parser: TokenParser, token: Token) throws -> NodeType {
    let components = token.components()

    func hasToken(_ token: String, at index: Int) -> Bool {
      return components.indices ~= index + 1 && components[index] == token
    }

    func endsOrHasToken(_ token: String, at index: Int) -> Bool {
      return components.count == index || hasToken(token, at: index)
    }

    guard hasToken("into", at: 2) && endsOrHasToken("using", at: 4) else {
        throw TemplateSyntaxError("""
          'map' statements should use the following 'map {array} into \
          {varname} [using {element}]'.
          """)
    }

    let resolvable = try parser.compileResolvable(components[1], containedIn: token)
    let resultName = components[3]
    let mapVariable = hasToken("using", at: 4) ? components[5] : nil

    let mapNodes = try parser.parse(until(["endmap", "empty"]))

    guard let token = parser.nextToken() else {
      throw TemplateSyntaxError("`endmap` was not found.")
    }

    if token.contents == "empty" {
      _ = parser.nextToken()
    }

    return MapNode(
      resolvable: resolvable,
      resultName: resultName,
      mapVariable: mapVariable,
      nodes: mapNodes,
      token: token
    )
  }

  init(resolvable: Resolvable, resultName: String, mapVariable: String?, nodes: [NodeType], token: Token? = nil) {
    self.resolvable = resolvable
    self.resultName = resultName
    self.mapVariable = mapVariable
    self.nodes = nodes
    self.token = token
  }

  func render(_ context: Context) throws -> String {
    let values = try resolvable.resolve(context)

    if let values = values as? [Any], !values.isEmpty {
      let mappedValues: [String] = try values.enumerated().map { index, item in
        let mapContext = self.context(values: values, index: index, item: item)

        return try context.push(dictionary: mapContext) {
          try renderNodes(nodes, context)
        }
      }
      context[resultName] = mappedValues
    }

    // Map should never render anything
    return ""
  }

  func context(values: [Any], index: Int, item: Any) -> [String: Any] {
    var result: [String: Any] = [
      "maploop": [
        "counter": index,
        "first": index == 0,
        "last": index == (values.count - 1),
        "item": item
      ]
    ]

    if let mapVariable = mapVariable {
      result[mapVariable] = item
    }

    return result
  }
}
