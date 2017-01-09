//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
import PathKit
import StencilSwiftKit
import SwiftGenKit

// MARK: - Tests for TXT files

class ColorsTextFileTests: XCTestCase {

  func testEmpty() {
    let parser = ColorsTextFileParser()

    let template = SwiftTemplate(templateString: Fixtures.template(for: "colors-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Empty.swift.out", sub: .colors)
    XCTDiffStrings(result, expected)
  }

  func testListWithDefaults() {
    let parser = ColorsTextFileParser()
    do {
      try parser.addColor(named: "Text&Body Color", value: "0x999999")
      try parser.addColor(named: "ArticleTitle", value: "#996600")
      try parser.addColor(named: "ArticleBackground", value: "#ffcc0099")
    } catch {
      XCTFail("Failed with unexpected error \(error)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "colors-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "List-Default.swift.out", sub: .colors)
    XCTDiffStrings(result, expected)
  }

  func testListWithRawValueTemplate() {
    let parser = ColorsTextFileParser()
    do {
      try parser.addColor(named: "Text&Body Color", value: "0x999999")
      try parser.addColor(named: "ArticleTitle", value: "#996600")
      try parser.addColor(named: "ArticleBackground", value: "#ffcc0099")
    } catch {
      XCTFail("Failed with unexpected error \(error)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "colors-rawValue.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "List-RawValue.swift.out", sub: .colors)
    XCTDiffStrings(result, expected)
  }

  func testFileWithDefaults() {
    let parser = ColorsTextFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "colors.txt", sub: .colors))

    let template = SwiftTemplate(templateString: Fixtures.template(for: "colors-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Txt-File-Default.swift.out", sub: .colors)
    XCTDiffStrings(result, expected)
  }

  func testFileSwift3() {
    let parser = ColorsTextFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "colors.txt", sub: .colors))

    let template = SwiftTemplate(templateString: Fixtures.template(for: "colors-swift3.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Txt-File-Swift3.swift.out", sub: .colors)
    XCTDiffStrings(result, expected)
  }

  func testFileWithCustomName() {
    let parser = ColorsTextFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "colors.txt", sub: .colors))

    let template = SwiftTemplate(templateString: Fixtures.template(for: "colors-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext(enumName: "XCTColors"))

    let expected = Fixtures.output(for: "Txt-File-CustomName.swift.out", sub: .colors)
    XCTDiffStrings(result, expected)
  }

  func testFileWithBadSyntax() {
    let parser = ColorsTextFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "bad-syntax.txt", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad syntax")
    } catch ColorsParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadValue() {
    let parser = ColorsTextFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "bad-value.txt", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad value")
    } catch ColorsParserError.invalidHexColor(string: "thisIsn'tAColor", key: "ArticleTitle"?) {
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

    let template = SwiftTemplate(templateString: Fixtures.template(for: "colors-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Empty.swift.out", sub: .colors)
    XCTDiffStrings(result, expected)
  }

  func testFileWithDefaults() {
    let parser = ColorsCLRFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "colors.clr", sub: .colors))

    let template = SwiftTemplate(templateString: Fixtures.template(for: "colors-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "File-Default.swift.out", sub: .colors)
    XCTDiffStrings(result, expected)
  }

  func testFileWithCustomName() {
    let parser = ColorsCLRFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "colors.clr", sub: .colors))

    let template = SwiftTemplate(templateString: Fixtures.template(for: "colors-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext(enumName: "XCTColors"))

    let expected = Fixtures.output(for: "File-CustomName.swift.out", sub: .colors)
    XCTDiffStrings(result, expected)
  }

  func testFileWithBadFile() {
    let parser = ColorsCLRFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "bad.clr", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad file")
    } catch ColorsParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}

// MARK: - Tests for XML Android color files

class ColorsXMLFileTests: XCTestCase {
  func testEmpty() {
    let parser = ColorsXMLFileParser()

    let template = SwiftTemplate(templateString: Fixtures.template(for: "colors-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Empty.swift.out", sub: .colors)
    XCTDiffStrings(result, expected)
  }

  func testFileWithDefaults() {
    let parser = ColorsXMLFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "colors.xml", sub: .colors))
    } catch {
      XCTFail("Exception while parsing file: \(error)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "colors-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "File-Default.swift.out", sub: .colors)
    XCTDiffStrings(result, expected)
  }

  func testFileWithCustomName() {
    let parser = ColorsXMLFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "colors.xml", sub: .colors))
    } catch {
      XCTFail("Exception while parsing file: \(error)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "colors-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext(enumName: "XCTColors"))

    let expected = Fixtures.output(for: "File-CustomName.swift.out", sub: .colors)
    XCTDiffStrings(result, expected)
  }

  func testFileWithBadSyntax() {
    let parser = ColorsXMLFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "bad-syntax.xml", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad syntax")
    } catch ColorsParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadValue() {
    let parser = ColorsXMLFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "bad-value.xml", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad value")
    } catch ColorsParserError.invalidHexColor(string: "this isn't a color", key: "ArticleTitle"?) {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}

// MARK: - Tests for JSON color files

class ColorsJSONFileTests: XCTestCase {
  func testEmpty() {
    let parser = ColorsJSONFileParser()

    let template = SwiftTemplate(templateString: Fixtures.template(for: "colors-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Empty.swift.out", sub: .colors)
    XCTDiffStrings(result, expected)
  }

  func testFileWithDefaults() {
    let parser = ColorsJSONFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "colors.json", sub: .colors))
    } catch {
      XCTFail("Exception while parsing file: \(error)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "colors-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "File-Default.swift.out", sub: .colors)
    XCTDiffStrings(result, expected)
  }

  func testFileWithCustomName() {
    let parser = ColorsJSONFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "colors.json", sub: .colors))
    } catch {
      XCTFail("Exception while parsing file: \(error)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "colors-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext(enumName: "XCTColors"))

    let expected = Fixtures.output(for: "File-CustomName.swift.out", sub: .colors)
    XCTDiffStrings(result, expected)
  }

  func testFileWithBadSyntax() {
    let parser = ColorsJSONFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "bad-syntax.json", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad syntax")
    } catch ColorsParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadValue() {
    let parser = ColorsJSONFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "bad-value.json", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad value")
    } catch ColorsParserError.invalidHexColor(string: "this isn't a color", key: "ArticleTitle"?) {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
