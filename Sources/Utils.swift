//
//  Utils.swift
//  swiftgen
//
//  Created by Olivier HALLIGON on 12/10/2017.
//  Copyright © 2017 AliSoftware. All rights reserved.
//

import Foundation

// MARK: Printing on stderr

func printError(string: String) {
  fputs("\(string)\n", stderr)
}
