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
    .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.0"),
    .package(url: "https://github.com/kylef/Commander.git", from: "0.9.0"),
    .package(url: "https://github.com/kylef/PathKit.git", from: "0.9.0"),
    .package(url: "https://github.com/kylef/Stencil.git", from: "0.13.0"),
    .package(url: "https://github.com/shibapm/Komondor.git", from: "1.0.0"),
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
      "SwiftGenKit",
      "TestUtils"
    ]),
    .testTarget(name: "SwiftGenTests", dependencies: [
      "SwiftGenCLI",
      "TestUtils"
    ]),
    .testTarget(name: "TemplatesTests", dependencies: [
      "StencilSwiftKit",
      "SwiftGenKit",
      "TestUtils"
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

#if canImport(PackageConfig)
import PackageConfig

let config = PackageConfiguration([
  "komondor": [
    "pre-commit": [
        "PATH=\"~/.rbenv/shims:$PATH\" bundler exec rake lint:code",
        "PATH=\"~/.rbenv/shims:$PATH\" bundler exec rake lint:tests",
        "PATH=\"~/.rbenv/shims:$PATH\" bundler exec rake lint:output"
    ],
    "pre-push": [
      "PATH=\"~/.rbenv/shims:$PATH\" bundle exec rake spm:test"
    ]
  ],
]).write()
#endif
