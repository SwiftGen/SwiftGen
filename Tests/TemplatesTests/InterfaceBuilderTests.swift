//
//  InterfaceBuilderTestVariations.swift
//  Templates UnitTests
//
//  Created by David Jennes on 05/09/2018.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import StencilSwiftKit
import XCTest

class InterfaceBuilderTests: XCTestCase {
  enum Contexts {
    static let all = ["empty", "all"]
  }

  let variations: VariationGenerator = { name, bareContext in
    guard name == "all" else { return [(context: bareContext, suffix: "")] }

    // Our target (for testing) is "SwiftGen"
    let context = try StencilContext.enrich(context: bareContext,
                                            parameters: [],
                                            environment: ["PRODUCT_MODULE_NAME": "SwiftGen"])

    return [
      (
        context: context,
        suffix: ""
      ),

      // test: enumName parameter
      (
        context: try StencilContext.enrich(context: context,
                                           parameters: ["enumName=XCTStoryboardCustom"]),
        suffix: "-custom-name"
      ),

      // test: module parameter and PRODUCT_MODULE_NAME
      (
        context: bareContext,
        suffix: "-no-defined-module"
      ),
      (
        context: try StencilContext.enrich(context: bareContext,
                                           parameters: ["module=SwiftGen"]),
        suffix: ""
      ),
      (
        context: try StencilContext.enrich(context: context,
                                           parameters: ["module=ExtraModule"]),
        suffix: "-with-extra-module"
      ),

      // test: ignoreTargetModule parameter
      (
        context: try StencilContext.enrich(context: context,
                                           parameters: ["ignoreTargetModule"]),
        suffix: "-ignore-target-module"
      ),
      (
        context: try StencilContext.enrich(context: context,
                                           parameters: ["ignoreTargetModule"],
                                           environment: ["PRODUCT_MODULE_NAME": "Test"]),
        suffix: "-no-defined-module"
      ),
      (
        context: try StencilContext.enrich(context: context,
                                           parameters: ["ignoreTargetModule", "module=Test"]),
        suffix: "-ignore-target-module"
      ),
      (
        context: try StencilContext.enrich(context: context,
                                           parameters: ["ignoreTargetModule", "module=ExtraModule"]),
        suffix: "-ignore-target-module-with-extra-module"
      ),

      // test: publicAccess parameter
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["publicAccess"]),
       suffix: "-public-access")
    ]
  }
}
