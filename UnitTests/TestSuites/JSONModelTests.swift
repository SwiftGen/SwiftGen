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
  func testFullModel() {
    let parser = JSONFileParser()
    try? parser.parseFile(path: Fixtures.path(for: "Model.json", subDirectory: "Models"))

    let template = GenumTemplate(templateString: Fixtures.string(for: "json-model.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.string(for: "Models-Dir-Basic.swift.out")
    XCTDiffStrings(result, expected)
  }
}
