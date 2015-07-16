
import Foundation

//: Some setup to fake use of LocalizableStrings when in the Playground

// This is a fake implementation mimicking the behavior of having a Localizable.string
// This is used here to be able to test the code easily in a Playground
func localize(key: String) -> String {
    return [
        "alert.title": "This is the alert title",
        "alert.message": "Body Message for the Alert",
        "greetings.text": "My name is %@ and I'm %d."
    ][key] ?? key
}

// The real implementation would instead use Localizable.strings:
/*
func localize(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
*/


//: ### First idea: too simple, not secure enough regarding parameters

enum L10n_Draft : String {
    // >>> GENERATE THIS USING A SCRIPT
    case AlertTitle = "alert.title"
    case AlertMessage = "alert.message"
    case Presentation = "greetings.text"
    // <<< ---
    
    func format(args: CVarArgType...) -> String {
        let format = localize(self.rawValue)
        return String(format: format, arguments: args)
    }
    var string : String {
        return localize(self.rawValue)
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
    case Presentation(String, Int)
}

extension L10n : CustomStringConvertible {
    var description : String { return self.string }

    // >>> GENERATE THIS USING A SCRIPT
    var string : String {
        switch self {
        case .AlertTitle:
            return tr("alert.title")
        case .AlertMessage:
            return tr("alert.message")
        case .Presentation(let first, let last):
            return tr("greetings.text", first, last)
        }
    }
    
    private func tr(key: String, _ args: CVarArgType...) -> String {
        let format = localize(key)
        return String(format: format, arguments: args)
    }
}

func tr(key: L10n) -> String { return key.string }

//: #### Usage example

print(tr(.AlertTitle))
print(tr(.Presentation("David", 29)))
let v = L10n.Presentation("Olivier", 32)
print("Hello, \(v)") // CustomStringConvertible automatically calls description


