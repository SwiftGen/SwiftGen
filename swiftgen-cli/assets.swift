//
//  assets.swift
//  SwiftGen
//
//  Created by Olivier Halligon on 13/10/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import Foundation
import Commander
import SwiftGenKit

let assets = command(
    Argument<String>("DIR", description: "Directory to scan for .imageset files.", validator: pathExists(true)),
    outputOption
) { path, output in
    let enumBuilder = AssetsEnumBuilder()
    enumBuilder.parseDirectory(path)
    output.write(enumBuilder.build())
}
