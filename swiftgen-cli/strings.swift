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
    Argument<String>("FILE", description: "Localizable.strings file to parse.", validator: pathExists(.File)),
    Option<String>("excludechars", "_", description: "Characters that should be ignored in swift identifier.")
) { output, path, forbiddenChars in
    let enumBuilder = StringEnumBuilder()
    do {
        try enumBuilder.parseLocalizableStringsFile(path)
        output.write(enumBuilder.build(forbiddenChars: forbiddenChars))
    }
    catch let error as NSError {
        print("Error: \(error.localizedDescription)")
    }
}
