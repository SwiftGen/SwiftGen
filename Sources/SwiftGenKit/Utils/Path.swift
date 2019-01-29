//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import PathKit

extension PathKit.Path {
  /// Returns the Path relative to a parent directory.
  /// If the argument passed as parent isn't a prefix of `self`, returns `nil`.
  ///
  /// - Parameter parent: The parent Path to get the relative path against
  /// - Returns: The relative Path, or nil if parent was not a parent dir of self
  func relative(to parent: Path) -> Path? {
    let parent = parent.absolute().components
    let current = self.absolute().components

    return current.starts(with: parent) ? Path(components: current.dropFirst(parent.count)) : nil
  }
}
