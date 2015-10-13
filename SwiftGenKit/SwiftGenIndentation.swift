import Foundation

public enum SwiftGenIndentation {
    case Tab
    case Spaces(Int)
    
    public var string : String {
        if case let .Spaces(n) = self {
            return String(count: n, repeatedValue: " " as Character)
        }
        else {
            return "\t"
        }
    }
}
