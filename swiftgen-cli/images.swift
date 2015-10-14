//
//  assets.swift
//  SwiftGen
//
//  Created by Olivier Halligon on 13/10/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import Foundation
import Commander
import GenumKit

let imagesCommand = command(
    outputOption,
    Argument<String>("DIR", description: "Directory to scan for .imageset files.", validator: pathExists(.Directory))
) { output, path in
    let enumBuilder = AssetsEnumBuilder()
    enumBuilder.parseDirectory(path)
    output.write(enumBuilder.build())
}
