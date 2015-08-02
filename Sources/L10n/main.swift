import Foundation
//@import SwiftGenL10nEnumBuilder

guard Process.argc >= 2 else {
    print("Usage: swiftgen-l10n path/to/Localizable.strings")
    exit(-1)
}

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
