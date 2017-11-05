//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import StencilSwiftKit
import XCTest

class StoryboardsMacOSTests: XCTestCase {
  enum Contexts {
    static let all = ["empty", "all"]
  }

  // generate variations to test target module matching and custom enum names
  let variations: VariationGenerator = { name, context in
    guard name == "all" else { return [(context: context, suffix: "")] }

    return [
      (context: context,
       suffix: ""),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["sceneEnumName=XCTStoryboardsScene",
                                                       "segueEnumName=XCTStoryboardsSegue"]),
       suffix: "-customname"),
      (context: try StencilContext.enrich(context: context,
                                          parameters: [],
                                          environment: ["PRODUCT_MODULE_NAME": "Test"]),
       suffix: ""),
      (context: try StencilContext.enrich(context: context,
                                          parameters: [],
                                          environment: ["PRODUCT_MODULE_NAME": "FadeSegue"]),
       suffix: "-ignore-module"),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["module=Test"]),
       suffix: ""),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["module=FadeSegue"]),
       suffix: "-ignore-module"),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["ignoreTargetModule"],
                                          environment: ["PRODUCT_MODULE_NAME": "Test"]),
       suffix: ""),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["ignoreTargetModule"],
                                          environment: ["PRODUCT_MODULE_NAME": "PrefsWindowController"]),
       suffix: "-ignore-module-need-extra-definitions"),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["module=Test", "ignoreTargetModule"]),
       suffix: ""),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["module=PrefsWindowController", "ignoreTargetModule"]),
       suffix: "-ignore-module-need-extra-definitions"),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["publicAccess"]),
       suffix: "-publicAccess")
    ]
  }

  func testSwift2() {
    test(template: "swift2",
         contextNames: Contexts.all,
         directory: .storyboards,
         resourceDirectory: .storyboardsMacOS,
         contextVariations: variations)
  }

  func testSwift3() {
    test(template: "swift3",
         contextNames: Contexts.all,
         directory: .storyboards,
         resourceDirectory: .storyboardsMacOS,
         contextVariations: variations)
  }

  func testSwift4() {
    test(template: "swift4",
         contextNames: Contexts.all,
         directory: .storyboards,
         resourceDirectory: .storyboardsMacOS,
         contextVariations: variations)
  }
}
