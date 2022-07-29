import Foundation

func myFontFinder(name: String, family: String, path: String) -> URL? {
  return Bundle.main.url(forResource: path, withExtension: nil)
}

func myJSONFinder(path: String) -> URL? {
  return Bundle.main.url(forResource: path, withExtension: nil)
}

func myPlistFinder(path: String) -> URL? {
  return Bundle.main.url(forResource: path, withExtension: nil)
}

func XCTLocFunc(forKey key: String, table tableName: String?, fallback: String) -> String {
  return NSLocalizedString(key, tableName: tableName, value: fallback, comment: "")
}

#if canImport(AppKit)
import AppKit
func myStoryboardFinder(name: NSStoryboard.Name) -> NSStoryboard {
  return NSStoryboard(name: name, bundle: Bundle.main)
}
#elseif canImport(UIKit) && !os(watchOS)
import UIKit
func myStoryboardFinder(name: String) -> UIStoryboard {
  return UIStoryboard(name: name, bundle: Bundle.main)
}
#endif
