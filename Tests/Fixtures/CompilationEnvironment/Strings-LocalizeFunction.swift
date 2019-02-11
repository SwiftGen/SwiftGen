import Foundation

func XCTLocFunc(_ key: String, tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String) -> String {
  return NSLocalizedString(key, tableName: tableName, bundle: bundle, value: value, comment: comment)
}
