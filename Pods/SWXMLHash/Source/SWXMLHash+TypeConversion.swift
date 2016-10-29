//
//  SWXMLHash+TypeConversion.swift
//  SWXMLHash
//
//  Created by Maciek Grzybowski on 29.02.2016.
//
//

// swiftlint:disable file_length

import Foundation

// MARK: - XMLIndexerDeserializable

/// Provides XMLIndexer deserialization / type transformation support
public protocol XMLIndexerDeserializable {
    static func deserialize(element: XMLIndexer) throws -> Self
}

/// Provides XMLIndexer deserialization / type transformation support
public extension XMLIndexerDeserializable {
    /**
    A default implementation that will throw an error if it is called

    - parameters:
        - element: the XMLIndexer to be deserialized
    - throws: an XMLDeserializationError.ImplementationIsMissing if no implementation is found
    - returns: this won't ever return because of the error being thrown
    */
    static func deserialize(element: XMLIndexer) throws -> Self {
        throw XMLDeserializationError.ImplementationIsMissing(
            method: "XMLIndexerDeserializable.deserialize(element: XMLIndexer)")
    }
}


// MARK: - XMLElementDeserializable

/// Provides XMLElement deserialization / type transformation support
public protocol XMLElementDeserializable {
    static func deserialize(element: XMLElement) throws -> Self
}

/// Provides XMLElement deserialization / type transformation support
public extension XMLElementDeserializable {
    /**
    A default implementation that will throw an error if it is called

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.ImplementationIsMissing if no implementation is found
    - returns: this won't ever return because of the error being thrown
    */
    static func deserialize(element: XMLElement) throws -> Self {
        throw XMLDeserializationError.ImplementationIsMissing(
            method: "XMLElementDeserializable.deserialize(element: XMLElement)")
    }
}

// MARK: - XMLAttributeDeserializable

/// Provides XMLAttribute deserialization / type transformation support
public protocol XMLAttributeDeserializable {
    static func deserialize(attribute: XMLAttribute) throws -> Self
}

/// Provides XMLAttribute deserialization / type transformation support
public extension XMLAttributeDeserializable {
    /**
     A default implementation that will throw an error if it is called

     - parameters:
         - attribute: The XMLAttribute to be deserialized
     - throws: an XMLDeserializationError.ImplementationIsMissing if no implementation is found
     - returns: this won't ever return because of the error being thrown
     */
    static func deserialize(attribute: XMLAttribute) throws -> Self {
        throw XMLDeserializationError.ImplementationIsMissing(
            method: "XMLAttributeDeserializable(element: XMLAttribute)")
    }
}

// MARK: - XMLIndexer Extensions

public extension XMLIndexer {

    // MARK: - XMLAttributeDeserializable

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `T`

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `T` value
     */
    func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) throws -> T {
        switch self {
        case .Element(let element):
            return try element.value(ofAttribute: attr)
        case .Stream(let opStream):
            return try opStream.findElements().value(ofAttribute: attr)
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `T?`

     - parameter attr: The attribute to deserialize
     - returns: The deserialized `T?` value, or nil if the attribute does not exist
     */
    func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) -> T? {
        switch self {
        case .Element(let element):
            return element.value(ofAttribute: attr)
        case .Stream(let opStream):
            return opStream.findElements().value(ofAttribute: attr)
        default:
            return nil
        }
    }

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `[T]`

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `[T]` value
     */
    func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) throws -> [T] {
        switch self {
        case .List(let elements):
            return try elements.map { try $0.value(ofAttribute: attr) }
        case .Element(let element):
            return try [element].map { try $0.value(ofAttribute: attr) }
        case .Stream(let opStream):
            return try opStream.findElements().value(ofAttribute: attr)
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `[T]?`

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `[T]?` value
     */
    func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) throws -> [T]? {
        switch self {
        case .List(let elements):
            return try elements.map { try $0.value(ofAttribute: attr) }
        case .Element(let element):
            return try [element].map { try $0.value(ofAttribute: attr) }
        case .Stream(let opStream):
            return try opStream.findElements().value(ofAttribute: attr)
        default:
            return nil
        }
    }

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `[T?]`

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `[T?]` value
     */
    func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) throws -> [T?] {
        switch self {
        case .List(let elements):
            return elements.map { $0.value(ofAttribute: attr) }
        case .Element(let element):
            return [element].map { $0.value(ofAttribute: attr) }
        case .Stream(let opStream):
            return try opStream.findElements().value(ofAttribute: attr)
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    // MARK: - XMLElementDeserializable

    /**
    Attempts to deserialize the current XMLElement element to `T`

    - throws: an XMLDeserializationError.NodeIsInvalid if the current indexed level isn't an Element
    - returns: the deserialized `T` value
    */
    func value<T: XMLElementDeserializable>() throws -> T {
        switch self {
        case .Element(let element):
            return try T.deserialize(element)
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    /**
    Attempts to deserialize the current XMLElement element to `T?`

    - returns: the deserialized `T?` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLElementDeserializable>() throws -> T? {
        switch self {
        case .Element(let element):
            return try T.deserialize(element)
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            return nil
        }
    }

    /**
    Attempts to deserialize the current XMLElement element to `[T]`

    - returns: the deserialized `[T]` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLElementDeserializable>() throws -> [T] {
        switch self {
        case .List(let elements):
            return try elements.map { try T.deserialize($0) }
        case .Element(let element):
            return try [element].map { try T.deserialize($0) }
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            return []
        }
    }

    /**
    Attempts to deserialize the current XMLElement element to `[T]?`

    - returns: the deserialized `[T]?` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLElementDeserializable>() throws -> [T]? {
        switch self {
        case .List(let elements):
            return try elements.map { try T.deserialize($0) }
        case .Element(let element):
            return try [element].map { try T.deserialize($0) }
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            return nil
        }
    }

    /**
    Attempts to deserialize the current XMLElement element to `[T?]`

    - returns: the deserialized `[T?]` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLElementDeserializable>() throws -> [T?] {
        switch self {
        case .List(let elements):
            return try elements.map { try T.deserialize($0) }
        case .Element(let element):
            return try [element].map { try T.deserialize($0) }
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            return []
        }
    }


    // MARK: - XMLIndexerDeserializable

    /**
    Attempts to deserialize the current XMLIndexer element to `T`

    - returns: the deserialized `T` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLIndexerDeserializable>() throws -> T {
        switch self {
        case .Element:
            return try T.deserialize(self)
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    /**
    Attempts to deserialize the current XMLIndexer element to `T?`

    - returns: the deserialized `T?` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLIndexerDeserializable>() throws -> T? {
        switch self {
        case .Element:
            return try T.deserialize(self)
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            return nil
        }
    }

    /**
    Attempts to deserialize the current XMLIndexer element to `[T]`

    - returns: the deserialized `[T]` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T where T: XMLIndexerDeserializable>() throws -> [T] {
        switch self {
        case .List(let elements):
            return try elements.map { try T.deserialize( XMLIndexer($0) ) }
        case .Element(let element):
            return try [element].map { try T.deserialize( XMLIndexer($0) ) }
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    /**
    Attempts to deserialize the current XMLIndexer element to `[T]?`

    - returns: the deserialized `[T]?` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLIndexerDeserializable>() throws -> [T]? {
        switch self {
        case .List(let elements):
            return try elements.map { try T.deserialize( XMLIndexer($0) ) }
        case .Element(let element):
            return try [element].map { try T.deserialize( XMLIndexer($0) ) }
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    /**
    Attempts to deserialize the current XMLIndexer element to `[T?]`

    - returns: the deserialized `[T?]` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLIndexerDeserializable>() throws -> [T?] {
        switch self {
        case .List(let elements):
            return try elements.map { try T.deserialize( XMLIndexer($0) ) }
        case .Element(let element):
            return try [element].map { try T.deserialize( XMLIndexer($0) ) }
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }
}

// MARK: - XMLElement Extensions

extension XMLElement {

    /**
     Attempts to deserialize the specified attribute of the current XMLElement to `T`

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `T` value
     */
    public func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) throws -> T {
        if let attr = self.attribute(by: attr) {
            return try T.deserialize(attr)
        } else {
            throw XMLDeserializationError.AttributeDoesNotExist(element: self, attribute: attr)
        }
    }

    /**
     Attempts to deserialize the specified attribute of the current XMLElement to `T?`

     - parameter attr: The attribute to deserialize
     - returns: The deserialized `T?` value, or nil if the attribute does not exist.
     */
    public func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) -> T? {
        if let attr = self.attribute(by: attr) {
            return try? T.deserialize(attr)
        } else {
            return nil
        }
    }

    /**
     Gets the text associated with this element, or throws an exception if the text is empty

     - throws: XMLDeserializationError.NodeHasNoValue if the element text is empty
     - returns: The element text
     */
    private func nonEmptyTextOrThrow() throws -> String {
        if let text = self.text where !text.characters.isEmpty {
            return text
        } else { throw XMLDeserializationError.NodeHasNoValue }
    }
}

// MARK: - XMLDeserializationError

/// The error that is thrown if there is a problem with deserialization
public enum XMLDeserializationError: ErrorType, CustomStringConvertible {
    case ImplementationIsMissing(method: String)
    case NodeIsInvalid(node: XMLIndexer)
    case NodeHasNoValue
    case TypeConversionFailed(type: String, element: XMLElement)
    case AttributeDoesNotExist(element: XMLElement, attribute: String)
    case AttributeDeserializationFailed(type: String, attribute: XMLAttribute)

    /// The text description for the error thrown
    public var description: String {
        switch self {
        case .ImplementationIsMissing(let method):
            return "This deserialization method is not implemented: \(method)"
        case .NodeIsInvalid(let node):
            return "This node is invalid: \(node)"
        case .NodeHasNoValue:
            return "This node is empty"
        case .TypeConversionFailed(let type, let node):
            return "Can't convert node \(node) to value of type \(type)"
        case .AttributeDoesNotExist(let element, let attribute):
            return "Element \(element) does not contain attribute: \(attribute)"
        case .AttributeDeserializationFailed(let type, let attribute):
            return "Can't convert attribute \(attribute) to value of type \(type)"
        }
    }
}


// MARK: - Common types deserialization

extension String: XMLElementDeserializable, XMLAttributeDeserializable {
    /**
    Attempts to deserialize XML element content to a String

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.TypeConversionFailed if the element cannot be deserialized
    - returns: the deserialized String value
    */
    public static func deserialize(element: XMLElement) throws -> String {
        guard let text = element.text else {
            throw XMLDeserializationError.TypeConversionFailed(type: "String", element: element)
        }
        return text
    }

    /**
     Attempts to deserialize XML Attribute content to a String

     - parameter attribute: the XMLAttribute to be deserialized
     - returns: the deserialized String value
     */
    public static func deserialize(attribute: XMLAttribute) -> String {
        return attribute.text
    }
}

extension Int: XMLElementDeserializable, XMLAttributeDeserializable {
    /**
    Attempts to deserialize XML element content to a Int

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.TypeConversionFailed if the element cannot be deserialized
    - returns: the deserialized Int value
    */
    public static func deserialize(element: XMLElement) throws -> Int {
        guard let value = Int(try element.nonEmptyTextOrThrow()) else {
            throw XMLDeserializationError.TypeConversionFailed(type: "Int", element: element)
        }
        return value
    }

    /**
     Attempts to deserialize XML attribute content to an Int

     - parameter attribute: The XMLAttribute to be deserialized
     - throws: an XMLDeserializationError.AttributeDeserializationFailed if the attribute cannot be
               deserialized
     - returns: the deserialized Int value
     */
    public static func deserialize(attribute: XMLAttribute) throws -> Int {
        guard let value = Int(attribute.text) else {
            throw XMLDeserializationError.AttributeDeserializationFailed(
                type: "Int", attribute: attribute)
        }
        return value
    }
}

extension Double: XMLElementDeserializable, XMLAttributeDeserializable {
    /**
    Attempts to deserialize XML element content to a Double

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.TypeConversionFailed if the element cannot be deserialized
    - returns: the deserialized Double value
    */
    public static func deserialize(element: XMLElement) throws -> Double {
        guard let value = Double(try element.nonEmptyTextOrThrow()) else {
            throw XMLDeserializationError.TypeConversionFailed(type: "Double", element: element)
        }
        return value
    }

    /**
     Attempts to deserialize XML attribute content to a Double

     - parameter attribute: The XMLAttribute to be deserialized
     - throws: an XMLDeserializationError.AttributeDeserializationFailed if the attribute cannot be
               deserialized
     - returns: the deserialized Double value
     */
    public static func deserialize(attribute: XMLAttribute) throws -> Double {
        guard let value = Double(attribute.text) else {
            throw XMLDeserializationError.AttributeDeserializationFailed(
                type: "Double", attribute: attribute)
        }
        return value
    }
}

extension Float: XMLElementDeserializable, XMLAttributeDeserializable {
    /**
    Attempts to deserialize XML element content to a Float

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.TypeConversionFailed if the element cannot be deserialized
    - returns: the deserialized Float value
    */
    public static func deserialize(element: XMLElement) throws -> Float {
        guard let value = Float(try element.nonEmptyTextOrThrow()) else {
            throw XMLDeserializationError.TypeConversionFailed(type: "Float", element: element)
        }
        return value
    }

    /**
     Attempts to deserialize XML attribute content to a Float

     - parameter attribute: The XMLAttribute to be deserialized
     - throws: an XMLDeserializationError.AttributeDeserializationFailed if the attribute cannot be
               deserialized
     - returns: the deserialized Float value
     */
    public static func deserialize(attribute: XMLAttribute) throws -> Float {
        guard let value = Float(attribute.text) else {
            throw XMLDeserializationError.AttributeDeserializationFailed(
                type: "Float", attribute: attribute)
        }
        return value
    }
}

extension Bool: XMLElementDeserializable, XMLAttributeDeserializable {
    // swiftlint:disable line_length
    /**
     Attempts to deserialize XML element content to a Bool. This uses NSString's 'boolValue'
     described [here](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/#//apple_ref/occ/instp/NSString/boolValue)

     - parameters:
        - element: the XMLElement to be deserialized
     - throws: an XMLDeserializationError.TypeConversionFailed if the element cannot be deserialized
     - returns: the deserialized Bool value
     */
    public static func deserialize(element: XMLElement) throws -> Bool {
        let value = Bool(NSString(string: try element.nonEmptyTextOrThrow()).boolValue)
        return value
    }

    /**
     Attempts to deserialize XML attribute content to a Bool. This uses NSString's 'boolValue'
     described [here](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/#//apple_ref/occ/instp/NSString/boolValue)

     - parameter attribute: The XMLAttribute to be deserialized
     - throws: an XMLDeserializationError.AttributeDeserializationFailed if the attribute cannot be
               deserialized
     - returns: the deserialized Bool value
     */
    public static func deserialize(attribute: XMLAttribute) throws -> Bool {
        let value = Bool(NSString(string: attribute.text).boolValue)
        return value
    }
    // swiftlint:enable line_length
}
