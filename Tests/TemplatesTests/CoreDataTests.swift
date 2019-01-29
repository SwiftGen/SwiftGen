//
// Templates UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import StencilSwiftKit
import XCTest

class CoreDataTests: XCTestCase {
  enum Contexts {
    static let all = ["empty", "defaults"]
  }

  // generate variations to test customname generation
  let variations: VariationGenerator = { name, context in
    guard name == "defaults" else { return [(context: context, suffix: "")] }

    return [
      (context: context,
       suffix: ""),
      (context: try StencilContext.enrich(context: context, parameters: ["generateObjcName"]),
       suffix: "-generateObjcName"),
      (context: try StencilContext.enrich(context: context, parameters: ["publicAccess"]),
       suffix: "-publicAccess")
    ]
  }

  func testSwift3() {
    test(
      template: "swift3",
      contextNames: Contexts.all,
      directory: .coreData,
      contextVariations: variations
    )
  }

  func testSwift4() {
    test(
      template: "swift4",
      contextNames: Contexts.all,
      directory: .coreData,
      contextVariations: variations
    )
  }
}
