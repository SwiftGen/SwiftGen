//
// Templates UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import StencilSwiftKit
import XCTest

final class XCAssetsTests: XCTestCase {
  private enum Contexts {
    static let all = ["empty", "all", "food"]
  }

  // generate variations to test customname generation
  // swiftlint:disable:next closure_body_length
  private let variations: VariationGenerator = { name, context in
    guard name == "all" else { return [(context: context, suffix: "")] }

    return [
      (
        context: context,
        suffix: ""
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["allValues"]),
        suffix: "-allValues"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["bundle=ResourcesBundle.bundle"]),
        suffix: "-customBundle"
      ),
      (
        context: try StencilContext.enrich(
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
        suffix: "-customName"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["forceFileNameEnum"]),
        suffix: "-forceFileNameEnum"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["forceProvidesNamespaces"]),
        suffix: "-forceNamespaces"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["publicAccess"]),
        suffix: "-publicAccess"
      )
    ]
  }

  func testSwift4() {
    test(
      template: "swift4",
      contextNames: Contexts.all,
      directory: .xcassets,
      contextVariations: variations
    )
  }

  func testSwift5() {
    test(
      template: "swift5",
      contextNames: Contexts.all,
      directory: .xcassets,
      contextVariations: variations
    )
  }
}
