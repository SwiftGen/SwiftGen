//
// Templates UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import StencilSwiftKit
import XCTest

class ResourcesTests: XCTestCase {
  enum Contexts {
    static let all = ["empty", "defaults"]
  }

  func variations() -> VariationGenerator {
    return { name, context in
      guard name == "defaults" else { return [(context: context, suffix: "")] }

      return [
        (context: context,
         suffix: "")
      ]
    }
  }

  func testSwift5() {
    test(
      template: "swift5",
      contextNames: Contexts.all,
      directory: .resources,
      contextVariations: variations()
    )
  }
}
