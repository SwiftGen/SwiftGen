//
//  Deprecated.swift
//  Kanna
//
//  Created by Atsushi Kiwaki on 2017/10/27.
//  Copyright © 2017 Atsushi Kiwaki. All rights reserved.
//

import Foundation

//-------------------------------------------------------------
// XML
//-------------------------------------------------------------
@available(*, unavailable, message: "Use XML(xml: String, url: String?, encoding: String.Encoding, option: ParseOption). The type of the second argument has been changed to String.Encoding from UInt.")
public func XML(xml: String, url: String? = nil, encoding: UInt, option: ParseOption = kDefaultXmlParseOption) -> XMLDocument? {
    return nil
}

@available(*, unavailable, message: "Use XML(xml: Data, url: String?, encoding: String.Encoding, option: ParseOption). The type of the first argument has been changed to Data and the type of the second argument has been changed to String.Encoding from UInt.")
public func XML(xml: NSData, url: String? = nil, encoding: UInt, option: ParseOption = kDefaultXmlParseOption) ->  XMLDocument? {
    return nil
}

@available(*, unavailable, message: "Use XML(url: URL, encoding: String.Encoding, option: ParseOption). The type of the second argument has been changed to String.Encoding from UInt.")
public func XML(url: URL, encoding: UInt, option: ParseOption = kDefaultXmlParseOption) -> XMLDocument? {
    return nil
}

//-------------------------------------------------------------
// HTML
//-------------------------------------------------------------
@available(*, unavailable, message: "Use HTML(html: String, url: String?, encoding: String.Encoding, option: ParseOption). The type of the second argument has been changed to String.Encoding from UInt.")
public func HTML(html: String, url: String? = nil, encoding: UInt, option: ParseOption = kDefaultXmlParseOption) -> XMLDocument? {
    return nil
}

@available(*, unavailable, message: "Use HTML(html: Data, url: String?, encoding: String.Encoding, option: ParseOption). The type of the first argument has been changed to Data and the type of the second argument has been changed to String.Encoding from UInt.")
public func HTML(html: NSData, url: String? = nil, encoding: UInt, option: ParseOption = kDefaultXmlParseOption) ->  XMLDocument? {
    return nil
}

@available(*, unavailable, message: "Use HTML(url: URL, encoding: String.Encoding, option: ParseOption). The type of the second argument has been changed to String.Encoding from UInt.")
public func HTML(url: URL, encoding: UInt, option: ParseOption = kDefaultXmlParseOption) -> XMLDocument? {
    return nil
}
