//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Stencil

#if os(Linux) && !swift(>=3.1)
typealias NSRegularExpression = RegularExpression
#endif

// Workaround until Stencil fixes https://github.com/kylef/Stencil/issues/22
open class StencilSwiftTemplate: Template {
  public required init(templateString: String, environment: Environment? = nil, name: String? = nil) {
    let templateStringWithMarkedNewlines = templateString
        .replacingOccurrences(of: "\n\n", with: "\n\u{000b}\n")
        .replacingOccurrences(of: "\n\n", with: "\n\u{000b}\n")
    super.init(templateString: templateStringWithMarkedNewlines, environment: environment, name: name)
  }

  open override func render(_ dictionary: [String: Any]? = nil) throws -> String {
    return try removeExtraLines(from: super.render(dictionary))
  }

  // Workaround until Stencil fixes https://github.com/kylef/Stencil/issues/22
  private func removeExtraLines(from str: String) -> String {
    let extraLinesRE: NSRegularExpression = {
      do {
        return try NSRegularExpression(pattern: "\\n([ \\t]*\\n)+", options: [])
      } catch {
        fatalError("Regular Expression pattern error: \(error)")
      }
    }()
    let compact = extraLinesRE.stringByReplacingMatches(
      in: str,
      options: [],
      range: NSRange(location: 0, length: str.utf16.count),
      withTemplate: "\n"
    )
    let unmarkedNewlines = compact
      .replacingOccurrences(of: "\n\u{000b}\n", with: "\n\n")
      .replacingOccurrences(of: "\n\u{000b}\n", with: "\n\n")
    return unmarkedNewlines
  }
}
