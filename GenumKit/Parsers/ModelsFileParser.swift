//
//  ModelsFileParser.swift
//  Pods
//
//  Created by Peter Livesey on 9/16/16.
//
//

import Foundation

public final class ModelsJSONFileParser {
    public private(set) var json = [String: AnyObject]()

    public init() {}

    public func parseFile(path: String) throws {
        if let JSONdata = NSData(contentsOfFile: path),
            let json = (try? NSJSONSerialization.JSONObjectWithData(JSONdata, options: [])) as? [String: AnyObject] {
            self.json = json
        }
    }

    public func parseDirectory(path: String) throws {
        if let dirEnum = NSFileManager.defaultManager().enumeratorAtPath(path) {
            while let subPath = dirEnum.nextObject() as? NSString {
                try parseFile((path as NSString).stringByAppendingPathComponent(subPath as String))
            }
        }
    }
}
