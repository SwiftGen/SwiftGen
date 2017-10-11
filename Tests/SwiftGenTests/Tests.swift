//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
import PathKit

class Tests: XCTestCase {

  func testConfig1() throws {
    guard let path = Bundle(for: type(of: self)).path(forResource: "swiftgen-1", ofType: "yml") else {
      fatalError("Fixture not found")
    }
    let file = Path(path)
    do {
      let config = try Config(file: file)
      XCTAssertEqual(config.outputDir, "Common/Generated")
      XCTAssertEqual(Array(config.commands.keys), ["strings"])
      guard let strings = config.commands["strings"] else {
        return XCTFail("Missing key 'strings'")
      }
      XCTAssertEqual(strings.count, 1)
      guard let str = strings.first else {
        return XCTFail("Can't get strings only config entry")
      }
      XCTAssertEqual(str.paths, ["Sources1/Folder"])
      if case TemplateRef.name("structured-swift3") = str.template { /* OK */ } else {
        XCTFail("Unexpected template")
      }
      XCTAssertEqual(str.output, "strings.swift")
      XCTAssertEqual(str.parameters["foo"] as? Int, 5)
      let barParams = str.parameters["bar"] as? [String: Any]
      XCTAssertEqual(barParams?["bar1"] as? Int, 1)
      XCTAssertEqual(barParams?["bar2"] as? Int, 2)
      let bar3Params = barParams?["bar3"] as? [Any]
      XCTAssertEqual(bar3Params?.count, 3)
      XCTAssertEqual(bar3Params?[0] as? Int, 3)
      XCTAssertEqual(bar3Params?[1] as? Int, 4)
      XCTAssertEqual((bar3Params?[2] as? [String: Int]) ?? [:], ["bar3a": 50])
      let bazParams = str.parameters["baz"] as? [String]
      XCTAssertEqual(bazParams ?? [], ["hello", "world"])
    } catch let e {
      XCTFail("Error: \(e)")
    }
  }
}
