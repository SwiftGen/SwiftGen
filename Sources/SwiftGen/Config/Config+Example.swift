//
// SwiftGen
// Copyright © 2020 SwiftGen
// MIT Licence
//

extension Config {
  static func example(versionForDocLink: String, commentAllLines: Bool = true) -> String {
    var content = exampleYAMLContent(version: versionForDocLink)
    if commentAllLines {
      // Comment all lines, except empty lines.
      //  - If a line is already a comment (starts with "#"), prefix with additional "#" to make it "## Blah"
      //  - Otherwise, if the line is just supposed to be actual YAML content, prefix it with "# "
      content = content
        .split(separator: "\n", omittingEmptySubsequences: false)
        .map { $0.isEmpty ? "" : $0.hasPrefix("#") ? "#\($0)" : "# \($0)" }
        .joined(separator: "\n")
    }
    return content
  }

  // swiftlint:disable line_length function_body_length
  private static func exampleYAMLContent(version: String) -> String {
    """
    # Note: all of the config entries below are just examples with placeholders. Be sure to edit and adjust to your needs when uncommenting.

    # In case your config entries all use a common input/output parent directory, you can specify those here.
    #   Every input/output paths in the rest of the config will then be expressed relative to these.
    #   Those two top-level keys are optional and default to "." (the directory of the config file).
    input_dir: MyLib/Sources/
    output_dir: MyLib/Generated/


    # Generate constants for your localized strings.
    #   Be sure that SwiftGen only parses ONE locale (typically Base.lproj, or en.lproj, or whichever your development region is); otherwise it will generate the same keys multiple times.
    #   SwiftGen will parse all `.strings` files found in that folder.
    strings:
      inputs:
        - Resources/Base.lproj
      outputs:
        - templateName: structured-swift5
          output: Strings+Generated.swift


    # Generate constants for your Assets Catalogs, including constants for images, colors, ARKit resources, etc.
    #   This example also shows how to provide additional parameters to your template to customize the output.
    #   - Especially the `forceProvidesNamespaces: true` param forces to create sub-namespace for each folder/group used in your Asset Catalogs, even the ones without "Provides Namespace". Without this param, SwiftGen only generates sub-namespaces for folders/groups which have the "Provides Namespace" box checked in the Inspector pane.
    #   - To know which params are supported for a template, use `swiftgen template doc xcassets swift5` to open the template documentation on GitHub.
    xcassets:
      inputs:
        - Main.xcassets
        - ProFeatures.xcassets
      outputs:
        - templateName: swift5
          params:
            forceProvidesNamespaces: true
          output: XCAssets+Generated.swift


    # Generate constants for your storyboards and XIBs.
    #   This one generates 2 output files, one containing the storyboard scenes, and another for the segues.
    #    (You can remove the segues entry if you don't use segues in your IB files).
    #   For `inputs` we can use "." here (aka "current directory", at least relative to `input_dir` = "MyLib/Sources"),
    #    and SwiftGen will recursively find all `*.storyboard` and `*.xib` files in there.
    ib:
      inputs:
        - .
      outputs:
        - templateName: scenes-swift5
          output: IB-Scenes+Generated.swift
        - templateName: segues-swift5
          output: IB-Segues+Generated.swift


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
