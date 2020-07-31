//
// Templates UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import StencilSwiftKit
import XCTest

final class FontsTests: XCTestCase {
  private enum Contexts {
    static let all = ["empty", "defaults"]
  }

  // generate variations to test customname generation
  // swiftlint:disable:next closure_body_length
  private let variations: VariationGenerator = { name, context in
    guard name == "defaults" else { return [(context: context, suffix: "")] }

    return [
      (
        context: context,
        suffix: ""
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["bundle=ResourcesBundle.bundle"]),
        suffix: "-customBundle"
      ),
      (
        context: try StencilContext.enrich(
          context: context,
          parameters: [
            "enumName=CustomFamily",
            "fontTypeName=MyFontConvertible",
            "fontAliasName=MyFont"
          ]
        ),
        suffix: "-customName"
      ),
      (
        context: try StencilContext.enrich(
          context: context,
          parameters: ["lookupFunction=myFontFinder(name:family:path:)"]
        ),
        suffix: "-lookupFunction"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["preservePath"]),
        suffix: "-preservePath"
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
      directory: .fonts,
      contextVariations: variations
    )
  }

  func testSwift5() {
    test(
      template: "swift5",
      contextNames: Contexts.all,
      directory: .fonts,
      contextVariations: variations
    )
  }
}
