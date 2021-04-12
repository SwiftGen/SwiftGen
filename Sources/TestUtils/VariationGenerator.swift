//
// Templates UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import PathKit
import StencilSwiftKit
import SwiftGenKit
import XCTest

public extension XCTestCase {
  ///
  /// Generate variations of a context.
  ///
  /// - Parameter name: The name of the context
  /// - Parameter context: The context itself
  /// - Return: a tuple with a list of generated contexts, and a suffix to find the correct output file
  ///
  typealias VariationGenerator = ((String, [String: Any]) throws -> [(context: [String: Any], suffix: String)])

  ///
  /// Test the given template against a list of contexts, comparing the output with files in the expected folder.
  ///
  /// - Parameter template: The name of the template (without the `stencil` extension)
  /// - Parameter contextNames: A list of context names (without the `plist` extension)
  /// - Parameter directory: The directory to look for files in (corresponds to the command)
  /// - Parameter resourceDirectory: The directory to look for files in (corresponds to the command)
  /// - Parameter contextVariations: Optional closure to generate context variations.
  ///
  func test(
    template templateName: String,
    contextNames: [String],
    directory: Fixtures.Directory,
    resourceDirectory: Fixtures.Directory? = nil,
    outputDirectory: Fixtures.Directory? = nil,
    file: StaticString = #file,
    line: UInt = #line,
    contextVariations: VariationGenerator? = nil,
    outputExtension: String = "swift"
  ) {
    let templateString = Fixtures.template(for: "\(templateName).stencil", sub: directory)
    let template = StencilSwiftTemplate(
      templateString: templateString,
      environment: stencilSwiftEnvironment()
    )

    // default values
    let contextVariations = contextVariations ?? { [(context: $1, suffix: "")] }
    let resourceDir = resourceDirectory ?? directory
    let outputDir = outputDirectory ?? resourceDir

    for contextName in contextNames {
      print("Testing context '\(contextName)'...")
      let context = Fixtures.context(for: "\(contextName).yaml", sub: resourceDir)

      // generate context variations
      guard let variations = try? contextVariations(contextName, context) else {
        fatalError("Unable to generate context variations")
      }

      for (index, (context: context, suffix: suffix)) in variations.enumerated() {
        let outputFile = "\(contextName)\(suffix).\(outputExtension)"
        if variations.count > 1 { print(" - Variation #\(index)... (expecting: \(outputFile))") }

        let result: String
        do {
          result = try template.render(context)
        } catch let error {
          fatalError("Unable to render template: \(error)")
        }

        // check if we should generate or not
        if ProcessInfo().environment["GENERATE_OUTPUT"] == "YES" {
          let target = Path(#filePath).parent() + "Fixtures/Generated" + outputDir.rawValue +
            templateName + outputFile
          do {
            try target.write(result)
          } catch {
            fatalError("Unable to write output file \(target)")
          }
        } else {
          let expected = Fixtures.output(template: templateName, variation: outputFile, sub: outputDir)
          XCTDiffStrings(result, expected, file: file, line: line)
        }
      }
    }
  }
}
