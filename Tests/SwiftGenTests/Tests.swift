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
      XCTAssertEqual(str.sources, ["Sources1/Folder"])
      XCTAssertEqual(str.templateName, "swift3")
      XCTAssertEqual(str.output, "strings.swift")
      XCTAssertEqual(str.parameters.count, 2)
      guard let foo = str.parameters["foo"] as? String else {
        return XCTFail("parameter foo of type String not found")
      }
      XCTAssertEqual(foo, "bar")
      guard let baz = str.parameters["baz"] as? Int else {
        return XCTFail("parameter baz of type Int not found")
      }
      XCTAssertEqual(baz, 42)
    } catch let e {
      XCTFail("Error: \(e)")
    }
  }
}
