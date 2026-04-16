//
// Templates UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

import StencilSwiftKit
import TestUtils
import XCTest

final class StringsCatalogTests: XCTestCase {
  private enum Contexts {
    static let all = [
      "empty",
      "localizable",
      "multiple",
      "plurals",
      "plurals-advanced"
    ]
  }

  // generate variations to test customname generation
  // swiftlint:disable:next closure_body_length
  private let variations: VariationGenerator = { name, context in
    guard name == "localizable" else { return [(context: context, suffix: "")] }

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
        context: try StencilContext.enrich(context: context, parameters: ["enumName=XCTLoc"]),
        suffix: "-customName"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["forceFileNameEnum"]),
        suffix: "-forceFileNameEnum"
      ),
      (
        context: try StencilContext.enrich(
          context: context,
          parameters: ["lookupFunction=XCTLocFunc(forKey:table:fallback:)"]
        ),
        suffix: "-lookupFunction"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["noComments"]),
        suffix: "-noComments"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["publicAccess"]),
        suffix: "-publicAccess"
      )
    ]
  }

  func testFlatSwift5() {
    test(
      template: "flat-swift5",
      contextNames: Contexts.all,
      directory: .strings,
      resourceDirectory: .stringsCatalog,
      contextVariations: variations
    )
  }

  func testStructuredSwift5() {
    test(
      template: "structured-swift5",
      contextNames: Contexts.all,
      directory: .strings,
      resourceDirectory: .stringsCatalog,
      contextVariations: variations
    )
  }
}
