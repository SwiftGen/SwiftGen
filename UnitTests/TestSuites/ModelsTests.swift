//
//  ModelsTests.swift
//  SwiftGen
//
//  Created by Peter Livesey on 9/16/16.
//  Copyright © 2016 AliSoftware. All rights reserved.
//

import XCTest
@testable import GenumKit

class ModelsTests: XCTestCase {
  func testEmpty() {
    let parser = ModelsJSONFileParser()
    _ = try? parser.parseFile(self.fixturePath("Model.json", subDirectory: "Models"))

    let template = GenumTemplate(templateString: fixtureString("models-default.stencil"))
    let result = try! template.render(parser.stencilContext())
    print(result)
//    let expected = fixtureString("Models-Dir-Basic.swift.out")
//    XCTDiffStrings(result, expected)
  }
}
