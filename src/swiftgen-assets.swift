import Foundation
import SwiftGenAssetsEnumBuilder


let scanDir = Process.argc < 2 ? "." : Process.arguments[1]

let enumBuilder = SwiftGenAssetsEnumBuilder()
enumBuilder.parseDirectory(scanDir)
print(enumBuilder.build())
