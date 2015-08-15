import Foundation
//@import SwiftGenColorEnumBuilder

guard Process.argc >= 2 else {
    print("Usage: swiftgen-colors path/to/colors.txt")
    exit(-1)
}

if ["-v","--version"].contains(Process.arguments[1]) {
    print(SwiftGenVersion)
    exit(0)
}

// MARK: Main Entry Point

let filePath = Process.arguments[1]

let enumBuilder = SwiftGenColorEnumBuilder()
do {
    try enumBuilder.parseTextFile(filePath)
    let output = enumBuilder.build()
    
    print(output)
}
catch let error as NSError {
    print("Error: \(error.localizedDescription)")
}
