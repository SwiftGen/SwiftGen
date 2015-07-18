import Foundation
import SwiftGenAssetsEnumBuilder


let scanDir = Process.argc < 2 ? "." : Process.arguments[1]

let enumBuilder = SwiftGenAssetsEnumBuilder()
enumBuilder.parseDirectory(scanDir)
let output = enumBuilder.build()

print(output)
