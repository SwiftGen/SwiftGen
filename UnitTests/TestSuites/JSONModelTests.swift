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
    _ = try? parser.parseFile(path: Fixtures.path(for: "Model.json", subDirectory: "Models"))

    let template = GenumTemplate(templateString: Fixtures.string(for: "json-model.stencil"))
    let result = try! template.render(parser.stencilContext())
    print(result)
    let expected = Fixtures.string(for: "Models-Dir-Basic.swift.out")
    XCTDiffStrings(result, expected)
  }
}
