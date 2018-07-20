//
//  CoreDataParser.swift
//  SwiftGenKit
//
//  Created by Grant Butler on 7/18/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation
import Kanna
import PathKit

public enum CoreData {
  public final class Parser: SwiftGenKit.Parser {
    public var warningHandler: Parser.MessageHandler?
    var models: [Model] = []

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
      self.warningHandler = warningHandler
    }

    public func parse(path: Path) throws {
    }
  }
}
