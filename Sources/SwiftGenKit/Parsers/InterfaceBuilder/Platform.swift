//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation

extension InterfaceBuilder {
  enum Platform: String, CaseIterable {
    case iOS = "iOS.CocoaTouch"
    case macOS = "MacOSX.Cocoa"
    case tvOS = "AppleTV"
    case watchOS = "watchKit"

    init?(runtime: String) {
      // files without "trait variations" will have a runtime value of (for example):
      // "iOS.CocoaTouch.iPad"
      if let platform = Platform.allCases.first(where: { runtime.hasPrefix($0.rawValue) }) {
        self = platform
      } else {
        return nil
      }
    }

    var name: String {
      switch self {
      case .tvOS:
        return "tvOS"
      case .iOS:
        return "iOS"
      case .macOS:
        return "macOS"
      case .watchOS:
        return "watchOS"
      }
    }

    var prefix: String {
      switch self {
      case .iOS, .tvOS, .watchOS:
        return "UI"
      case .macOS:
        return "NS"
      }
    }

    var module: String {
      switch self {
      case .iOS, .tvOS, .watchOS:
        return "UIKit"
      case .macOS:
        return "AppKit"
      }
    }
  }
}
