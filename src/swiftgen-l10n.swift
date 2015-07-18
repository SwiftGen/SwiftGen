import Foundation
import SwiftGenL10nEnumBuilder


let filePath = Process.argc < 2 ? "." : Process.arguments[1]

let enumBuilder = SwiftGenL10nEnumBuilder()
do {
  try enumBuilder.parseLocalizableStringsFile(filePath)
  print(enumBuilder.build())
}
catch let error as NSError {
  print("Error: \(error.localizedDescription)")
}
