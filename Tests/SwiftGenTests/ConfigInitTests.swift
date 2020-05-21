//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

import XCTest
import Yams

class ConfigInitTests: XCTestCase {
  func testValidTemplate() {
    do {
      let content = Config.template(insertHelpForVersion: "x.y.z", commentYAML: false)
      _ = try Config(content: content, env: [:], sourcePath: ".") { level, msg in
        XCTFail("The template configuration generated the log message: \(level):\(msg)")
      }
    } catch let error {
      XCTFail("The template configuration generated errors when parsing: \(error)")
    }
  }
}
