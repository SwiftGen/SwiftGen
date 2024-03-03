//
// SwiftGen
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import Foundation
import XCTest
import PathKit
import StencilSwiftKit

private let colorCode: (String) -> String =
  ProcessInfo().environment["XcodeColors"] == "YES" ? { "\u{001b}[\($0);" } : { _ in "" }
private let (msgColor, reset) = (colorCode("fg250,0,0"), colorCode(""))
private let okCode = (num: colorCode("fg127,127,127"),
                      code: colorCode(""))
private let koCode = (num: colorCode("fg127,127,127") + colorCode("bg127,0,0"),
                      code: colorCode("fg250,250,250") + colorCode("bg127,0,0"))

private func diff(_ result: String, _ expected: String) -> String? {
  guard result != expected else { return nil }
  var firstDiff: Int? = nil
  let nl = CharacterSet.newlines
  let lhsLines = result.components(separatedBy: nl)
  let rhsLines = expected.components(separatedBy: nl)

  for (idx, pair) in zip(lhsLines, rhsLines).enumerated() where pair.0 != pair.1 {
    firstDiff = idx
    break
  }
  if firstDiff == nil && lhsLines.count != rhsLines.count {
    firstDiff = min(lhsLines.count, rhsLines.count)
  }
  if let badLineIdx = firstDiff {
    let slice = { (lines: [String], context: Int) -> ArraySlice<String> in
      let start = max(0, badLineIdx-context)
      let end = min(badLineIdx+context, lines.count-1)
      return lines[start...end]
    }
    let addLineNumbers = { (slice: ArraySlice) -> [String] in
      slice.enumerated().map { (idx: Int, line: String) in
        let num = idx + slice.startIndex
        let lineNum = "\(num+1)".padding(toLength: 3, withPad: " ", startingAt: 0) + "|"
        let clr = num == badLineIdx ? koCode : okCode
        return "\(clr.num)\(lineNum)\(reset)\(clr.code)\(line)\(reset)"
      }
    }
    let lhsNum = addLineNumbers(slice(lhsLines, 4)).joined(separator: "\n")
    let rhsNum = addLineNumbers(slice(rhsLines, 4)).joined(separator: "\n")
    return [
      "\(msgColor)Mismatch at line \(badLineIdx)\(reset)",
      ">>>>>> result",
      "\(lhsNum)",
      "======",
      "\(rhsNum)",
      "<<<<<< expected"
    ].joined(separator: "\n")
  }
  return nil
}

func XCTDiffStrings(_ result: String, _ expected: String, file: StaticString = #file, line: UInt = #line) {
  guard let error = diff(result, expected) else { return }
  XCTFail(error, file: file, line: line)
}

class Fixtures {
  enum Directory: String {
    case colors = "Colors"
    case fonts = "Fonts"
    case storyboards = "Storyboards"
    case storyboardsiOS = "Storyboards-iOS"
    case storyboardsMacOS = "Storyboards-macOS"
    case strings = "Strings"
    case xcassets = "XCAssets"
    case identifiersiOS = "Identifiers-iOS"
    case identifiersMacOS = "Identifiers-macOS"
    case identifiers
  }

  private static let testBundle = Bundle(for: Fixtures.self)
  private init() {}

  static func directory(sub: Directory? = nil) -> Path {
    guard let rsrcURL = testBundle.resourceURL else {
      fatalError("Unable to find resource directory URL")
    }
    let rsrc = Path(rsrcURL.path) + "Resources"

    guard let dir = sub else { return rsrc }
    return rsrc + dir.rawValue
  }

  static func path(for name: String, sub: Directory) -> Path {
    return path(for: name, subDirectory: "Resources/\(sub.rawValue)")
  }

  private static func path(for name: String, subDirectory: String? = nil) -> Path {
    guard let path = testBundle.path(forResource: name, ofType: "", inDirectory: subDirectory) else {
      fatalError("Unable to find fixture \"\(name)\"")
    }
    return Path(path)
  }

  static func context(for name: String, sub: Directory) -> [String: Any] {
    let path = self.path(for: name, subDirectory: "StencilContexts/\(sub.rawValue)")

    guard let data = NSDictionary(contentsOf: path.url) as? [String: Any] else {
      fatalError("Unable to load fixture content")
    }

    return data
  }

  static func template(for name: String, sub: Directory) -> String {
    return string(for: name, subDirectory: "templates/\(sub.rawValue.lowercased())")
  }

  static func output(for name: String, sub: Directory) -> String {
    return string(for: name, subDirectory: "Generated/\(sub.rawValue)")
  }

  private static func string(for name: String, subDirectory: String) -> String {
    do {
      return try path(for: name, subDirectory: subDirectory).read()
    } catch let e {
      fatalError("Unable to load fixture content: \(e)")
    }
  }
}

extension XCTestCase {
  /**
   Generate variations of a context.

   - Parameter name: The name of the context
   - Parameter context: The context itself
   - Return: a tuple with a list of generated contexts, and a suffix to find the correct output file
   */
  typealias VariationGenerator = ((String, [String: Any]) throws -> [(context: [String: Any], suffix: String)])

  /**
   Test the given template against a list of contexts, comparing the output with files in the expected folder.
   
   - Parameter template: The name of the template (without the `stencil` extension)
   - Parameter contextNames: A list of context names (without the `plist` extension)
   - Parameter directory: The directory to look for files in (correspons to de command)
   - Parameter resourceDirectory: The directory to look for files in (corresponds to the command)
   - Parameter contextVariations: Optional closure to generate context variations.
   */
  func test(template templateName: String,
            contextNames: [String],
            directory: Fixtures.Directory,
            resourceDirectory: Fixtures.Directory? = nil,
            file: StaticString = #file,
            line: UInt = #line,
            contextVariations: VariationGenerator? = nil) {
    let templateString = Fixtures.template(for: "\(templateName).stencil", sub: directory)
    let template = StencilSwiftTemplate(templateString: templateString,
                                        environment: stencilSwiftEnvironment())

    // default values
    let contextVariations = contextVariations ?? { [(context: $1, suffix: "")] }
    let resourceDir = resourceDirectory ?? directory

    for contextName in contextNames {
      print("Testing context '\(contextName)'...")
      let context = Fixtures.context(for: "\(contextName).plist", sub: resourceDir)

      // generate context variations
      guard let variations = try? contextVariations(contextName, context) else {
        fatalError("Unable to generate context variations")
      }

      for (index, (context: context, suffix: suffix)) in variations.enumerated() {
        let outputFile = "\(templateName)-context-\(contextName)\(suffix).swift"
        if variations.count > 1 { print(" - Variation #\(index)... (expecting: \(outputFile))") }

        let result: String
        do {
          result = try template.render(context)
        } catch let error {
          fatalError("Unable to render template: \(error)")
        }

        // check if we should generate or not
        if ProcessInfo().environment["GENERATE_OUTPUT"] == "YES" {
          let target = Path(#file).parent().parent() + "Fixtures/Generated" + resourceDir.rawValue + outputFile
          do {
            try target.write(result)
          } catch {
            fatalError("Unable to write output file \(target)")
          }
        } else {
          let expected = Fixtures.output(for: outputFile, sub: resourceDir)
          XCTDiffStrings(result, expected, file: file, line: line)
        }
      }
    }
  }
}
