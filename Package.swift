// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "SwiftGen",
  platforms: [
    .macOS(.v10_11),
  ],
  products: [
    .executable(name: "swiftgen", targets: ["SwiftGen"]),
    .library(name: "SwiftGenKit", targets: ["SwiftGenKit"]),
  ],
  dependencies: [
    .package(url: "https://github.com/kylef/Commander.git", from: "0.9.0"),
    .package(url: "https://github.com/kylef/PathKit.git", from: "0.9.0"),
    .package(url: "https://github.com/kylef/Stencil.git", from: "0.13.0"),
    .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.0"),
    .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", from: "2.7.0"),
    .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "5.2.2")
  ],
  targets: [
    .target(name: "SwiftGen", dependencies: [
      "SwiftGenCLI"
    ]),
    .target(name: "SwiftGenCLI", dependencies: [
      "Commander",
      "Kanna",
      "PathKit",
      "Stencil",
      "StencilSwiftKit",
      "SwiftGenKit",
      "Yams"
    ], resources: [
      .copy("templates")
    ]),
    .target(name: "SwiftGenKit", dependencies: [
      "Kanna",
      "PathKit",
      "Yams"
    ]),
    .testTarget(name: "SwiftGenKitTests", dependencies: [
      "SwiftGenKit"
    ]),
    .testTarget(name: "SwiftGenTests", dependencies: [
      "SwiftGenCLI"
    ]),
    .testTarget(name: "TemplatesTests", dependencies: [
      "StencilSwiftKit",
      "SwiftGenKit"
    ]),
    .target(name: "TestUtils", dependencies: [
      "PathKit",
      "SwiftGenKit",
      "SwiftGenCLI"
    ], exclude: [
      "Fixtures/CompilationEnvironment"
    ], resources: [
      .copy("Fixtures/Configs"),
      .copy("Fixtures/Generated"),
      .copy("Fixtures/Resources"),
      .copy("Fixtures/StencilContexts")
    ])
  ],
  swiftLanguageVersions: [.v5]
)
