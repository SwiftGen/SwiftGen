//
// Templates UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import StencilSwiftKit
import XCTest

class XCAssetsTests: XCTestCase {
  enum Contexts {
    static let all = ["empty", "all", "food"]
  }

  // generate variations to test customname generation
  // swiftlint:disable:next closure_body_length
  let variations: VariationGenerator = { name, context in
    guard name == "all" else { return [(context: context, suffix: "")] }

    return [
      (context: context,
       suffix: ""),
      (context: try StencilContext.enrich(
        context: context,
        parameters: [
          "enumName=XCTAssets",
          "arResourceGroupTypeName=XCTARResourceGroup",
          "colorTypeName=XCTColorAsset",
          "dataTypeName=XCTDataAsset",
          "imageTypeName=XCTImageAsset",
          // deprecated parameters
          "colorAliasName=XCTColor",
          "imageAliasName=XCTImage"
        ]
       ),
       suffix: "-customName"),
      (context: try StencilContext.enrich(context: context, parameters: ["allValues"]),
       suffix: "-allValues"),
      (context: try StencilContext.enrich(context: context, parameters: ["publicAccess"]),
       suffix: "-publicAccess"),
      (context: try StencilContext.enrich(context: context, parameters: ["forceProvidesNamespaces"]),
       suffix: "-forceNamespaces")
    ]
  }

  func testSwift3() {
    test(
      template: "swift3",
      contextNames: Contexts.all,
      directory: .xcassets,
      contextVariations: variations
    )
  }

  func testSwift4() {
    test(
      template: "swift4",
      contextNames: Contexts.all,
      directory: .xcassets,
      contextVariations: variations
    )
  }
}
