//
// SwiftGen
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation

// Based on https://github.com/realm/SwiftLint/blob/0.39.2/Source/SwiftLintFramework/Extensions/Array+SwiftLint.swift

extension Array {
  func parallelFlatMap<T>(transform: (Element) -> [T]) -> [T] {
    parallelMap(transform: transform).flatMap { $0 }
  }

  func parallelCompactMap<T>(transform: (Element) -> T?) -> [T] {
    parallelMap(transform: transform).compactMap { $0 }
  }

  func parallelMap<T>(transform: (Element) -> T) -> [T] {
    var result = ContiguousArray<T?>(repeating: nil, count: count)
    return result.withUnsafeMutableBufferPointer { buffer in
      DispatchQueue.concurrentPerform(iterations: buffer.count) { idx in
        buffer[idx] = transform(self[idx])
      }
      return buffer.compactMap { $0 }
    }
  }
}
