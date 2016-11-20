//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
import GenumKit

/**
 * Important: In order for the "*.strings" files in fixtures/ to be copied as-is in the test bundle
 * (as opposed to being compiled when the test bundle is compiled), a custom "Build Rule" has been added to the target.
 * See Project -> Target "UnitTests" -> Build Rules -> « Files "*.strings" using PBXCp »
 */

class StringsTests: XCTestCase {

  func testEmpty() {
    let parser = StringsFileParser()

    let template = GenumTemplate(templateString: fixtureString("strings-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Strings-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testEntriesWithDefaults() {
    let parser = StringsFileParser()
    parser.addEntry(StringsFileParser.Entry(key: "Title", translation: "My awesome title"))
    parser.addEntry(StringsFileParser.Entry(key: "Greetings", translation: "Hello, my name is %@ and I'm %d", types: .Object, .Int))

    let template = GenumTemplate(templateString: fixtureString("strings-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Strings-Entries-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testLinesWithDefaults() {
    let parser = StringsFileParser()
    if let e = StringsFileParser.Entry(line: "\"AppTitle\"    =   \"My awesome title\"  ; // Yeah") {
      parser.addEntry(e)
    }
    if let e = StringsFileParser.Entry(line: "\"GreetingsAndAge\"=\"My name is %@, I am %d\";/* hello */") {
      parser.addEntry(e)
    }

    let template = GenumTemplate(templateString: fixtureString("strings-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Strings-Lines-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithDefaults() {
    let parser = StringsFileParser()
    try! parser.parseStringsFile(fixturePath("Localizable.strings"))

    let template = GenumTemplate(templateString: fixtureString("strings-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Strings-File-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testMultiline() {
    let parser = StringsFileParser()
    try! parser.parseStringsFile(fixturePath("LocMultiline.strings"))

    let template = GenumTemplate(templateString: fixtureString("strings-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Strings-Multiline.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testUTF8FileWithDefaults() {
    let parser = StringsFileParser()
    try! parser.parseStringsFile(fixturePath("LocUTF8.strings"))

    let template = GenumTemplate(templateString: fixtureString("strings-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Strings-File-UTF8-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithCustomName() {
    let parser = StringsFileParser()
    try! parser.parseStringsFile(fixturePath("Localizable.strings"))

    let template = GenumTemplate(templateString: fixtureString("strings-default.stencil"))
    let result = try! template.render(parser.stencilContext(enumName: "XCTLoc"))

    let expected = self.fixtureString("Strings-File-CustomName.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithSwift3() {
    let parser = StringsFileParser()
    try! parser.parseStringsFile(fixturePath("Localizable.strings"))

    let template = GenumTemplate(templateString: fixtureString("strings-swift3.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Strings-File-Swift3.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithStructured() {
    let parser = StringsFileParser()
    try! parser.parseStringsFile(fixturePath("Localizable.strings"))

    let template = GenumTemplate(templateString: fixtureString("strings-structured.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Strings-File-Structured.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithStructuredOnly() {
    let parser = StringsFileParser()
    try! parser.parseStringsFile(fixturePath("LocStructuredOnly.strings"))

    let template = GenumTemplate(templateString: fixtureString("strings-structured.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Strings-File-Structured-Only.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithDotSyntax() {
    let parser = StringsFileParser()
    try! parser.parseStringsFile(fixturePath("Localizable.strings"))

    let template = GenumTemplate(templateString: fixtureString("strings-dot-syntax.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Strings-File-Dot-Syntax.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithDotSyntaxSwift3() {
    let parser = StringsFileParser()
    try! parser.parseStringsFile(fixturePath("Localizable.strings"))

    let template = GenumTemplate(templateString: fixtureString("strings-dot-syntax-swift3.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Strings-File-Dot-Syntax-Swift3.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithGenstringsTemplate() {
    let parser = StringsFileParser()
    try! parser.parseStringsFile(fixturePath("Localizable.strings"))
    
    let template = GenumTemplate(templateString: fixtureString("strings-genstrings.stencil"))
    let result = try! template.render(parser.stencilContext())
    
    let expected = self.fixtureString("Strings-Localizable-Genstrings.swift.out")
    XCTDiffStrings(result, expected)
  }
  
  ////////////////////////////////////////////////////////////////////////

  func testParseStringPlaceholder() {
    let placeholders = StringsFileParser.PlaceholderType.fromFormatString("%@")
    XCTAssertEqual(placeholders, [.Object])
  }

  func testParseFloatPlaceholder() {
    let placeholders = StringsFileParser.PlaceholderType.fromFormatString("%f")
    XCTAssertEqual(placeholders, [.Float])
  }

  func testParseDoublePlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.fromFormatString("%g-%e")
    XCTAssertEqual(placeholders, [.Float, .Float])
  }

  func testParseFloatWithPrecisionPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.fromFormatString("%1.2f : %.3f : %+3f : %-6.2f")
    XCTAssertEqual(placeholders, [.Float, .Float, .Float, .Float])
  }

  func testParseIntPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.fromFormatString("%d-%i-%o-%u-%x")
    XCTAssertEqual(placeholders, [.Int, .Int, .Int, .Int, .Int])
  }

  func testParseCCharAndStringPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.fromFormatString("%c-%s")
    XCTAssertEqual(placeholders, [.Char, .CString])
  }

  func testParsePositionalPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.fromFormatString("%2$d-%4$f-%3$@-%c")
    XCTAssertEqual(placeholders, [.Char, .Int, .Object, .Float])
  }

  func testParseComplexFormatPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.fromFormatString("%2$1.3d - %4$-.7f - %3$@ - %% - %5$+3c - %%")
    // positions 2, 4, 3, 5 set to Int, Float, Object, Char, and position 1 not matched, defaulting to Unknown
    XCTAssertEqual(placeholders, [.Unknown, .Int, .Object, .Float, .Char])
  }

  func testParseEscapePercentSign() {
    let placeholders = StringsFileParser.PlaceholderType.fromFormatString("%%foo")
    // Must NOT map to [.Float]
    XCTAssertEqual(placeholders, [])
  }

}
