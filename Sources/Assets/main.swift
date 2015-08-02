import Foundation
//@import SwiftGenAssetsEnumBuilder

guard Process.argc >= 2 else {
    print("Usage: swiftgen-assets path/to/dir/containing/xcassets")
    print("\n -- Version: \(SwiftGenVersion)")
    exit(-1)
}

let scanDir = Process.arguments[1]

let enumBuilder = SwiftGenAssetsEnumBuilder()
enumBuilder.parseDirectory(scanDir)
let output = enumBuilder.build()

print(output)
