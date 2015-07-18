import Foundation

public enum SwiftGenIndentation {
    case Tab
    case Spaces(Int)
    
    var string : String {
        if case let .Spaces(n) = self {
            return (0..<n).reduce("") { s, _ in s + " " }
        }
        else {
            return "\t"
        }
    }
}
