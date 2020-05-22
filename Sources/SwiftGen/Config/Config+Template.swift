//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

extension Config {
  static func template(versionForDocLink: String, commentAllLines: Bool = true) -> String {
    var content = templateYAMLContent(version: versionForDocLink)
    if commentAllLines {
      content = content
        .split(separator: "\n", omittingEmptySubsequences: false)
        .map { $0.isEmpty ? "" : $0.hasPrefix("#") ? "#\($0)" : "# \($0)" }
        .joined(separator: "\n")
    }

    return content
  }

  // swiftlint:disable line_length function_body_length
  private static func templateYAMLContent(version: String) -> String {
    """
    # Note: all of the config entries below are just examples with placeholders. Be sure to edit and adjust to your needs when uncommenting.

    # In case all your config entries all use a common input/output parent directory, you can specify those here; every input/output paths in the rest of the config will then be expressed relative to these. Those two top-level keys are optional and default to "." (the directory of the config file).

    input_dir: MyLib/Sources/
    output_dir: MyLib/Generated/


    # Generate constants for your localized strings.
    #   Be sure that SwiftGen only parses ONE locale (typically Base.lproj) – otherwise it will generate the same keys multiple times.
    strings:
      inputs:
        - Resources/Base.lproj
      outputs:
        - templateName: structured-swift5
          output: XCAssets+Generated.swift


    # Generate constants for your Assets Catalogs, including constants for images, colors, ARKit resources, etc.
    #   This also shows how to provide additional parameters to your template to customise the output.
    xcassets:
      inputs:
        - Main.xcassets
        - ProFeatures.xcassets
      outputs:
        - templateName: swift5
          params:
            forceProvidesNamespaces: true # If you want a sub-namespace created for each folder/group used in your Asset Catalogs
          output: XCAssets+Generated.swift


    # Generate constants for your storyboards and XIBs.
    #   This one generates 2 output files, one containing the storyboard scenes, and another for the segues.
    #   (You can remove the segues output if you don't use segues in your IB files)
    ib:
      inputs:
        - . # SwiftGen will just search for all *.storyboard and *.xib files in the current directory
      outputs:
        - templateName: scenes-swift5
          output: IB+Scenes.swift
        - templateName: segues-swift5
          output: IB+Segues.swift


    # There are other parsers available for you to use depending on your needs, for example:
    #  - `fonts` (if you have custom ttf/ttc font files)
    #  - `coredata` (for CoreData models)
    #  - `json`, `yaml` and `plist` (to parse custom JSON/YAML/Plist files and generate code from their content)
    # …
    #
    # For more info, use `swiftgen config doc` to open the full documentation on GitHub.
    # \(gitHubDocURL(version: version))
    """
  }
  // swiftlint:enable line_length function_body_length
}
