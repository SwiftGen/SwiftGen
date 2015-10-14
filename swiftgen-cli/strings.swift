//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation
import Commander
import GenumKit

let stringsCommand = command(
    outputOption,
    Argument<String>("FILE", description: "Localizable.strings file to parse.", validator: pathExists(.File))
) { output, path in
    let enumBuilder = StringEnumBuilder()
    do {
        try enumBuilder.parseLocalizableStringsFile(path)
        output.write(enumBuilder.build())
    }
    catch let error as NSError {
        print("Error: \(error.localizedDescription)")
    }
}
