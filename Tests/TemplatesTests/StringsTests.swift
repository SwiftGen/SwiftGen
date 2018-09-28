//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import StencilSwiftKit
import XCTest

class StringsTests: XCTestCase {
  enum Contexts {
    static let all = ["empty", "localizable", "multiple"]
  }

  // generate variations to test customname generation
  let variations: VariationGenerator = { name, context in
    guard name == "localizable" else { return [(context: context, suffix: "")] }

    return [
      (context: context,
       suffix: ""),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["enumName=XCTLoc"]),
       suffix: "-customname"),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["noComments"]),
       suffix: "-no-comments"),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["publicAccess"]),
       suffix: "-publicAccess")
    ]
  }

  let flatSwiftObjCCompatibleVariations: VariationGenerator = { name, context in
    switch name {
    case "empty":
      return [(context: context, suffix: "")]
    case "multiple":
      return [
        (context: try StencilContext.enrich(context: context,
                                            parameters: ["objcCompatible"]),
         suffix: "-objc-compatible")
      ]
    default:
      break
    }

    return [
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["objcCompatible", "enumName=XCTLoc"]),
       suffix: "-objc-compatible-customname"),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["objcCompatible", "noComments"]),
       suffix: "-objc-compatible-no-comments"),
      (context: try StencilContext.enrich(context: context,
                                          parameters: ["objcCompatible", "publicAccess"]),
       suffix: "-objc-compatible-publicAccess")
    ]
  }

  func testFlatSwift3() {
    test(template: "flat-swift3",
         contextNames: Contexts.all,
         directory: .strings,
         contextVariations: variations)
  }

  func testFlatSwift4() {
    test(template: "flat-swift4",
         contextNames: Contexts.all,
         directory: .strings,
         contextVariations: variations)
  }

  func testFlatSwift4ObjcCompatible() {
    test(template: "flat-swift4",
         contextNames: Contexts.all,
         directory: .strings,
         contextVariations: flatSwiftObjCCompatibleVariations)
  }

  func testStructuredSwift3() {
    test(template: "structured-swift3",
         contextNames: Contexts.all,
         directory: .strings,
         contextVariations: variations)
  }

  func testStructuredSwift4() {
    test(template: "structured-swift4",
         contextNames: Contexts.all,
         directory: .strings,
         contextVariations: variations)
  }
}
