//
// Templates UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import StencilSwiftKit
import XCTest

class InterfaceBuilderTests: XCTestCase {
  enum Contexts {
    static let all = ["empty", "all"]
  }

  // swiftlint:disable:next closure_body_length
  private let commonVariations: VariationGenerator = { name, bareContext in
    guard name == "all" else { return [(context: bareContext, suffix: "")] }

    // Our target (for testing) is "SwiftGen"
    let context = try StencilContext.enrich(
      context: bareContext,
      parameters: [],
      environment: ["PRODUCT_MODULE_NAME": "SwiftGen"]
    )

    return [
      (
        context: context,
        suffix: ""
      ),

      // test: enumName parameter
      (
        context: try StencilContext.enrich(context: context, parameters: ["enumName=XCTStoryboardCustom"]),
        suffix: "-customName"
      ),

      // test: module parameter and PRODUCT_MODULE_NAME
      (
        context: bareContext,
        suffix: "-noDefinedModule"
      ),
      (
        context: try StencilContext.enrich(context: bareContext, parameters: ["module=SwiftGen"]),
        suffix: ""
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["module=ExtraModule"]),
        suffix: "-withExtraModule"
      ),

      // test: ignoreTargetModule parameter
      (
        context: try StencilContext.enrich(context: context, parameters: ["ignoreTargetModule"]),
        suffix: "-ignoreTargetModule"
      ),
      (
        context: try StencilContext.enrich(
          context: context,
          parameters: ["ignoreTargetModule"],
          environment: ["PRODUCT_MODULE_NAME": "Test"]
        ),
        suffix: "-noDefinedModule"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["ignoreTargetModule", "module=Test"]),
        suffix: "-ignoreTargetModule"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["ignoreTargetModule", "module=ExtraModule"]),
        suffix: "-ignoreTargetModule-withExtraModule"
      ),

      // test: publicAccess parameter
      (
        context: try StencilContext.enrich(context: context, parameters: ["publicAccess"]),
        suffix: "-publicAccess"
      )
    ]
  }

  private(set) lazy var sceneVariations: VariationGenerator = { name, bareContext in
    guard name == "all" else { return [(context: bareContext, suffix: "")] }

    // Our target (for testing) is "SwiftGen"
    let context = try StencilContext.enrich(
      context: bareContext,
      parameters: [],
      environment: ["PRODUCT_MODULE_NAME": "SwiftGen"]
    )

    return try self.commonVariations(name, bareContext) + [
      // test: bundle parameter
      (
        context: try StencilContext.enrich(context: context, parameters: ["bundle=ResourcesBundle.bundle"]),
        suffix: "-customBundle"
      ),

      // test: lookup function parameter
      (
        context: try StencilContext.enrich(
          context: context,
          parameters: ["lookupFunction=myStoryboardFinder(name:)"]
        ),
        suffix: "-lookupFunction"
      )
    ]
  }

  private(set) lazy var segueVariations: VariationGenerator = { name, bareContext in
    guard name == "all" else { return [(context: bareContext, suffix: "")] }

    return try self.commonVariations(name, bareContext)
  }
}
