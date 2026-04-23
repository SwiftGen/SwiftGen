//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import StencilSwiftKit
import XCTest

class IdentifiersMacOSTests: XCTestCase {
  enum Contexts {
    static let all = ["empty", "all"]
  }

  let variations: VariationGenerator = { name, context in
    guard name == "all" else { return [(context: context, suffix: "")] }

    return [
      (context: context, suffix: ""),
      (context: try StencilContext.enrich(context: context, parameters: ["publicAccess"]), suffix: "-publicAccess")
    ]
  }

  func testEnums() {
    test(template: "enums",
         contextNames: Contexts.all,
         directory: .identifiers,
         resourceDirectory: .identifiersMacOS,
         contextVariations: variations)
  }

  func testProperties() {
    test(template: "properties",
         contextNames: Contexts.all,
         directory: .identifiers,
         resourceDirectory: .identifiersMacOS,
         contextVariations: variations)
  }
}
