//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation

protocol InterfaceBuilderSwiftType {
  var type: String { get }
  var module: String? { get }
  var moduleIsPlaceholder: Bool { get }
}
