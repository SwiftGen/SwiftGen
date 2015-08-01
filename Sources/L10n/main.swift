import Foundation
//@import SwiftGenL10nEnumBuilder


let filePath = Process.argc < 2 ? "." : Process.arguments[1]

let enumBuilder = SwiftGenL10nEnumBuilder()
do {
  try enumBuilder.parseLocalizableStringsFile(filePath)
  let output = enumBuilder.build()

  print(output)
}
catch let error as NSError {
  print("Error: \(error.localizedDescription)")
}
