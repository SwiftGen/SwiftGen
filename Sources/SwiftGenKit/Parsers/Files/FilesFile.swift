//
// SwiftGenKit
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Files {
  struct File {
    let name: String
    let ext: String?
    let path: [String]
    let mimeType: String

    init(path: Path, relativeTo parent: Path? = nil) throws {
      guard path.exists else {
        throw ParserError.invalidFile(path: path, reason: "Unable to read file")
      }

      self.ext = path.extension
      self.name = path.lastComponentWithoutExtension
      if let relative = parent.flatMap({ path.relative(to: $0) })?.parent(),
        relative != "." {
        self.path = relative.components
      } else {
        self.path = []
      }

      if let ext = self.ext,
        let uti = UTTypeCreatePreferredIdentifierForTag(
          kUTTagClassFilenameExtension, ext as NSString, nil
        )?.takeRetainedValue(),
        let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
        self.mimeType = mimetype as String
      } else {
        self.mimeType = "application/octet-stream"
      }
    }
  }
}
