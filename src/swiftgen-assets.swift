#!/usr/bin/env xcrun swift -I ./lib -L ./lib

import Foundation
import SwiftGenAssetsEnumFactory


let scanDir = Process.argc < 2 ? "." : Process.arguments[1]

let factory = SwiftGenAssetsEnumFactory()
factory.parseDirectory(scanDir)
print(factory.generate())
