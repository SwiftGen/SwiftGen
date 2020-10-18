import Foundation

// Extra for playgrounds
public var bundle: Bundle!

// MARK: - Implementation Details

public struct File {
  public let name: String
  public let ext: String?
  public let relativePath: String
  public let mimeType: String

  public var url: URL {
    return url(locale: nil)
  }

  public func url(locale: Locale?) -> URL {
    let url = bundle.url(forResource: name, withExtension: ext, subdirectory: relativePath, localization: locale?.identifier)
    guard let result = url else {
      let file = name + (ext != nil ? "." + ext! : "")
      fatalError("Could not locate file named \(file)")
    }
    return result
  }

  public var path: String {
    return path(locale: nil)
  }

  public func path(locale: Locale?) -> String {
    return url(locale: locale).path
  }
  
  // Extra for playgrounds
  public init(name: String, ext: String?, relativePath: String, mimeType: String) {
    self.name = name
    self.ext = ext
    self.relativePath = relativePath
    self.mimeType = mimeType
  }
}
