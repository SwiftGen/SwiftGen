import Foundation
//@import SwiftGenStoryboardEnumBuilder

guard Process.argc >= 2 else {
    print("Usage: swiftgen-storyboard path/to/dir/containing/storyboards")
    exit(-1)
}

if ["-v","--version"].contains(Process.arguments[1]) {
    print(SwiftGenVersion)
    exit(0)
}

// MARK: Main Entry Point

let scanDir = Process.arguments[1]

let enumBuilder = SwiftGenStoryboardEnumBuilder()
enumBuilder.parseDirectory(scanDir)
let output = enumBuilder.build()

print(output)
