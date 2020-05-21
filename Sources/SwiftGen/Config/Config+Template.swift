//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

extension Config {
  static func template(insertHelpForVersion: String?, commentYAML: Bool = true) -> String {
    func prefixLines(of text: String, with prefix: String) -> String {
      text
        .split(separator: "\n")
        .map { "\(prefix)\($0)" }
        .joined(separator: "\n")
    }

    var content = "## SwiftGen sample config file. Uncomment and adjust to your needs\n\n"
    content += commentYAML ? prefixLines(of: Config.templateYAMLContent, with: "# ") : Config.templateYAMLContent

    if let v = insertHelpForVersion {
      content += "\n" + prefixLines(of: Config.templateHelpText(version: v), with: "## ")
    }

    return content
  }

  // swiftlint:disable line_length
  static func templateHelpText(version: String) -> String {
    """

    ==== General Information ====

    (1) For each command/parser that you want SwiftGen to run, the simplest config entry will look like this:

    <parsername>:
      inputs:
        - <relative/path/to/file1.xyz>
        - <relative/path/to/file2.xyz>
        - <relative/path/to/folder>
      outputs:
        templateName: <nameOfTemplateToUse>
        output: <relative/path/to/output/file/to/generate.swift>

    (2) If you need to generate multiple outputs (using different templates, e.g. IB scenes + IB segues) for the same input, you can also provide a YAML array of those `templateName`+`output` dicts for the `outputs` key.

    <parsername>:
      inputs:
        - <relative/path/to/input/file.xyz>
      outputs:
        - templateName: <template1>
          output: <relative/path/to/output/file1.swift>
        - templateName: <template2>
          output: <relative/path/to/output/file2.swift>

    (3) Some templates can take optional parameters via the `params` key to slightly customize their output to your needs. See the template's documentation to know the available parameters.

    <parsername>:
      inputs:
        - <relative/path/to/input/file.xyz>
      outputs:
        - templateName: <template1>
          params:
            publicAccess: true
            enumName: MyNamespace
          output: <relative/path/to/output/file1.swift>

    For more details, including creating and using your own custom templates for a project with `templatePath`, using the `filter` key to filter the input files to parse, or provide `options` to the parser, see the documentation: https://github.com/SwiftGen/SwiftGen/tree/\(version)/Documentation

    """
  }

  static let templateYAMLContent = """
    # If all your commands use a common input/output directory for all your files, you can specify them here
    # to avoid repeating those intermediate paths in all commands

    inputDir: MyLib/Sources/
    outputDir: MyLib/Generated/

    xcassets:
      path: Deprecated
      inputs:
        - One
        - Two
      output: generated.swift
      outputs:
        - key: "This should not be a string"
          key2: "nor an array"
    """
  // swiftlint:enable line_length
}
