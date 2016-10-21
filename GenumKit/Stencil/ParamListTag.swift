//
//  ParamListTag.swift
//  Pods
//
//  Created by Peter Livesey on 10/21/16.
//
//

import Foundation
import Stencil

//public class ParamListNode : NodeType {
//    public let variable: Variable
//
//    public class func parse(parser:TokenParser, token:Token) throws -> NodeType {
//        let components = token.components()
//        guard components.count == 2 else {
//            throw TemplateSyntaxError("'paramlist' statements should use the following 'paramlist variable' `\(token.contents)`.")
//        }
//        let variable = components[1]
//
//        return ParamListNode(variable: variable)
//    }
//
//    public init(variable: String) {
//        self.variable = Variable(variable)
//    }
//
//    public func render(context: Context) throws -> String {
//        let result = try variable.resolve(context)
//        
//        return try context.push {
//            return ["hi", "there"]
//        }
//    }
//}
