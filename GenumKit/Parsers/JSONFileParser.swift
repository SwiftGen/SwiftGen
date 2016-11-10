//
//  JSONFileParser.swift
//  Pods
//
//  Created by Peter Livesey on 9/16/16.
//
//

import Foundation

public final class JSONFileParser {
  public private(set) var json = [String: AnyObject]()

  public init() {}

  public func parseFile(path: String) throws {
    if let JSONdata = NSData(contentsOfFile: path),
      let json = (try? NSJSONSerialization.JSONObjectWithData(JSONdata, options: [])) as? [String: AnyObject] {
      self.json = json
    }
  }
}
