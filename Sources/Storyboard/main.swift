import Foundation
//@import SwiftGenStoryboardEnumBuilder

guard Process.argc >= 2 else {
    print("Usage: swiftgen-storyboard path/to/dir/containing/storyboards")
    exit(-1)
}

let scanDir = Process.arguments[1]

let enumBuilder = SwiftGenStoryboardEnumBuilder()
enumBuilder.parseDirectory(scanDir)
let output = enumBuilder.build()

print(output)
