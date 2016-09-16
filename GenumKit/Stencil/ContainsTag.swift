//
//  ContainsTag.swift
//  Pods
//
//  Created by Peter Livesey on 9/16/16.
//
//

import Foundation
import Stencil

public class ContainsNode : NodeType {
  public let array: Variable
  public let variable: Variable
  public let trueNodes: [NodeType]
  public let falseNodes: [NodeType]

  public class func parse(parser:TokenParser, token:Token) throws -> NodeType {
    let components = token.components()
    guard components.count == 3 else {
      throw TemplateSyntaxError("'ifcontains' statements should use the following 'ifcontains array variable' `\(token.contents)`.")
    }
    let array = components[1]
    let variable = components[2]
    var trueNodes = [NodeType]()
    var falseNodes = [NodeType]()

    trueNodes = try parser.parse(until(["endif", "else"]))

    guard let token = parser.nextToken() else {
      throw TemplateSyntaxError("`endif` was not found.")
    }

    if token.contents == "else" {
      falseNodes = try parser.parse(until(["endif"]))
      parser.nextToken()
    }

    return ContainsNode(array: array, variable: variable, trueNodes: trueNodes, falseNodes: falseNodes)
  }

  public class func parse_ifnotcontains(parser:TokenParser, token:Token) throws -> NodeType {
    let components = token.components()
    guard components.count == 3 else {
      throw TemplateSyntaxError("'ifnotcontains' statements should use the following 'ifnotcontains array variable' `\(token.contents)`.")
    }
    let array = components[1]
    let variable = components[2]
    var trueNodes = [NodeType]()
    var falseNodes = [NodeType]()

    falseNodes = try parser.parse(until(["endif", "else"]))

    guard let token = parser.nextToken() else {
      throw TemplateSyntaxError("`endif` was not found.")
    }

    if token.contents == "else" {
      trueNodes = try parser.parse(until(["endif"]))
      parser.nextToken()
    }

    return ContainsNode(array: array, variable: variable, trueNodes: trueNodes, falseNodes: falseNodes)
  }

  public init(array: String, variable:String, trueNodes:[NodeType], falseNodes:[NodeType]) {
    self.array = Variable(array)
    self.variable = Variable(variable)
    self.trueNodes = trueNodes
    self.falseNodes = falseNodes
  }

  public func render(context: Context) throws -> String {
    let result = try variable.resolve(context)
    let arrayResult = try array.resolve(context)
    var truthy = false

    if let arrayResult = arrayResult as? [Any] {
      truthy = arrayResult.contains {
        if let element = $0 as? String, let result = result as? String {
          return element == result
        } else {
          return false
        }
      }
    }

    return try context.push {
      if truthy {
        return try renderNodes(trueNodes, context)
      } else {
        return try renderNodes(falseNodes, context)
      }
    }
  }
}
