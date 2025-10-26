//
// SwiftGenKit
//

import Foundation
import PathKit
import StoryboardCore
import Yams

enum CharacterAtlasLoaderError: Error, CustomStringConvertible {
  case unreadable(Path)
  case unsupportedFormat(Path)
  case decodingFailed(Path, Error)

  var description: String {
    switch self {
    case .unreadable(let path):
      return "Unable to read character atlas at \(path)."
    case .unsupportedFormat(let path):
      return "Unsupported character atlas format for file at \(path). Use JSON or YAML."
    case .decodingFailed(let path, let error):
      return "Failed to decode character atlas at \(path): \(error)"
    }
  }
}

enum CharacterAtlasLoader {
  static func load(at path: Path) throws -> CharacterAtlas {
    guard path.exists else {
      throw CharacterAtlasLoaderError.unreadable(path)
    }

    let ext = path.extension?.lowercased()
    switch ext {
    case "json":
      return try decodeJSON(at: path)
    case "yml", "yaml":
      return try decodeYAML(at: path)
    default:
      throw CharacterAtlasLoaderError.unsupportedFormat(path)
    }
  }

  private static func decodeJSON(at path: Path) throws -> CharacterAtlas {
    let raw: String
    do {
      raw = try path.read()
    } catch {
      throw CharacterAtlasLoaderError.decodingFailed(path, error)
    }
    guard let data = raw.data(using: .utf8) else {
      throw CharacterAtlasLoaderError.decodingFailed(path, CharacterAtlasLoaderError.unreadable(path))
    }
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys
    do {
      return try decoder.decode(CharacterAtlas.self, from: data)
    } catch {
      throw CharacterAtlasLoaderError.decodingFailed(path, error)
    }
  }

  private static func decodeYAML(at path: Path) throws -> CharacterAtlas {
    let raw: String
    do {
      raw = try path.read()
    } catch {
      throw CharacterAtlasLoaderError.decodingFailed(path, error)
    }
    do {
      return try YAMLDecoder().decode(CharacterAtlas.self, from: raw)
    } catch {
      throw CharacterAtlasLoaderError.decodingFailed(path, error)
    }
  }
}
