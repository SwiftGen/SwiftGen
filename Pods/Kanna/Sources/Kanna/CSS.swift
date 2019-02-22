/**@file CSS.swift

Kanna

Copyright (c) 2015 Atsushi Kiwaki (@_tid_)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
import Foundation

import libxmlKanna

typealias AKRegularExpression  = NSRegularExpression
#if os(Linux) && swift(>=4)
typealias AKTextCheckingResult = NSTextCheckingResult
#elseif os(Linux) && swift(>=3)
typealias AKTextCheckingResult = TextCheckingResult
#else
typealias AKTextCheckingResult = NSTextCheckingResult
#endif

public enum CSSError: Error {
    case UnsupportSyntax(String)
}

/**
CSS
*/
public enum CSS {
    /**
    CSS3 selector to XPath
    
    @param selector CSS3 selector
    
    @return XPath
    */
    public static func toXPath(_ css: String) throws -> String {
        let selectorGroups = css.components(separatedBy: ",")
        return try selectorGroups
            .map { try toXPath(selector: $0) }
            .joined(separator: " | ")
    }

    private static func toXPath(selector: String) throws -> String {
        var xpath = "//"
        var str = selector
        var prev = str

        while !str.isEmpty {
            var attributes: [String] = []
            var combinator: String = ""

            str = str.trimmingCharacters(in: .whitespaces)

            // element
            let element = getElement(&str)

            // class / id
            while let attr = getClassId(&str) {
                attributes.append(attr)
            }

            // attribute
            while let attr = getAttribute(&str) {
                attributes.append(attr)
            }

            // matchCombinator
            if let combi = genCombinator(&str) {
                combinator = combi
            }

            // generate xpath phrase
            let attr = attributes.joined(separator: " and ")
            if attr.isEmpty {
                xpath += "\(element)\(combinator)"
            } else {
                xpath += "\(element)[\(attr)]\(combinator)"
            }

            if str == prev {
                throw CSSError.UnsupportSyntax(selector)
            }
            prev = str
        }
        return xpath
    }
}

private func firstMatch(_ pattern: String) -> (String) -> AKTextCheckingResult? {
    return { str in
        let length = str.utf16.count
        do {
            let regex = try AKRegularExpression(pattern: pattern, options: .caseInsensitive)
            if let result = regex.firstMatch(in: str, options: .reportProgress, range: NSRange(location: 0, length: length)) {
                return result
            }
        } catch _ {

        }
        return nil
    }
}

private func nth(prefix: String, a: Int, b: Int) -> String {
    let sibling = "\(prefix)-sibling::*"
    if a == 0 {
        return "count(\(sibling)) = \(b-1)"
    } else if a > 0 {
        if b != 0 {
            return "((count(\(sibling)) + 1) >= \(b)) and ((((count(\(sibling)) + 1)-\(b)) mod \(a)) = 0)"
        }
        return "((count(\(sibling)) + 1) mod \(a)) = 0"
    }
    let a = abs(a)
    return "(count(\(sibling)) + 1) <= \(b)" + ((a != 1) ? " and ((((count(\(sibling)) + 1)-\(b)) mod \(a) = 0)" : "")
}

// a(n) + b | a(n) - b
private func nth_child(a: Int, b: Int) -> String {
    return nth(prefix: "preceding", a: a, b: b)
}

private func nth_last_child(a: Int, b: Int) -> String {
    return nth(prefix: "following", a: a, b: b)
}

private let escapePattern = "(?:\\\\([!\"#\\$%&\'\\(\\)\\*\\+,\\./:;<=>\\?@\\[\\\\\\]\\^`\\{\\|\\}~]))"
private let escapeRepeatPattern = "\(escapePattern)*"
private let matchElement      = firstMatch("^((?:[a-z0-9\\*_-]+\(escapeRepeatPattern))+)((\\|)((?:[a-z0-9\\*_-]+\(escapeRepeatPattern))+))?")
private let matchClassId      = firstMatch("^([#.])((?:[a-z0-9\\*_-]+\(escapeRepeatPattern))+)")
private let matchAttr1        = firstMatch("^\\[([^\\]]*)\\]")
private let matchAttr2        = firstMatch("^\\[\\s*([^~\\|\\^\\$\\*=\\s]+)\\s*([~\\|\\^\\$\\*]?=)\\s*(.*)\\s*\\]")
private let matchAttrN        = firstMatch("^:not\\((.*?\\)?)\\)")
private let matchPseudo       = firstMatch("^:([\'\"()a-z0-9_+-]+)")
private let matchCombinator   = firstMatch("^\\s*([\\s>+~,])\\s*")
private let matchSubNthChild  = firstMatch("^(nth-child|nth-last-child)\\(\\s*(odd|even|\\d+)\\s*\\)")
private let matchSubNthChildN = firstMatch("^(nth-child|nth-last-child)\\(\\s*(-?\\d*)n(\\+\\d+)?\\s*\\)")
private let matchSubNthOfType = firstMatch("nth-of-type\\((odd|even|\\d+)\\)")
private let matchSubContains  = firstMatch("contains\\([\"\'](.*?)[\"\']\\)")

private func substringWithRangeAtIndex(_ result: AKTextCheckingResult, str: String, at: Int) -> String {
    if result.numberOfRanges > at {
        #if swift(>=4.0) || os(Linux)
        let range = result.range(at: at)
        #else
        let range = result.rangeAt(at)
        #endif
        if range.length > 0 {
            let startIndex = str.index(str.startIndex, offsetBy: range.location)
            let endIndex = str.index(startIndex, offsetBy: range.length)
            return String(str[startIndex..<endIndex])
        }
    }
    return ""
}

private func escapeCSS(_ text: String) -> String {
    return text.replacingOccurrences(of: escapePattern, with: "$1", options: .regularExpression, range: nil)
}

private func getElement(_ str: inout String, skip: Bool = true) -> String {
    if let result = matchElement(str) {
        let (text, text2) = (escapeCSS(substringWithRangeAtIndex(result, str: str, at: 1)),
                             escapeCSS(substringWithRangeAtIndex(result, str: str, at: 5)))
        
        if skip {
            str = String(str[str.index(str.startIndex, offsetBy: result.range.length)..<str.endIndex])
        }
        
        // tag with namespace
        if !text.isEmpty && !text2.isEmpty {
            return "\(text):\(text2)"
        }
        
        // tag
        if !text.isEmpty {
            return text
        }
    }
    return "*"
}

private func getClassId(_ str: inout String, skip: Bool = true) -> String? {
    if let result = matchClassId(str) {
        let (attr, text) = (escapeCSS(substringWithRangeAtIndex(result, str: str, at: 1)),
                            escapeCSS(substringWithRangeAtIndex(result, str: str, at: 2)))
        if skip {
            str = String(str[str.index(str.startIndex, offsetBy: result.range.length)..<str.endIndex])
        }
        
        if attr.hasPrefix("#") {
            return "@id = '\(text)'"
        } else if attr.hasPrefix(".") {
            return "contains(concat(' ', normalize-space(@class), ' '), ' \(text) ')"
        }
    }
    return nil
}

private func getAttribute(_ str: inout String, skip: Bool = true) -> String? {
    if let result = matchAttr2(str) {
        let (attr, expr, text) = (escapeCSS(substringWithRangeAtIndex(result, str: str, at: 1)),
                                  substringWithRangeAtIndex(result, str: str, at: 2),
                                  escapeCSS(substringWithRangeAtIndex(result, str: str, at: 3).replacingOccurrences(of: "[\'\"](.*)[\'\"]", with: "$1", options: .regularExpression, range: nil)))

        if skip {
            str = String(str[str.index(str.startIndex, offsetBy: result.range.length)..<str.endIndex])
        }
        
        switch expr {
        case "!=":
            return "@\(attr) != \(text)"
        case "~=":
            return "contains(concat(' ', @\(attr), ' '),concat(' ', '\(text)', ' '))"
        case "|=":
            return "@\(attr) = '\(text)' or starts-with(@\(attr),concat('\(text)', '-'))"
        case "^=":
            return "starts-with(@\(attr), '\(text)')"
        case "$=":
            return "substring(@\(attr), string-length(@\(attr)) - string-length('\(text)') + 1, string-length('\(text)')) = '\(text)'"
        case "*=":
            return "contains(@\(attr), '\(text)')"
        default:
            return "@\(attr) = '\(text)'"
        }
    } else if let result = matchAttr1(str) {
        let atr = substringWithRangeAtIndex(result, str: str, at: 1)
        if skip {
            str = String(str[str.index(str.startIndex, offsetBy: result.range.length)..<str.endIndex])
        }
        
        return "@\(atr)"
    } else if str.hasPrefix("[") {
        // bad syntax attribute
        return nil
    } else if let attr = getAttrNot(&str) {
        return "not(\(attr))"
    } else if let result = matchPseudo(str) {
        let one = substringWithRangeAtIndex(result, str: str, at: 1)
        if skip {
            str = String(str[str.index(str.startIndex, offsetBy: result.range.length)..<str.endIndex])
        }
        
        switch one {
        case "first-child":
            return "count(preceding-sibling::*) = 0"
        case "last-child":
            return "count(following-sibling::*) = 0"
        case "only-child":
            return "count(preceding-sibling::*) = 0 and count(following-sibling::*) = 0"
        case "first-of-type":
            return "position() = 1"
        case "last-of-type":
            return "position() = last()"
        case "only-of-type":
            return "last() = 1"
        case "empty":
            return "not(node())"
        case "root":
            return "not(parent::*)"
        default:
            if let sub = matchSubNthChild(one) {
                let (nth, arg1) = (substringWithRangeAtIndex(sub, str: one, at: 1),
                                   substringWithRangeAtIndex(sub, str: one, at: 2))
                
                let nthFunc = (nth == "nth-child") ? nth_child : nth_last_child
                if arg1 == "odd" {
                    return nthFunc(2, 1)
                } else if arg1 == "even" {
                    return nthFunc(2, 0)
                } else {
                    return nthFunc(0, Int(arg1)!)
                }
            } else if let sub = matchSubNthChildN(one) {
                let (nth, arg1, arg2) = (substringWithRangeAtIndex(sub, str: one, at: 1),
                                         substringWithRangeAtIndex(sub, str: one, at: 2),
                                         substringWithRangeAtIndex(sub, str: one, at: 3))
                
                let nthFunc = (nth == "nth-child") ? nth_child : nth_last_child
                let a: Int = (arg1 == "-") ? -1 : Int(arg1)!
                let b: Int = (arg2.isEmpty) ? 0 : Int(arg2)!
                return nthFunc(a, b)
            } else if let sub = matchSubNthOfType(one) {
                let arg1   = substringWithRangeAtIndex(sub, str: one, at: 1)
                if arg1 == "odd" {
                    return "(position() >= 1) and (((position()-1) mod 2) = 0)"
                } else if arg1 == "even" {
                    return "(position() mod 2) = 0"
                } else {
                    return "position() = \(arg1)"
                }
            } else if let sub = matchSubContains(one) {
                let text = substringWithRangeAtIndex(sub, str: one, at: 1)
                return "contains(., '\(text)')"
            } else {
                return nil
            }
        }
    }
    return nil
}

private func getAttrNot(_ str: inout String, skip: Bool = true) -> String? {
    if let result = matchAttrN(str) {
        var one = substringWithRangeAtIndex(result, str: str, at: 1)
        if skip {
            str = String(str[str.index(str.startIndex, offsetBy: result.range.length)..<str.endIndex])
        }
        
        if let attr = getAttribute(&one, skip: false) {
            return attr
        } else if let sub = matchElement(one) {
            #if swift(>=4.0) || os(Linux)
            let range = sub.range(at: 1)
            #else
            let range = sub.rangeAt(1)
            #endif
            let startIndex = one.index(one.startIndex, offsetBy: range.location)
            let endIndex   = one.index(startIndex, offsetBy: range.length)

            let elem = one[startIndex ..< endIndex]
            return "self::\(elem)"
        } else if let attr = getClassId(&one) {
            return attr
        }
    }
    return nil
}

private func genCombinator(_ str: inout String, skip: Bool = true) -> String? {
    if let result = matchCombinator(str) {
        let one = substringWithRangeAtIndex(result, str: str, at: 1)
        if skip {
            str = String(str[str.index(str.startIndex, offsetBy: result.range.length)..<str.endIndex])
        }
        
        switch one {
        case ">":
            return "/"
        case "+":
            return "/following-sibling::*[1]/self::"
        case "~":
            return "/following-sibling::"
        default:
            return "//"
        }
    }
    return nil
}
