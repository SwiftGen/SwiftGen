//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Stencil

public class MapNode: NodeType {
  let variable: Variable
  let mapVariable: String
  let resultName: String
  let nodes: [NodeType]

  public class func parse(parser: TokenParser, token: Token) throws -> NodeType {
    let components = token.components()

    guard components.count == 6 && components[2] == "with" && components[4] == "set" else {
      let error = "'map' statements should use the following " +
      "'map array with element set varname' `\(token.contents)`."
      throw TemplateSyntaxError(error)
    }

    let variable = components[1]
    let mapVariable = components[3]
    let resultName = components[5]

    let mapNodes = try parser.parse(until(["endmap", "empty"]))

    guard let token = parser.nextToken() else {
      throw TemplateSyntaxError("`endmap` was not found.")
    }

    if token.contents == "empty" {
      _ = parser.nextToken()
    }

    return MapNode(variable: variable, mapVariable: mapVariable, resultName: resultName, nodes: mapNodes)
  }

  public init(variable: String, mapVariable: String, resultName: String, nodes: [NodeType]) {
    self.variable = Variable(variable)
    self.mapVariable = mapVariable
    self.resultName = resultName
    self.nodes = nodes
  }

  public func render(_ context: Context) throws -> String {
    let values = try variable.resolve(context)

    if let values = values as? [Any], values.count > 0 {
      let mappedValues: [String] = try values.map { item in
        return try context.push(dictionary: [mapVariable: item]) {
          try renderNodes(nodes, context)
        }
      }
      context[resultName] = mappedValues
    }

    // Map should never render anything (no side effects)
    return ""
  }
}
