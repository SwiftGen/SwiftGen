//
//  storyboards.swift
//  SwiftGen
//
//  Created by Olivier Halligon on 12/10/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import Foundation
import Commander
import SwiftGenKit

let storyboards = command(
    Argument<String>("DIR", description: "Directory to scan for .storyboard files. Can also be a path to a single .storyboard", validator: pathExists(nil)),
    outputOption
) { path, output in
    let enumBuilder = StoryboardEnumBuilder()
    if (path as NSString).pathExtension == "storyboard" {
        enumBuilder.addStoryboardAtPath(path)
    }
    else {
        enumBuilder.parseDirectory(path)
    }
    output.write(enumBuilder.build())
}
