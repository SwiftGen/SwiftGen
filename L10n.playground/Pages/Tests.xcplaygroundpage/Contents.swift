
import Foundation


//: ### First idea: too simple, not secure enough regarding parameters

enum L10n_Draft : String {
    // >>> GENERATE THIS USING A SCRIPT
    case AlertTitle = "alert.title"
    case AlertMessage = "alert.message"
    case Presentation = "greetings.text"
    // <<< ---
    
    func format(args: CVarArgType...) -> String {
        let format = NSLocalizedString(self.rawValue, comment: "")
        return String(format: format, arguments: args)
    }
    var string : String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

//: #### Usage example

L10n_Draft.AlertTitle.string
L10n_Draft.Presentation.format("David", 29)



//: ### Better idea: use the enum's associated values to pass parameters
//:
//: This will ensure type safety when using them


enum L10n {
    case AlertTitle
    case AlertMessage
    case Greetings(String, Int)
    case ApplesCount(Int)
    case BananasOwner(Int, String)
}

extension L10n : CustomStringConvertible {
    var description : String { return self.string }
    
    var string : String {
        switch self {
        case .AlertTitle:
            return L10n.tr("alert_title")
        case .AlertMessage:
            return L10n.tr("alert_message")
        case .Greetings(let p0, let p1):
            return L10n.tr("greetings", p0, p1)
        case .ApplesCount(let p0):
            return L10n.tr("apples.count", p0)
        case .BananasOwner(let p0, let p1):
            return L10n.tr("bananas.owner", p0, p1)
        }
    }
    
    private static func tr(key: String, _ args: CVarArgType...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, arguments: args)
    }
}

func tr(key: L10n) -> String {
    return key.string
}

//: #### Usage example

print(tr(.AlertTitle))
print(tr(.Greetings("David", 29)))
let v = L10n.Greetings("Olivier", 32)
print("Hey! \(v).") // CustomStringConvertible automatically calls description


