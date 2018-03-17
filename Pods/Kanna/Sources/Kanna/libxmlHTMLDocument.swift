/**@file libxmlHTMLDocument.swift

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
import CoreFoundation

#if SWIFT_PACKAGE
import SwiftClibxml2
#else
import libxmlKanna
#endif

extension String.Encoding {
    var IANACharSetName: String? {
        #if os(Linux)
        switch self {
        case .ascii:
            return "us-ascii"
        case .iso2022JP:
            return "iso-2022-jp"
        case .isoLatin1:
            return "iso-8859-1"
        case .isoLatin2:
            return "iso-8859-2"
        case .japaneseEUC:
            return "euc-jp"
        case .macOSRoman:
            return "macintosh"
        case .nextstep:
            return "x-nextstep"
        case .nonLossyASCII:
            return nil
        case .shiftJIS:
            return "cp932"
        case .symbol:
            return "x-mac-symbol"
        case .unicode:
            return "utf-16"
        case .utf16:
            return "utf-16"
        case .utf16BigEndian:
            return "utf-16be"
        case .utf32:
            return "utf-32"
        case .utf32BigEndian:
            return "utf-32be"
        case .utf32LittleEndian:
            return "utf-32le"
        case .utf8:
            return "utf-8"
        case .windowsCP1250:
            return "windows-1250"
        case .windowsCP1251:
            return "windows-1251"
        case .windowsCP1252:
            return "windows-1252"
        case .windowsCP1253:
            return "windows-1253"
        case .windowsCP1254:
            return "windows-1254"
        default:
            return nil
        }
        #else
        let cfenc = CFStringConvertNSStringEncodingToEncoding(self.rawValue)
        guard let cfencstr = CFStringConvertEncodingToIANACharSetName(cfenc) else {
            return nil
        }
        return String(describing: cfencstr)
        #endif
    }
}

/*
libxmlHTMLDocument
*/
internal final class libxmlHTMLDocument: HTMLDocument {
    fileprivate var docPtr:   htmlDocPtr? = nil
    fileprivate var rootNode: XMLElement?
    fileprivate var html: String
    fileprivate var url:  String?
    fileprivate var encoding: String.Encoding
    
    var text: String? {
        return rootNode?.text
    }

    var toHTML: String? {
        let buf = xmlBufferCreate()
        defer {
            xmlBufferFree(buf)
        }

        let outputBuf = xmlOutputBufferCreateBuffer(buf, nil)
        htmlDocContentDumpOutput(outputBuf, docPtr, nil)
        let html = String(cString: UnsafePointer(xmlOutputBufferGetContent(outputBuf)))
        return html
    }

    var toXML: String? {
        var buf: UnsafeMutablePointer<xmlChar>? = nil
        let size: UnsafeMutablePointer<Int32>? = nil
        defer {
            xmlFree(buf)
        }

        xmlDocDumpMemory(docPtr, &buf, size)
        let html = String(cString: UnsafePointer(buf!))
        return html
    }
    
    var innerHTML: String? {
        return rootNode?.innerHTML
    }
    
    var className: String? {
        return nil
    }
    
    var tagName:   String? {
        get {
            return nil
        }

        set {

        }
    }

    var content: String? {
        get {
            return text
        }

        set {
            rootNode?.content = newValue
        }
    }
    
    init(html: String, url: String?, encoding: String.Encoding, option: UInt) throws {
        self.html = html
        self.url  = url
        self.encoding = encoding
        
        guard html.lengthOfBytes(using: encoding) > 0 else {
            throw ParseError.Empty
        }

        guard let charsetName = encoding.IANACharSetName,
            let cur = html.cString(using: encoding) else {
            throw ParseError.EncodingMismatch
        }
        
        let url : String = ""
        docPtr = htmlReadDoc(UnsafeRawPointer(cur).assumingMemoryBound(to: xmlChar.self), url, charsetName, CInt(option))
        
        guard let docPtr = docPtr else {
            throw ParseError.EncodingMismatch
        }
        
        rootNode  = libxmlHTMLNode(document: self, docPtr: docPtr)
    }
    
    deinit {
        xmlFreeDoc(self.docPtr)
    }

    var title: String? { return at_xpath("//title")?.text }
    var head: XMLElement? { return at_xpath("//head") }
    var body: XMLElement? { return at_xpath("//body") }
    
    func xpath(_ xpath: String, namespaces: [String:String]?) -> XPathObject {
        return rootNode?.xpath(xpath, namespaces: namespaces) ?? XPathObject.none
    }
    
    func xpath(_ xpath: String) -> XPathObject {
        return self.xpath(xpath, namespaces: nil)
    }
    
    func at_xpath(_ xpath: String, namespaces: [String:String]?) -> XMLElement? {
        return rootNode?.at_xpath(xpath, namespaces: namespaces)
    }
    
    func at_xpath(_ xpath: String) -> XMLElement? {
        return self.at_xpath(xpath, namespaces: nil)
    }
    
    func css(_ selector: String, namespaces: [String:String]?) -> XPathObject {
        return rootNode?.css(selector, namespaces: namespaces) ?? XPathObject.none
    }
    
    func css(_ selector: String) -> XPathObject {
        return self.css(selector, namespaces: nil)
    }
    
    func at_css(_ selector: String, namespaces: [String:String]?) -> XMLElement? {
        return rootNode?.at_css(selector, namespaces: namespaces)
    }
    
    func at_css(_ selector: String) -> XMLElement? {
        return self.at_css(selector, namespaces: nil)
    }
}

/*
libxmlXMLDocument
*/
internal final class libxmlXMLDocument: XMLDocument {
    fileprivate var docPtr:   xmlDocPtr? = nil
    fileprivate var rootNode: XMLElement?
    fileprivate var xml: String
    fileprivate var url: String?
    fileprivate var encoding: String.Encoding
    
    var text: String? {
        return rootNode?.text
    }
    
    var toHTML: String? {
        let buf = xmlBufferCreate()
        defer {
            xmlBufferFree(buf)
        }

        let outputBuf = xmlOutputBufferCreateBuffer(buf, nil)
        htmlDocContentDumpOutput(outputBuf, docPtr, nil)
        let html = String(cString: UnsafePointer(xmlOutputBufferGetContent(outputBuf)))
        return html
    }

    var toXML: String? {
        var buf: UnsafeMutablePointer<xmlChar>? = nil
        let size: UnsafeMutablePointer<Int32>? = nil
        defer {
            xmlFree(buf)
        }

        xmlDocDumpMemory(docPtr, &buf, size)
        let html = String(cString: UnsafePointer(buf!))
        return html
    }
    
    var innerHTML: String? {
        return rootNode?.innerHTML
    }
    
    var className: String? {
        return nil
    }
    
    var tagName:   String? {
        get {
            return nil
        }

        set {
            
        }
    }

    var content: String? {
        get {
            return text
        }

        set {
            rootNode?.content = newValue
        }
    }
    
    init(xml: String, url: String?, encoding: String.Encoding, option: UInt) throws {
        self.xml  = xml
        self.url  = url
        self.encoding = encoding
        
        if xml.isEmpty {
            throw ParseError.Empty
        }


        guard let charsetName = encoding.IANACharSetName,
            let cur = xml.cString(using: encoding) else {
                throw ParseError.EncodingMismatch
        }
        let url : String = ""
        docPtr = xmlReadDoc(UnsafeRawPointer(cur).assumingMemoryBound(to: xmlChar.self), url, charsetName, CInt(option))
        rootNode  = libxmlHTMLNode(document: self, docPtr: docPtr!)
    }

    deinit {
        xmlFreeDoc(self.docPtr)
    }
    
    func xpath(_ xpath: String, namespaces: [String:String]?) -> XPathObject {
        return rootNode?.xpath(xpath, namespaces: namespaces) ?? XPathObject.none
    }
    
    func xpath(_ xpath: String) -> XPathObject {
        return self.xpath(xpath, namespaces: nil)
    }
    
    func at_xpath(_ xpath: String, namespaces: [String:String]?) -> XMLElement? {
        return rootNode?.at_xpath(xpath, namespaces: namespaces)
    }
    
    func at_xpath(_ xpath: String) -> XMLElement? {
        return self.at_xpath(xpath, namespaces: nil)
    }
    
    func css(_ selector: String, namespaces: [String:String]?) -> XPathObject {
        return rootNode?.css(selector, namespaces: namespaces) ?? XPathObject.none
    }
    
    func css(_ selector: String) -> XPathObject {
        return self.css(selector, namespaces: nil)
    }
    
    func at_css(_ selector: String, namespaces: [String:String]?) -> XMLElement? {
        return rootNode?.at_css(selector, namespaces: namespaces)
    }
    
    func at_css(_ selector: String) -> XMLElement? {
        return self.at_css(selector, namespaces: nil)
    }
}
