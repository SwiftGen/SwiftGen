//
//  fonts.swift
//  SwiftGen
//
//  Created by Derek Ostrander on 3/10/16.
//  Copyright © 2016 AliSoftware. All rights reserved.
//

import Commander
import PathKit
import GenumKit

let fontsCommand = command(
    outputOption,
    templateOption("fonts"), templatePathOption,
    Option<String>("enumName", "Family", flag: "e", description: "The name of the enum to generate"),
    Argument<Path>("DIR", description: "Directory to parse.", validator: dirExists)
    ) { output, templateName, templatePath, enumName, path in
        let parser = FontsFileParser()
        do {
            parser.parseFonts(String(path))
            let templateRealPath = try findTemplate("fonts", templateShortName: templateName, templateFullPath: templatePath)
            let template = try GenumTemplate(path: templateRealPath)
            let context = parser.stencilContext(enumName: enumName)
            let rendered = try template.render(context)
            output.write(rendered, onlyIfChanged: true)
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
}
