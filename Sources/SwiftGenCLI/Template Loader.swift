//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import PathKit
import Stencil
import StencilSwiftKit

public extension Template {
  static func load(from path: Path, modernSpacing: Bool) throws -> Template {
    if modernSpacing {
      return try Template(
        templateString: path.read(),
        environment: stencilSwiftEnvironment(templatePaths: [path.parent()])
      )
    } else {
      return try StencilSwiftTemplate(
        templateString: path.read(),
        environment: stencilSwiftEnvironment(
          templatePaths: [path.parent()],
          templateClass: StencilSwiftTemplate.self,
          trimBehaviour: .nothing
        )
      )
    }
  }
}
