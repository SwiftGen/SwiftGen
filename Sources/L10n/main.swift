import Foundation
//@import SwiftGenL10nEnumBuilder

guard Process.argc >= 2 else {
    print("Usage: swiftgen-l10n path/to/Localizable.strings")
    exit(-1)
}

if ["-v","--version"].contains(Process.arguments[1]) {
    print(SwiftGenVersion)
    exit(0)
}

// MARK: Main Entry Point

let filePath = Process.arguments[1]

let enumBuilder = SwiftGenL10nEnumBuilder()
do {
    try enumBuilder.parseLocalizableStringsFile(filePath)
    let output = enumBuilder.build()
    
    print(output)
}
catch let error as NSError {
    print("Error: \(error.localizedDescription)")
}
