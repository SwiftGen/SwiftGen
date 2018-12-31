//
// Templates UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import StencilSwiftKit
import XCTest

class XCAssetsTests: XCTestCase {
  enum Contexts {
    static let all = ["empty", "all"]
  }

  // generate variations to test customname generation
  let variations: VariationGenerator = { name, context in
    guard name == "all" else { return [(context: context, suffix: "")] }

    return [
      (context: context,
       suffix: ""),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["enumName=XCTAssets",
                                                       "colorTypeName=XCTColorAsset",
                                                       "dataTypeName=XCTDataAsset",
                                                       "imageTypeName=XCTImageAsset",
                                                       "colorAliasName=XCTColor",
                                                       "dataAliasName=XCTData",
                                                       "imageAliasName=XCTImage"]),
       suffix: "-customname"),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["allValues"]),
       suffix: "-allValues"),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["publicAccess"]),
       suffix: "-publicAccess"),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["forceProvidesNamespaces"]),
       suffix: "-forceNamespaces")
    ]
  }

  func testSwift3() {
    test(template: "swift3",
         contextNames: Contexts.all,
         directory: .xcassets,
         contextVariations: variations)
  }

  func testSwift4() {
    test(template: "swift4",
         contextNames: Contexts.all,
         directory: .xcassets,
         contextVariations: variations)
  }
}
