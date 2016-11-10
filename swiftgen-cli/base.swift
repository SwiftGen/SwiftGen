//
//  base.swift
//  SwiftGen
//
//  Created by Peter Livesey on 11/10/16.
//  Copyright © 2016 AliSoftware. All rights reserved.
//

import Commander
import PathKit
import GenumKit
import Stencil

let baseCommand = command(
  outputOption,
  templateOption("base"),
  templatePathOption
) { output, templateName, templatePath in
  do {
    let templateRealPath = try findTemplate("base", templateShortName: templateName, templateFullPath: templatePath)
    let template = try GenumTemplate(path: templateRealPath)
    let context = Context(dictionary: [:], namespace: GenumNamespace())
    let rendered = try template.render(context)
    output.write(rendered, onlyIfChanged: true)
  } catch let error as NSError {
    printError("error: \(error.localizedDescription)")
  }
}
