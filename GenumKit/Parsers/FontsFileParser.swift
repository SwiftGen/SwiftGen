//
//  FontsFileParser.swift
//  Pods
//
//  Created by Derek Ostrander on 3/7/16.
//
//

import Foundation
import AppKit.NSFont

typealias Font = (name: String, variant: String)

extension CFString {
    var alphanumericString: String {
         return (self as String).componentsSeparatedByCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet).joinWithSeparator("")
    }
}

extension CTFont {
    static func loadFont(path: String) -> Font? {
        let inData = NSData(contentsOfFile: path)
        var error: Unmanaged<CFError>?
        guard
            let provider: CGDataProvider = CGDataProviderCreateWithCFData(inData),
            let font = CGFontCreateWithDataProvider(provider)
            where CTFontManagerRegisterGraphicsFont(font, &error) else {
                return nil
        }
        return CTFontCreateWithGraphicsFont(font, 0, nil, nil).font
    }

    private var font: Font? {
        let family = CTFontCopyFamilyName(self).alphanumericString
        let name = CTFontCopyFullName(self).alphanumericString.stringByReplacingOccurrencesOfString(family, withString: "")
        if family.characters.count == 0 {
            print("There was a problem detecting the name of the font. \(CTFontCopyFamilyName(self)) -- \(CTFontCopyFullName(self)) ")
            return nil
        }
        return (family, name.characters.count > 0 ? name : "Regular")
    }
}

// MARK: Interface
public final class FontsFileParser {
    public var entries: [String: Set<String>] = [:]

    public init() {}

    public func parseFonts(path: String) {
        for file in contentsOfDirectory(path) {
            let fullPath = (path as NSString).stringByAppendingPathComponent(file)
            if isDirectory(fullPath) {
                parseFonts(fullPath)
            } else if let font = CTFont.loadFont(fullPath) {
                addVariation(font.name, variation: font.variant)
            }
        }
    }

    public func printFonts() {
        for i in entries.keys {
            var str = i
            var index = 0
            for variant in entries[i]! {
                if index == 0 {
                    str = str.stringByAppendingString(" -- ")
                }

                str = str.stringByAppendingString("\(variant) ")
                index+=1
            }
            print(str)
        }
    }
}

// MARK: Entry Managment
// needs to be testable
extension FontsFileParser {
    func addVariation(name: String, variation: String) {
        if var variations = entries[name] {
            variations.insert(variation)
            entries[name] = variations
        }
        else {
            entries[name] = [variation]
        }
    }
}

// MARK: Helpers

private func contentsOfDirectory(path: String) -> [String] {
    var files: [String] = []
    do {
        files = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(path)
    } catch let err {
        print("There was a problem grabbing the contents of the directory -- \(err)")
    }

    return files
}

private func isDirectory(path: String) -> Bool {
    var isDir: ObjCBool = false
    return NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir) && isDir
}