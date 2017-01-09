//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
import StencilSwiftKit
import SwiftGenKit

/**
 * Important: In order for the "*.strings" files in fixtures/ to be copied as-is in the test bundle
 * (as opposed to being compiled when the test bundle is compiled), a custom "Build Rule" has been added to the target.
 * See Project -> Target "UnitTests" -> Build Rules -> « Files "*.strings" using PBXCp »
 */

class StringsTests: XCTestCase {

  func testEmpty() {
    let parser = StringsFileParser()

    let template = SwiftTemplate(templateString: Fixtures.template(for: "strings-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Empty.swift.out", sub: .strings)
    XCTDiffStrings(result, expected)
  }

  func testEntriesWithDefaults() {
    let parser = StringsFileParser()
    parser.addEntry(StringsFileParser.Entry(key: "Title", translation: "My awesome title"))
    parser.addEntry(StringsFileParser.Entry(key: "Greetings", translation: "Hello, my name is %@ and I'm %d", types: .Object, .Int))

    let template = SwiftTemplate(templateString: Fixtures.template(for: "strings-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Entries-Default.swift.out", sub: .strings)
    XCTDiffStrings(result, expected)
  }

  func testFileWithDefaults() {
    let parser = StringsFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let template = SwiftTemplate(templateString: Fixtures.template(for: "strings-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "File-Default.swift.out", sub: .strings)
    XCTDiffStrings(result, expected)
  }

  func testMultiline() {
    let parser = StringsFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "LocMultiline.strings", sub: .strings))

    let template = SwiftTemplate(templateString: Fixtures.template(for: "strings-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Multiline.swift.out", sub: .strings)
    XCTDiffStrings(result, expected)
  }

  func testUTF8FileWithDefaults() {
    let parser = StringsFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "LocUTF8.strings", sub: .strings))

    let template = SwiftTemplate(templateString: Fixtures.template(for: "strings-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "File-UTF8-Default.swift.out", sub: .strings)
    XCTDiffStrings(result, expected)
  }

  func testFileWithCustomName() {
    let parser = StringsFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let template = SwiftTemplate(templateString: Fixtures.template(for: "strings-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext(enumName: "XCTLoc"))

    let expected = Fixtures.output(for: "File-CustomName.swift.out", sub: .strings)
    XCTDiffStrings(result, expected)
  }

  func testFileWithSwift3() {
    let parser = StringsFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let template = SwiftTemplate(templateString: Fixtures.template(for: "strings-swift3.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "File-Swift3.swift.out", sub: .strings)
    XCTDiffStrings(result, expected)
  }
  
  func testFileWithoutCommentsAndSwift3() {
    let parser = StringsFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "Localizable.strings", sub: .strings))
    
    let template = SwiftTemplate(templateString: Fixtures.template(for: "strings-no-comments-swift3.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())
    
    let expected = Fixtures.output(for: "File-NoComments-Swift3.swift.out", sub: .strings)
    XCTDiffStrings(result, expected)
  }

  func testFileWithStructured() {
    let parser = StringsFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let template = SwiftTemplate(templateString: Fixtures.template(for: "strings-structured.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "File-Structured.swift.out", sub: .strings)
    XCTDiffStrings(result, expected)
  }

  func testFileWithStructuredOnly() {
    let parser = StringsFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "LocStructuredOnly.strings", sub: .strings))

    let template = SwiftTemplate(templateString: Fixtures.template(for: "strings-structured.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "File-Structured-Only.swift.out", sub: .strings)
    XCTDiffStrings(result, expected)
  }

  func testFileWithDotSyntax() {
    let parser = StringsFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let template = SwiftTemplate(templateString: Fixtures.template(for: "strings-dot-syntax.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "File-Dot-Syntax.swift.out", sub: .strings)
    XCTDiffStrings(result, expected)
  }

  func testFileWithDotSyntaxSwift3() {
    let parser = StringsFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let template = SwiftTemplate(templateString: Fixtures.template(for: "strings-dot-syntax-swift3.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "File-Dot-Syntax-Swift3.swift.out", sub: .strings)
    XCTDiffStrings(result, expected)
  }

  func testFileWithGenstringsTemplate() {
    let parser = StringsFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "Localizable.strings", sub: .strings))
    
    let template = SwiftTemplate(templateString: Fixtures.template(for: "strings-genstrings.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())
    
    let expected = Fixtures.output(for: "Localizable-Genstrings.swift.out", sub: .strings)
    XCTDiffStrings(result, expected)
  }
  
  ////////////////////////////////////////////////////////////////////////

  func testParseStringPlaceholder() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%@")
    XCTAssertEqual(placeholders, [.Object])
  }

  func testParseFloatPlaceholder() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%f")
    XCTAssertEqual(placeholders, [.Float])
  }

  func testParseDoublePlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%g-%e")
    XCTAssertEqual(placeholders, [.Float, .Float])
  }

  func testParseFloatWithPrecisionPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%1.2f : %.3f : %+3f : %-6.2f")
    XCTAssertEqual(placeholders, [.Float, .Float, .Float, .Float])
  }

  func testParseIntPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%d-%i-%o-%u-%x")
    XCTAssertEqual(placeholders, [.Int, .Int, .Int, .Int, .Int])
  }

  func testParseCCharAndStringPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%c-%s")
    XCTAssertEqual(placeholders, [.Char, .CString])
  }

  func testParsePositionalPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%2$d-%4$f-%3$@-%c")
    XCTAssertEqual(placeholders, [.Char, .Int, .Object, .Float])
  }

  func testParseComplexFormatPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%2$1.3d - %4$-.7f - %3$@ - %% - %5$+3c - %%")
    // positions 2, 4, 3, 5 set to Int, Float, Object, Char, and position 1 not matched, defaulting to Unknown
    XCTAssertEqual(placeholders, [.Unknown, .Int, .Object, .Float, .Char])
  }

  func testParseEscapePercentSign() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%%foo")
    // Must NOT map to [.Float]
    XCTAssertEqual(placeholders, [])
  }

}
