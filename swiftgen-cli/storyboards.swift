//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import GenumKit

let storyboardsCommand = command(
    outputOption,
    Argument<Path>("PATH", description: "Directory to scan for .storyboard files. Can also be a path to a single .storyboard", validator: pathExists),
    Option<String>("excludechars", "_", description: "Characters that should be ignored in swift identifier.")
) { output, path, forbiddenChars in
    let enumBuilder = StoryboardEnumBuilder()
    if path.`extension` == "storyboard" {
        enumBuilder.addStoryboardAtPath(String(path))
    }
    else {
        enumBuilder.parseDirectory(String(path))
    }
    output.write(enumBuilder.build(forbiddenChars: forbiddenChars))
}
