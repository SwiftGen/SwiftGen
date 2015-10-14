//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation
import Commander
import GenumKit

let storyboardsCommand = command(
    outputOption,
    Argument<String>("PATH", description: "Directory to scan for .storyboard files. Can also be a path to a single .storyboard", validator: pathExists(nil))
) { output, path in
    let enumBuilder = StoryboardEnumBuilder()
    if (path as NSString).pathExtension == "storyboard" {
        enumBuilder.addStoryboardAtPath(path)
    }
    else {
        enumBuilder.parseDirectory(path)
    }
    output.write(enumBuilder.build())
}
