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
    let parser = JSONFileParser()
    _ = try? parser.parseFile(path: self.fixture("Model.json", subDirectory: "Models"))

    let template = GenumTemplate(templateString: fixtureString("json-model.stencil"))
    let result = try! template.render(parser.stencilContext())
    print(result)
    let expected = fixtureString("Models-Dir-Basic.swift.out")
    XCTDiffStrings(result, expected)
  }
}
