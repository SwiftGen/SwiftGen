import Foundation

func XCTLocFunc(forKey key: String, table tableName: String?) -> String {
  return NSLocalizedString(key, tableName: tableName, comment: "")
}
