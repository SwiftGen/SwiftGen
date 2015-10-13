//
//  colors.swift
//  SwiftGen
//
//  Created by Olivier Halligon on 13/10/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import Foundation
import Commander
import SwiftGenKit

let colors = command(
    outputOption,
    Argument<String>("FILE", description: "Colors.txt file to parse.", validator: pathExists(.File))
) { output, path in
    let enumBuilder = SwiftGenColorEnumBuilder()
    do {
        try enumBuilder.parseTextFile(path)
        output.write(enumBuilder.build())
    }
    catch let error as NSError {
        print("Error: \(error.localizedDescription)")
    }
}
