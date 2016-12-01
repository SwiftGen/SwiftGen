//
//  StrEqualsTag.swift
//  Pods
//
//  Created by Peter Livesey on 9/16/16.
//
//

import Foundation
import Stencil

public class StrEqualsNode: NodeType {
  public let lvariable: Variable
  public let rvariable: Variable
  public let trueNodes: [NodeType]
  public let falseNodes: [NodeType]

  public class func parse(parser: TokenParser, token: Token) throws -> NodeType {
    let components = token.components()
    guard components.count == 3 else {
      let error = "'ifstrequals' statements should use the following " +
      "'ifstrequals lvariable rvariable' `\(token.contents)`."
      throw TemplateSyntaxError(error)
    }
    let lvariable = components[1]
    let rvariable = components[2]
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

    return StrEqualsNode(lvariable: lvariable, rvariable: rvariable, trueNodes: trueNodes, falseNodes: falseNodes)
  }

  public class func parse_ifnotstrequals(parser: TokenParser, token: Token) throws -> NodeType {
    let components = token.components()
    guard components.count == 3 else {
      let error = "'ifnotstrequals' statements should use the following " +
      "'ifnotstrequals lvariable rvariable' `\(token.contents)`."
      throw TemplateSyntaxError(error)
    }
    let lvariable = components[1]
    let rvariable = components[2]
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

    return StrEqualsNode(lvariable: lvariable, rvariable: rvariable, trueNodes: trueNodes, falseNodes: falseNodes)
  }

  public init(lvariable: String, rvariable: String, trueNodes: [NodeType], falseNodes: [NodeType]) {
    self.lvariable = Variable(lvariable)
    self.rvariable = Variable(rvariable)
    self.trueNodes = trueNodes
    self.falseNodes = falseNodes
  }

  public func render(_ context: Context) throws -> String {
    let lResult = try lvariable.resolve(context)
    let rResult = try rvariable.resolve(context)
    var truthy = false

    if let lResult = lResult as? String, let rResult = rResult as? String {
      truthy = (lResult == rResult)
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
