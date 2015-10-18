//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import GenumKit

let imagesCommand = command(
    outputOption,
    Argument<Path>("DIR", description: "Directory to scan for .imageset files.", validator: dirExists),
    Option<String>("excludechars", "_", description: "Characters that should be ignored in swift identifier.")
) { output, path, forbiddenChars in
    let enumBuilder = ImageEnumBuilder()
    enumBuilder.parseDirectory(String(path))
    output.write(enumBuilder.build(forbiddenChars: forbiddenChars))
}
