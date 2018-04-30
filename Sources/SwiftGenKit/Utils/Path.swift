//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// Created by Derek Ostrander on 3/7/16.
// MIT License
//

import PathKit

extension PathKit.Path {
  /// Returns the Path relative to a parent directory.
  /// If the argument passed as parent isn't a prefix of `self`, returns `nil`.
  ///
  /// - Parameter parent: The parent Path to get the relative path against
  /// - Returns: The relative Path, or nil if parent was not a parent dir of self
  func relative(to parent: Path) -> Path? {
    let parentComponents = parent.absolute().components
    let currentComponents = self.absolute().components
    return currentComponents.starts(with: parentComponents)
      ? Path(components: currentComponents.dropFirst(parentComponents.count)) : nil
  }
}
