//
//  main.swift
//  swiftgen
//
//  Created by Olivier Halligon on 12/10/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import Foundation
import Commander
import SwiftGenKit

// MARK: Helpers

func pathExists(mustBeDir: Bool?)(path: String) throws -> String {
    var isDir = ObjCBool(false)
    guard NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir) && isDir.boolValue else {
        throw ArgumentError.InvalidType(value: path, type: "directory", argument: nil)
    }
    return path
}

let outputOption = Option("output", OutputDestination.Console, description: "The path to the file to generate. Use - to generate in stdout")

// MARK: - Main

Group {
    $0.command("version") { _ in
        print(SwiftGenKitVersionNumber)
    }

    $0.addCommand("storyboards", storyboards)
    $0.addCommand("assets", assets)
}.run()


