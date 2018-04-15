//
//  Path+AppSupport.swift
//  swiftgen
//
//  Created by Olivier HALLIGON on 11/10/2017.
//  Copyright © 2017 AliSoftware. All rights reserved.
//

import Foundation
import PathKit

extension Path {
  static let applicationSupport: Path = {
    let paths = NSSearchPathForDirectoriesInDomains(
      .applicationSupportDirectory,
      .userDomainMask,
      true
    )
    guard let path = paths.first else {
      fatalError("Unable to locate the Application Support directory on your machine!")
    }
    return Path(path)
  }()
}

let templatesRelativePath: String = {
  if let path = Bundle.main.object(forInfoDictionaryKey: "TemplatePath") as? String, !path.isEmpty {
    return path
  } else if let path = Bundle.main.path(forResource: "templates", ofType: nil) {
    return path
  } else {
    return "../templates"
  }
}()

let appSupportTemplatesPath = Path.applicationSupport + "SwiftGen/templates"
let bundledTemplatesPath = Path(ProcessInfo.processInfo.arguments[0]).parent() + templatesRelativePath
