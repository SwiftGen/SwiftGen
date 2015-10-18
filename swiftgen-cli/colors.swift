//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import GenumKit

let colorsCommand = command(
    outputOption,
    Argument<Path>("FILE", description: "Colors.txt file to parse.", validator: fileExists)
) { output, path in
    let enumBuilder = ColorEnumBuilder()
    do {
        try enumBuilder.parseTextFile(String(path))
        output.write(enumBuilder.build())
    }
    catch let error as NSError {
        print("Error: \(error.localizedDescription)")
    }
}
