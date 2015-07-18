import Foundation
import SwiftGenStoryboardEnumBuilder


let scanDir = Process.argc < 2 ? "." : Process.arguments[1]

let enumBuilder = SwiftGenStoryboardEnumBuilder()
enumBuilder.parseDirectory(scanDir)
let output = enumBuilder.build()

print(output)
