//
// SwiftGen
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import PathKit
import Stencil
import StencilSwiftKit
import SwiftGenKit

enum Version {
  private static func getVersion(name: String, type: AnyClass) -> String {
    getVersion(name: name, bundle: Bundle(for: type))
  }

  private static func getVersion(name: String, bundle: Bundle) -> String {
    if let version = bundle.infoDictionary?["CFBundleShortVersionString"] as? String {
      return version
    }

    guard let path = Bundle.main.path(forResource: "\(name)-Info", ofType: "plist").flatMap({ Path($0) }),
      let data: Data = try? path.read(),
      let plist = try? PropertyListSerialization.propertyList(from: data, format: nil),
      let dictionary = plist as? [String: Any],
      let version = dictionary["CFBundleShortVersionString"] as? String else { return "0.0" }

    return version
  }

  static let swiftgen = getVersion(name: "SwiftGen", bundle: .main)
  static let swiftGenKit = getVersion(name: "SwiftGenKit", type: SwiftGenKit.AssetsCatalog.Parser.self)
  static let stencil = getVersion(name: "Stencil", type: Stencil.Template.self)
  static let stencilSwiftKit = getVersion(name: "StencilSwiftKit", type: StencilSwiftKit.StencilSwiftTemplate.self)
}
