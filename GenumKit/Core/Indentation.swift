//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation

public enum Indentation {
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
