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
    if CFGetTypeID(self) == CFBooleanGetTypeID() {
      return boolValue.represented()
    } else {
      switch CFNumberGetType(self) {
      case .sInt8Type:
        return int8Value.represented()
      case .sInt16Type:
        return int16Value.represented()
      case .sInt32Type:
        return int32Value.represented()
      case .sInt64Type:
        return int64Value.represented()
      case .charType:
        return uint8Value.represented()
      case .intType, .longType, .longLongType, .nsIntegerType:
        return intValue.represented()
      case .float32Type, .floatType:
        return floatValue.represented()
      case .float64Type, .doubleType, .cgFloatType:
        return doubleValue.represented()
      default:
        return Double.nan.represented()
      }
    }
  }
}
