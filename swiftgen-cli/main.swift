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

enum PathType: String { case Directory, File }

func pathExists(type: PathType?)(path: String) throws -> String {
    var isDir = ObjCBool(false)
    let check: ObjCBool -> Bool = { isDir in
        switch type {
        case .Directory?: return isDir.boolValue == true
        case .File?: return isDir.boolValue == false
        default: return true
        }
    }
    guard NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir) && check(isDir) else {
        let displayType = type.map{$0.rawValue} ?? "path"
        throw ArgumentError.InvalidType(value: path, type: displayType, argument: nil)
    }
    return path
}

// MARK: - Main

Group {
    $0.addCommand("storyboards", storyboards)
    $0.addCommand("assets", assets)
    $0.addCommand("colors", colors)
    $0.addCommand("l10n", l10n)
}.run("SwiftGen v\(SwiftGenKitVersionNumber)")
