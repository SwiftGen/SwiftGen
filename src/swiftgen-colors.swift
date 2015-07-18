import Foundation
import SwiftGenColorEnumBuilder


let filePath = Process.argc < 2 ? "." : Process.arguments[1]

let enumBuilder = SwiftGenColorEnumBuilder()
do {
  try enumBuilder.parseTextFile(filePath)
  let output = enumBuilder.build()

  print(output)
}
catch let error as NSError {
  print("Error: \(error.localizedDescription)")
}
