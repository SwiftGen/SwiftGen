//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation
import Commander
import GenumKit

let colorsCommand = command(
    outputOption,
    Argument<String>("FILE", description: "Colors.txt file to parse.", validator: pathExists(.File))
) { output, path in
    let enumBuilder = ColorEnumBuilder()
    do {
        try enumBuilder.parseTextFile(path)
        output.write(enumBuilder.build())
    }
    catch let error as NSError {
        print("Error: \(error.localizedDescription)")
    }
}
