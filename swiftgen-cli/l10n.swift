//
//  l10n.swift
//  SwiftGen
//
//  Created by Olivier Halligon on 13/10/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import Foundation
import Commander
import SwiftGenKit

let l10n = command(
    outputOption,
    Argument<String>("FILE", description: "Localizable.strings file to parse.", validator: pathExists(.File))
) { output, path in
    let enumBuilder = L10nEnumBuilder()
    do {
        try enumBuilder.parseLocalizableStringsFile(path)
        output.write(enumBuilder.build())
    }
    catch let error as NSError {
        print("Error: \(error.localizedDescription)")
    }
}
