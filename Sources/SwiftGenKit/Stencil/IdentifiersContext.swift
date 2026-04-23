//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

/*
 - `containers`: `Array` — list of Dictionaries, each containing a container and its identifiers
   - `name` : `String` — name of the container
   - `accessibility`: `Array` — list of accessibility objects in the container
     - `elementType`: `String` - Type of element
     - `identifier`: `String` - Accessibility identifier of the object (sanitised for use in code)
     - `rawValue`: `String` - Raw accessibility identifier as it exists in interface builder
 */
extension IdentifiersParser {
  public func stencilContext() -> [String: Any] {
    let containers = accessibilityIdentifiers.keys.sorted()

    return [
      "containers": containers.map { name in
        return [
          "name": name,
          "accessibility": accessibilityIdentifiers[name]! // swiftlint:disable:this force_unwrapping
            .sorted { $0.identifier < $1.identifier }
            .map { item in
              return [
                "elementType": item.elementType,
                "identifier": item.identifier,
                "rawValue": item.rawValue
              ]
          }
        ]
      }
    ]
  }
}
