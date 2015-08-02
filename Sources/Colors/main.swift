import Foundation
//@import SwiftGenColorEnumBuilder

guard Process.argc >= 2 else {
    print("Usage: swiftgen-colors path/to/colors.txt")
    exit(-1)
}

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
