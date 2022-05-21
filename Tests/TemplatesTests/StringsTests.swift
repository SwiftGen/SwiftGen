//
// Templates UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import StencilSwiftKit
import TestUtils
import XCTest

final class StringsTests: XCTestCase {
  private enum Contexts {
    static let all = [
      "empty",
      "localizable",
      "multiple",
      "plurals",
      "plurals-same-table",
      "plurals-advanced",
      "plurals-unsupported"
    ]
  }

  // generate variations to test customname generation
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
          parameters: ["lookupFunction=XCTLocFunc(forKey:table:)"]
        ),
        suffix: "-lookupFunction"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["noComments"]),
        suffix: "-noComments"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["stringLocale"]),
        suffix: "-stringLocale"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["publicAccess"]),
        suffix: "-publicAccess"
      )
    ]
  }

  private let variationsObjC: VariationGenerator = { name, context in
    guard name == "localizable" else { return [(context: context, suffix: "")] }

    return [
      (
        context: context,
        suffix: ""
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["bundle=[ResourcesBundle bundle]"]),
        suffix: "-customBundle"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["stringLocale"]),
        suffix: "-stringLocale"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["noComments"]),
        suffix: "-noComments"
      ),
      (
        context: try StencilContext.enrich(context: context, parameters: ["headerName=headerName-from-parameter.h"]),
        suffix: "-headerName"
      )
    ]
  }

  func testFlatSwift4() {
    test(
      template: "flat-swift4",
      contextNames: Contexts.all,
      directory: .strings,
      contextVariations: variations
    )
  }

  func testFlatSwift5() {
    test(
      template: "flat-swift5",
      contextNames: Contexts.all,
      directory: .strings,
      contextVariations: variations
    )
  }

  func testStructuredSwift4() {
    test(
      template: "structured-swift4",
      contextNames: Contexts.all,
      directory: .strings,
      contextVariations: variations
    )
  }

  func testStructuredSwift5() {
    test(
      template: "structured-swift5",
      contextNames: Contexts.all,
      directory: .strings,
      contextVariations: variations
    )
  }

  func testObjectiveCHeader() {
    test(
      template: "objc-h",
      contextNames: Contexts.all,
      directory: .strings,
      contextVariations: variationsObjC,
      outputExtension: "h"
    )
  }

  func testObjectiveCSource() {
    test(
      template: "objc-m",
      contextNames: Contexts.all,
      directory: .strings,
      contextVariations: variationsObjC,
      outputExtension: "m"
    )
  }
}
