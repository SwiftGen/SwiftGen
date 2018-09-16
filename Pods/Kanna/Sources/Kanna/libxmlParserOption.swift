/**@file libxmlParserOption.swift

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

#if SWIFT_PACKAGE
import SwiftClibxml2
#else
import libxmlKanna
#endif

/*
Libxml2HTMLParserOptions
*/
public struct Libxml2HTMLParserOptions : OptionSet {
    public typealias RawValue = UInt
    private var value: UInt = 0
    init(_ value: UInt) { self.value = value }
    private init(_ opt: htmlParserOption) { self.value = UInt(opt.rawValue) }
    public init(rawValue value: UInt) { self.value = value }
    public init(nilLiteral: ()) { self.value = 0 }
    public static var allZeros: Libxml2HTMLParserOptions { return .init(0) }
    static func fromMask(raw: UInt) -> Libxml2HTMLParserOptions { return .init(raw) }
    public var rawValue: UInt { return self.value }
    
    public static let STRICT     = Libxml2HTMLParserOptions(0)
    public static let RECOVER    = Libxml2HTMLParserOptions(HTML_PARSE_RECOVER)
    public static let NODEFDTD   = Libxml2HTMLParserOptions(HTML_PARSE_NODEFDTD)
    public static let NOERROR    = Libxml2HTMLParserOptions(HTML_PARSE_NOERROR)
    public static let NOWARNING  = Libxml2HTMLParserOptions(HTML_PARSE_NOWARNING)
    public static let PEDANTIC   = Libxml2HTMLParserOptions(HTML_PARSE_PEDANTIC)
    public static let NOBLANKS   = Libxml2HTMLParserOptions(HTML_PARSE_NOBLANKS)
    public static let NONET      = Libxml2HTMLParserOptions(HTML_PARSE_NONET)
    public static let NOIMPLIED  = Libxml2HTMLParserOptions(HTML_PARSE_NOIMPLIED)
    public static let COMPACT    = Libxml2HTMLParserOptions(HTML_PARSE_COMPACT)
    public static let IGNORE_ENC = Libxml2HTMLParserOptions(HTML_PARSE_IGNORE_ENC)
}

/*
Libxml2XMLParserOptions
*/
public struct Libxml2XMLParserOptions: OptionSet {
    public typealias RawValue = UInt
    private var value: UInt = 0
    init(_ value: UInt) { self.value = value }
    private init(_ opt: xmlParserOption) { self.value = UInt(opt.rawValue) }
    public init(rawValue value: UInt) { self.value = value }
    public init(nilLiteral: ()) { self.value = 0 }
    public static var allZeros: Libxml2XMLParserOptions { return .init(0) }
    static func fromMask(raw: UInt) -> Libxml2XMLParserOptions { return .init(raw) }
    public var rawValue: UInt { return self.value }
    
    public static let STRICT     = Libxml2XMLParserOptions(0)
    public static let RECOVER    = Libxml2XMLParserOptions(XML_PARSE_RECOVER)
    public static let NOENT      = Libxml2XMLParserOptions(XML_PARSE_NOENT)
    public static let DTDLOAD    = Libxml2XMLParserOptions(XML_PARSE_DTDLOAD)
    public static let DTDATTR    = Libxml2XMLParserOptions(XML_PARSE_DTDATTR)
    public static let DTDVALID   = Libxml2XMLParserOptions(XML_PARSE_DTDVALID)
    public static let NOERROR    = Libxml2XMLParserOptions(XML_PARSE_NOERROR)
    public static let NOWARNING  = Libxml2XMLParserOptions(XML_PARSE_NOWARNING)
    public static let PEDANTIC   = Libxml2XMLParserOptions(XML_PARSE_PEDANTIC)
    public static let NOBLANKS   = Libxml2XMLParserOptions(XML_PARSE_NOBLANKS)
    public static let SAX1       = Libxml2XMLParserOptions(XML_PARSE_SAX1)
    public static let XINCLUDE   = Libxml2XMLParserOptions(XML_PARSE_XINCLUDE)
    public static let NONET      = Libxml2XMLParserOptions(XML_PARSE_NONET)
    public static let NODICT     = Libxml2XMLParserOptions(XML_PARSE_NODICT)
    public static let NSCLEAN    = Libxml2XMLParserOptions(XML_PARSE_NSCLEAN)
    public static let NOCDATA    = Libxml2XMLParserOptions(XML_PARSE_NOCDATA)
    public static let NOXINCNODE = Libxml2XMLParserOptions(XML_PARSE_NOXINCNODE)
    public static let COMPACT    = Libxml2XMLParserOptions(XML_PARSE_COMPACT)
    public static let OLD10      = Libxml2XMLParserOptions(XML_PARSE_OLD10)
    public static let NOBASEFIX  = Libxml2XMLParserOptions(XML_PARSE_NOBASEFIX)
    public static let HUGE       = Libxml2XMLParserOptions(XML_PARSE_HUGE)
    public static let OLDSAX     = Libxml2XMLParserOptions(XML_PARSE_OLDSAX)
    public static let IGNORE_ENC = Libxml2XMLParserOptions(XML_PARSE_IGNORE_ENC)
    public static let BIG_LINES  = Libxml2XMLParserOptions(XML_PARSE_BIG_LINES)
}
