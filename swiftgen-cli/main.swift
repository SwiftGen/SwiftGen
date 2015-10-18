//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import GenumKit

// MARK: - Main

let version: String = {
    let info = NSBundle(forClass: GenumKit.ImageEnumBuilder.self).infoDictionary
    return info.flatMap { $0["CFBundleShortVersionString"] as? String } ?? "0.0"
}()

Group {
    $0.addCommand("storyboards", storyboardsCommand)
    $0.addCommand("images", imagesCommand)
    $0.addCommand("colors", colorsCommand)
    $0.addCommand("strings", stringsCommand)
}.run("SwiftGen v\(version)")
