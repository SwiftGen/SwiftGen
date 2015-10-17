//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation
import Commander
import GenumKit

let imagesCommand = command(
    outputOption,
    Argument<String>("DIR", description: "Directory to scan for .imageset files.", validator: pathExists(.Directory)),
    Option<String>("excludechars", "_", description: "Characters that should be ignored in swift identifier.")
) { output, path, forbiddenChars in
    let enumBuilder = ImageEnumBuilder()
    enumBuilder.parseDirectory(path)
    output.write(enumBuilder.build(forbiddenChars: forbiddenChars))
}
