//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
import GenumKit
import PathKit

// MARK: - Tests for TXT files

class ColorsTextFileTests: XCTestCase {

  func testEmpty() {
    let parser = ColorsTextFileParser()

    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Colors-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testListWithDefaults() {
    let parser = ColorsTextFileParser()
    do {
      try parser.addColorWithName("Text&Body Color", value: "0x999999")
      try parser.addColorWithName("ArticleTitle", value: "#996600")
      try parser.addColorWithName("ArticleBackground", value: "#ffcc0099")
    } catch {
      XCTFail("Failed with unexpected error \(error)")
    }

    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Colors-List-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testListWithRawValueTemplate() {
    let parser = ColorsTextFileParser()
    do {
      try parser.addColorWithName("Text&Body Color", value: "0x999999")
      try parser.addColorWithName("ArticleTitle", value: "#996600")
      try parser.addColorWithName("ArticleBackground", value: "#ffcc0099")
    } catch {
      XCTFail("Failed with unexpected error \(error)")
    }

    let template = GenumTemplate(templateString: fixtureString("colors-rawValue.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Colors-List-RawValue.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithDefaults() {
    let parser = ColorsTextFileParser()
    try! parser.parseFile(fixturePath("colors.txt"))

    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Colors-Txt-File-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileSwift3() {
    let parser = ColorsTextFileParser()
    try! parser.parseFile(fixturePath("colors.txt"))

    let template = GenumTemplate(templateString: fixtureString("colors-swift3.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Colors-Txt-File-Swift3.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithCustomName() {
    let parser = ColorsTextFileParser()
    try! parser.parseFile(fixturePath("colors.txt"))

    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext(enumName: "XCTColors"))

    let expected = self.fixtureString("Colors-Txt-File-CustomName.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithBadFormatting() {
    let parser = ColorsTextFileParser()
    do {
      try parser.parseFile(fixturePath("colors-bad.txt"))
      XCTFail("Code did parse file successfully while it was expected to fail for bad formatting")
    } catch ColorsParserError.InvalidHexColor(string: ":", key: "MX_WELCOME_BACKGROUND"?) {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

}

// MARK: - Tests for CLR Palette files

class ColorsCLRFileTests: XCTestCase {

  func testEmpty() {
    let parser = ColorsCLRFileParser()

    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Colors-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithDefaults() {
    let parser = ColorsCLRFileParser()
    parser.parseFile(fixturePath("colors.clr"))

    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Colors-File-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithCustomName() {
    let parser = ColorsCLRFileParser()
    parser.parseFile(fixturePath("colors.clr"))

    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext(enumName: "XCTColors"))

    let expected = self.fixtureString("Colors-File-CustomName.swift.out")
    XCTDiffStrings(result, expected)
  }
}

// MARK: - Tests for XML Android color files

class ColorsXMLFileTests: XCTestCase {
  func testEmpty() {
    let parser = ColorsXMLFileParser()

    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Colors-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithDefaults() {
    let parser = ColorsXMLFileParser()
    do {
      try parser.parseFile(fixturePath("colors.xml"))
    } catch {
      XCTFail("Exception while parsing file: \(error)")
    }

    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Colors-File-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithCustomName() {
    let parser = ColorsXMLFileParser()
    do {
      try parser.parseFile(fixturePath("colors.xml"))
    } catch {
      XCTFail("Exception while parsing file: \(error)")
    }

    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext(enumName: "XCTColors"))

    let expected = self.fixtureString("Colors-File-CustomName.swift.out")
    XCTDiffStrings(result, expected)
  }
}

class ColorsJSONFileTests: XCTestCase {
  func testEmpty() {
    let parser = ColorsJSONFileParser()

    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Colors-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithDefaults() {
    let parser = ColorsJSONFileParser()
    do {
      try parser.parseFile(fixturePath("colors.json"))
    } catch {
      XCTFail("Exception while parsing file: \(error)")
    }

    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Colors-File-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithCustomName() {
    let parser = ColorsJSONFileParser()
    do {
      try parser.parseFile(fixturePath("colors.json"))
    } catch {
      XCTFail("Exception while parsing file: \(error)")
    }

    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext(enumName: "XCTColors"))

    let expected = self.fixtureString("Colors-File-CustomName.swift.out")
    XCTDiffStrings(result, expected)
  }
}
