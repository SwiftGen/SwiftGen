//
//  JSONFileParser.swift
//  Pods
//
//  Created by Peter Livesey on 9/16/16.
//
//

import Foundation
import PathKit

public final class JSONFileParser {
  public private(set) var json = [String: AnyObject]()

  public init() {}

  public func parseFile(path: Path) throws {
    let url = URL(fileURLWithPath: String(describing: path))
    let jsonData = try Data(contentsOf: url)
    if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: AnyObject] {
      self.json = json
    }
  }
}
