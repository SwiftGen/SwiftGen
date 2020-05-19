//
// Templates UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import StencilSwiftKit
import XCTest

class ColorsTests: XCTestCase {
  enum Contexts {
    static let all = ["empty", "defaults", "multiple"]
  }

  // generate variations to test customname generation
  // swiftlint:disable opening_brace
  func variations(customName: String) -> VariationGenerator {
    { name, context in
      guard name == "defaults" else { return [(context: context, suffix: "")] }

      return [
        (
          context: context,
          suffix: ""
        ),
        (
          context: try StencilContext.enrich(
            context: context,
            parameters: ["enumName=\(customName)", "colorAliasName=XCTColor"]
          ),
          suffix: "-customName"
          ),
        (
          context: try StencilContext.enrich(context: context, parameters: ["publicAccess"]),
          suffix: "-publicAccess"
        )
      ]
    }
  }
  // swiftlint:enable opening_brace

  func testSwift4() {
    test(
      template: "swift4",
      contextNames: Contexts.all,
      directory: .colors,
      contextVariations: variations(customName: "XCTColors")
    )
  }

  func testSwift5() {
    test(
      template: "swift5",
      contextNames: Contexts.all,
      directory: .colors,
      contextVariations: variations(customName: "XCTColors")
    )
  }

  func testLiteralsSwift4() {
    test(
      template: "literals-swift4",
      contextNames: Contexts.all,
      directory: .colors,
      contextVariations: variations(customName: "UIColor")
    )
  }

  func testLiteralsSwift5() {
    test(
      template: "literals-swift5",
      contextNames: Contexts.all,
      directory: .colors,
      contextVariations: variations(customName: "UIColor")
    )
  }
}
