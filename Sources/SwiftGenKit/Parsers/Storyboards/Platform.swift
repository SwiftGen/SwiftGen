//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

extension Storyboards {
  enum Platform: String {
    case tvOS = "AppleTV"
    case iOS = "iOS.CocoaTouch"
    case macOS = "MacOSX.Cocoa"
    case watchOS = "watchKit"

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
