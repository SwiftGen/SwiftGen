// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SwiftGen",
    products: [
        .executable(name: "swiftgen", targets: ["SwiftGen"]),
        .library(name: "SwiftGenKit", targets: ["SwiftGenKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", from: "0.8.0"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.8.0"),
        .package(url: "https://github.com/kylef/Stencil.git", from: "0.11.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "0.7.0"),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", .branchItem("master")),
        .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "4.0.0"),
        .package(url: "https://github.com/tid-kijyun/SwiftClibxml2.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "SwiftGen", dependencies: [
          "Commander",
          "Kanna",
          "PathKit",
          "Stencil",
          "SwiftGenKit",
          "Yams"
        ]),
        .target(name: "SwiftGenKit", dependencies: [
          "PathKit",
          "StencilSwiftKit",
        ]),
        .testTarget(name: "SwiftGenTests", dependencies: [
          "SwiftGen",
        ]),
        .testTarget(name: "SwiftGenKitTests", dependencies: [
          "SwiftGenKit",
        ])
    ]
)
