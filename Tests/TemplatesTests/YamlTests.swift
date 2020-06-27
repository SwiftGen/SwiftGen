//
// Templates UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import StencilSwiftKit
import XCTest

final class YamlTests: XCTestCase {
  private enum Contexts {
    static let all = ["empty", "all"]
  }

  // generate variations to test customname generation
  private let variations: VariationGenerator = { name, context in
    guard name == "all" else { return [(context: context, suffix: "")] }

    return [
      (
        context: context,
        suffix: ""
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["enumName=CustomYAML"]),
        suffix: "-customName"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["forceFileNameEnum"]),
        suffix: "-forceFileNameEnum"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["publicAccess"]),
        suffix: "-publicAccess"
      )
    ]
  }

  func testInlineSwift4() {
    test(
      template: "inline-swift4",
      contextNames: Contexts.all,
      directory: .yaml,
      contextVariations: variations
    )
  }

  func testInlineSwift5() {
    test(
      template: "inline-swift5",
      contextNames: Contexts.all,
      directory: .yaml,
      contextVariations: variations
    )
  }
}
