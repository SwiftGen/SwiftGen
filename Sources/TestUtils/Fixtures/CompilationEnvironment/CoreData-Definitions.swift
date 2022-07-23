import Foundation

public enum IntegerEnum: Int16 {
  case test1
}
public enum StringEnum: String {
  case test1
}
public struct IntegerOptionSet: OptionSet {
  public let rawValue: Int16
  public init(rawValue: Int16) {
    self.rawValue = rawValue
  }

  public static let foo = IntegerOptionSet(rawValue: 1 << 0)
  public static let bar = IntegerOptionSet(rawValue: 1 << 1)

  public static let all: IntegerOptionSet = [.bar, foo]
}
