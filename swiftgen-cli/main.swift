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

// MARK: Validators

func pathExists(mustBeDir: Bool?)(path: String) throws -> String {
    var isDir = ObjCBool(false)
    let check: ObjCBool -> Bool = { isDir in
        return mustBeDir.map { $0 == isDir.boolValue } ?? true
    }
    guard NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir) && check(isDir) else {
        throw ArgumentError.InvalidType(value: path, type: "directory", argument: nil)
    }
    return path
}

// MARK: - Main

Group {
    $0.addCommand("storyboards", storyboards)
    $0.addCommand("assets", assets)
}.run("SwiftGen v\(SwiftGenKitVersionNumber)")
