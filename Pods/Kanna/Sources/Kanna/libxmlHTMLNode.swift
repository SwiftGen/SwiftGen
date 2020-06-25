/**@file libxmlHTMLNode.swift

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
import libxml2

/**
libxmlHTMLNode
*/
final class libxmlHTMLNode: XMLElement {
    var text: String? {
        guard let nodePtr = nodePtr else { return nil }
        return libxmlGetNodeContent(nodePtr)
    }

    var toHTML: String? {
        let buf = xmlBufferCreate()
        htmlNodeDump(buf, docPtr, nodePtr)
        let html = String(cString: UnsafePointer<UInt8>((buf?.pointee.content)!))
        xmlBufferFree(buf)
        return html
    }

    var toXML: String? {
        let buf = xmlBufferCreate()
        xmlNodeDump(buf, docPtr, nodePtr, 0, 0)
        let html = String(cString: UnsafePointer<UInt8>((buf?.pointee.content)!))
        xmlBufferFree(buf)
        return html
    }

    var innerHTML: String? {
        guard let html = toHTML else { return nil }
        return html
            .replacingOccurrences(of: "</[^>]*>$", with: "", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "^<[^>]*>", with: "", options: .regularExpression, range: nil)
    }

    var className: String? {
        self["class"]
    }

    var tagName: String? {
        get {
            guard let name = nodePtr?.pointee.name else {
                return nil
            }
            return String(cString: name)
        }
        set {
            if let newValue = newValue {
                xmlNodeSetName(nodePtr, newValue)
            }
        }
    }

    var content: String? {
        get { text }
        set {
            if let newValue = newValue {
                let v = escape(newValue)
                xmlNodeSetContent(nodePtr, v)
            }
        }
    }

    var parent: XMLElement? {
        get {
            libxmlHTMLNode(document: doc, docPtr: docPtr!, node: (nodePtr?.pointee.parent)!)
        }
        set {
            if let node = newValue as? libxmlHTMLNode {
                node.addChild(self)
            }
        }
    }

    var nextSibling: XMLElement? {
        node(from: xmlNextElementSibling(nodePtr))
    }

    var previousSibling: XMLElement? {
        node(from: xmlPreviousElementSibling(nodePtr))
    }

    private weak var weakDocument: XMLDocument?
    private var document: XMLDocument?
    private var docPtr: htmlDocPtr?
    private var nodePtr: xmlNodePtr?
    private var isRoot = false
    private var doc: XMLDocument? {
        weakDocument ?? document
    }

    subscript(attributeName: String) -> String? {
        get {
            var attr = nodePtr?.pointee.properties
            while attr != nil {
                let mem = attr?.pointee
                if let tagName = String(validatingUTF8: UnsafeRawPointer((mem?.name)!).assumingMemoryBound(to: CChar.self)) {
                    if attributeName == tagName {
                        if let children = mem?.children {
                            return libxmlGetNodeContent(children)
                        } else {
                            return ""
                        }
                    }
                }
                attr = attr?.pointee.next
            }
            return nil
        }
        set(newValue) {
            if let newValue = newValue {
                xmlSetProp(nodePtr, attributeName, newValue)
            } else {
                xmlUnsetProp(nodePtr, attributeName)
            }
        }
    }

    init(document: XMLDocument?, docPtr: xmlDocPtr) {
        self.weakDocument = document
        self.docPtr       = docPtr
        self.nodePtr      = xmlDocGetRootElement(docPtr)
        self.isRoot       = true
    }

    init(document: XMLDocument?, docPtr: xmlDocPtr, node: xmlNodePtr) {
        self.document = document
        self.docPtr   = docPtr
        self.nodePtr  = node
    }

    // MARK: Searchable
    func xpath(_ xpath: String, namespaces: [String: String]?) -> XPathObject {
        let ctxt = xmlXPathNewContext(docPtr)
        if ctxt == nil {
            return .none
        }
        ctxt?.pointee.node = nodePtr

        if let nsDictionary = namespaces {
            for (ns, name) in nsDictionary {
                xmlXPathRegisterNs(ctxt, ns, name)
            }
        }

        let result = xmlXPathEvalExpression(xpath, ctxt)
        defer {
            xmlXPathFreeObject(result)
        }
        xmlXPathFreeContext(ctxt)
        if result == nil {
            return .none
        }

        return XPathObject(document: doc, docPtr: docPtr!, object: result!.pointee)
    }

    func xpath(_ xpath: String) -> XPathObject {
        self.xpath(xpath, namespaces: nil)
    }

    func at_xpath(_ xpath: String, namespaces: [String: String]?) -> XMLElement? {
        self.xpath(xpath, namespaces: namespaces).nodeSetValue.first
    }

    func at_xpath(_ xpath: String) -> XMLElement? {
        self.at_xpath(xpath, namespaces: nil)
    }

    func css(_ selector: String, namespaces: [String: String]?) -> XPathObject {
        if let xpath = try? CSS.toXPath(selector, isRoot: isRoot) {
            return self.xpath(xpath, namespaces: namespaces)
        }
        return .none
    }

    func css(_ selector: String) -> XPathObject {
        self.css(selector, namespaces: nil)
    }

    func at_css(_ selector: String, namespaces: [String: String]?) -> XMLElement? {
        self.css(selector, namespaces: namespaces).nodeSetValue.first
    }

    func at_css(_ selector: String) -> XMLElement? {
        self.css(selector, namespaces: nil).nodeSetValue.first
    }

    func addPrevSibling(_ node: XMLElement) {
        guard let node = node as? libxmlHTMLNode else {
            return
        }
        xmlAddPrevSibling(nodePtr, node.nodePtr)
    }

    func addNextSibling(_ node: XMLElement) {
        guard let node = node as? libxmlHTMLNode else {
            return
        }
        xmlAddNextSibling(nodePtr, node.nodePtr)
    }

    func addChild(_ node: XMLElement) {
        guard let node = node as? libxmlHTMLNode else {
            return
        }
        xmlUnlinkNode(node.nodePtr)
        xmlAddChild(nodePtr, node.nodePtr)
    }

    func removeChild(_ node: XMLElement) {
        guard let node = node as? libxmlHTMLNode else {
            return
        }
        xmlUnlinkNode(node.nodePtr)
        xmlFree(node.nodePtr)
    }

    private func node(from ptr: xmlNodePtr?) -> XMLElement? {
        guard let doc = doc, let docPtr = docPtr, let nodePtr = ptr else {
            return nil
        }

        return libxmlHTMLNode(document: doc, docPtr: docPtr, node: nodePtr)
    }
}

private func libxmlGetNodeContent(_ nodePtr: xmlNodePtr) -> String? {
    let content = xmlNodeGetContent(nodePtr)
    defer {
        #if swift(>=4.1)
        content?.deallocate()
        #else
        content?.deallocate(capacity: 1)
        #endif
    }
    if let result  = String(validatingUTF8: UnsafeRawPointer(content!).assumingMemoryBound(to: CChar.self)) {
        return result
    }
    return nil
}

let entities = [
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;"
]

private func escape(_ str: String) -> String {
    var newStr = str
    for (unesc, esc) in entities {
        newStr = newStr.replacingOccurrences(of: unesc, with: esc, options: .regularExpression, range: nil)
    }
    return newStr
}
