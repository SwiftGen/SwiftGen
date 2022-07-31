# Creating a SwiftGen Build Tool Package Plugin

[SE-0325](https://github.com/apple/swift-evolution/blob/main/proposals/0325-swiftpm-additional-plugin-apis.md) introduced the ability to create Swift Package Plugins for our Swift Packages, and it was officially released in [Swift 5.6](https://github.com/apple/swift/blob/main/CHANGELOG.md#swift-56).

Using this new functionality it is possible to create a SwiftGen plugin for our Swift Packages which automatically keeps our generated files up to date.

SwiftGen provides an [official plugin](https://github.com/SwiftGen/SwiftGenPlugin) that provides most of the functionality you may ever need. The rest of this article is for if you ever want to create your own SwiftGen plugin.

## Making the SwiftGen binary available to your plugin

Simply add the following binary target to your `Package.swift`. Each recent SwiftGen release includes a `.artifactbundle` compatible with Swift Plugin development.

```swift
targets: [
    .plugin(
        name: "YourSwiftGenPlugin",
        capability: .buildTool(),
        dependencies: [
            "swiftgen"
        ]
    ),    
    .binaryTarget(
        name: "swiftgen",
        url: "https://github.com/SwiftGen/SwiftGen/releases/download/6.5.1/swiftgen.artifactbundle.zip",
        checksum: "a8e445b41ac0fd81459e07657ee19445ff6cbeef64eb0b3df51637b85f925da8"
    )
]
```

> 👋 Remember to replace the version and checksum with appropriate values, you can find the most recent SwiftGen releases [HERE](https://github.com/SwiftGen/SwiftGen/releases)

> 🧮 To generate the [checksum](https://developer.apple.com/documentation/swift_packages/target/3583312-checksum) yourself you can use `swift package compute-checksum swiftgen.artifactbundle.zip`.

## Using the tool in your plugin

After the SwiftGen binary has been introduced to your package, your plugin will be able to execute SwiftGen by searching the context for a tool named `swiftgen`.

A barebones example:

```swift
import PackagePlugin
import Foundation

@main
struct SwiftGenPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        [
            Command.prebuildCommand(
                displayName: "Running SwiftGen",
                executable: try context.tool(named: "swiftgen").path,
                arguments: [
                    "config",
                    "run",
                    "--config", "\(target.directory.appending("swiftgen.yml"))"
                ],
                environment: [
                    "PROJECT_DIR": "\(context.package.directory)",
                    "TARGET_NAME": "\(target.name)",
                    "DERIVED_SOURCES_DIR": "\(context.pluginWorkDirectory)",
                ],
                outputFilesDirectory: context.pluginWorkDirectory
            )
        ]
    }
}
```

## Examples

Other examples of Swift package build tool plugins development

- <https://github.com/abertelrud/swiftpm-buildtool-plugin-examples>
- <https://github.com/apple/swift-package-manager/tree/main/Fixtures/Miscellaneous/Plugins/MyBinaryToolPlugin>
