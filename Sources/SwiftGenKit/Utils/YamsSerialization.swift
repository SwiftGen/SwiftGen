//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import Yams

public enum YamsSerializationError: Error {
  case unableToCast(type: String)

  public var description: String {
    switch self {
    case .unableToCast(let type):
      return "Unable to cast Objective-C type '\(type)'"
    }
  }
}

///
/// These extensions are needed otherwise Yams can't serialize Objective-C types
///

extension NSArray: NodeRepresentable {
  public func represented() throws -> Node {
    guard let array = self as? [Any] else {
      throw YamsSerializationError.unableToCast(type: "NSArray")
    }
    return try array.represented()
  }
}

extension NSDate: ScalarRepresentable {
  public func represented() -> Node.Scalar {
    (self as Date).represented()
  }
}

extension NSDictionary: NodeRepresentable {
  public func represented() throws -> Node {
    guard let dictionary = self as? [AnyHashable: Any] else {
      throw YamsSerializationError.unableToCast(type: "NSDictionary")
    }
    return try dictionary.represented()
  }
}

extension NSData: ScalarRepresentable {
  public func represented() -> Node.Scalar {
    (self as Data).represented()
  }
}

extension NSNumber: ScalarRepresentable {
  public func represented() -> Node.Scalar {
    if let value = Bool(exactly: self) {
      return value.represented()
    } else if let value = Double(exactly: self), floor(value) != value {
      return value.represented()
    } else if let value = Int(exactly: self) {
      return value.represented()
    } else {
      return Double.nan.represented()
    }
  }
}
