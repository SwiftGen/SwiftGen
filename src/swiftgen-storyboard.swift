import Foundation
import SwiftGenStoryboardEnumFactory


let scanDir = Process.argc < 2 ? "." : Process.arguments[1]

let factory = SwiftGenStoryboardEnumFactory()
factory.parseDirectory(scanDir)
print(factory.generate())
