//
// StencilSwiftKit
// Copyright (c) 2017 Olivier Halligon
// Created by Peter Livesey.
// MIT Licence
//

import Stencil

class MapNode: NodeType {
  let variable: Variable
  let resultName: String
  let mapVariable: String?
  let nodes: [NodeType]

  class func parse(parser: TokenParser, token: Token) throws -> NodeType {
    let components = token.components()

    guard components.count == 4 && components[2] == "into" ||
      components.count == 6 && components[2] == "into" && components[4] == "using" else {
        let error = "'map' statements should use the following " +
        "'map {array} into {varname} [using {element}]' `\(token.contents)`."
        throw TemplateSyntaxError(error)
    }

    let variable = components[1]
    let resultName = components[3]
    var mapVariable: String? = nil
    if components.count > 4 {
      mapVariable = components[5]
    }

    let mapNodes = try parser.parse(until(["endmap", "empty"]))

    guard let token = parser.nextToken() else {
      throw TemplateSyntaxError("`endmap` was not found.")
    }

    if token.contents == "empty" {
      _ = parser.nextToken()
    }

    return MapNode(variable: variable, resultName: resultName, mapVariable: mapVariable, nodes: mapNodes)
  }

  init(variable: String, resultName: String, mapVariable: String?, nodes: [NodeType]) {
    self.variable = Variable(variable)
    self.resultName = resultName
    self.mapVariable = mapVariable
    self.nodes = nodes
  }

  func render(_ context: Context) throws -> String {
    let values = try variable.resolve(context)

    if let values = values as? [Any], values.count > 0 {
      let mappedValues: [String] = try values.enumerated().map { (index, item) in
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
