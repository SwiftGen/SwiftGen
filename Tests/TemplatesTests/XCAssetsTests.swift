//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
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
                                                       "imageTypeName=XCTImageAsset",
                                                       "dataTypeName=XCTDataAsset",
                                                       "colorAliasName=XCTColor",
                                                       "imageAliasName=XCTImage",
                                                       "dataAliasName=XCTData"]),
       suffix: "-customname"),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["noAllValues"]),
       suffix: "-no-all-values"),
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
