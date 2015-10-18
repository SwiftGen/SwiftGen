//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import GenumKit
import PathKit

// MARK: Common

let version: String = {
    let info = NSBundle(forClass: GenumKit.GenumTemplate.self).infoDictionary
    return info.flatMap { $0["CFBundleShortVersionString"] as? String } ?? "0.0"
}()

let outputOption = Option("output", OutputDestination.Console, flag: "o", description: "The path to the file to generate. Use - to generate in stdout")

func templateOption(name: String) -> Option<Path> {
  let defaultTemplate = Path(NSBundle.mainBundle().executablePath!) + "/../share/templates/" + name
  return Option<Path>("template", defaultTemplate, flag: "t", description: "The template to use for code generation.", validator: fileExists)
}


// MARK: - Main

Group {
    $0.addCommand("storyboards", storyboardsCommand)
    $0.addCommand("images", imagesCommand)
    $0.addCommand("colors", colorsCommand)
    $0.addCommand("strings", stringsCommand)
}.run("SwiftGen v\(version)")
