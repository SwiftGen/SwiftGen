import Foundation
//@import SwiftIdentifier

public class SwiftGenStoryboardEnumFactory {
    typealias SceneInfo = (identifier: String, customClass: String?)
    private var storyboards = [String : [SceneInfo]]()
    
    public init() {}
    
    public func addStoryboardAtPath(path: String) {
        let parser = NSXMLParser(contentsOfURL: NSURL.fileURLWithPath(path))
        
        class ParserDelegate : NSObject, NSXMLParserDelegate {
            var identifiers = [SceneInfo]()
            @objc func parser(parser: NSXMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String : String])
            {
                if elementName == "viewController", let identifier = attributeDict["storyboardIdentifier"] {
                    let customClass = attributeDict["customClass"]
                    identifiers.append(SceneInfo(identifier, customClass))
                }
            }
        }
        
        let delegate = ParserDelegate()
        parser?.delegate = delegate
        parser?.parse()
        
        let storyboardName = path.lastPathComponent.stringByDeletingPathExtension
        storyboards[storyboardName] = delegate.identifiers
    }
    
    public func parseDirectory(path: String) {
        if let dirEnum = NSFileManager.defaultManager().enumeratorAtPath(path) {
            while let path = dirEnum.nextObject() as? String {
                if path.pathExtension == "storyboard" {
                    self.addStoryboardAtPath(path)
                }
            }
        }
    }

    
    private var commonCode : String = {
        var text = ""
        text += "import Foundation\n"
        text += "import UIKit\n"
        text += "\n"
        
        text += "protocol StoryboardScene : RawRepresentable {\n"
        text += "    static var storyboardName : String { get }\n"
        text += "}\n"
        text += "\n"
        text += "extension StoryboardScene where Self.RawValue == String {\n"
        text += "    static func storyboard() -> UIStoryboard {\n"
        text += "        return UIStoryboard(name: self.storyboardName, bundle: nil)\n"
        text += "    }\n"
        text += "\n"
        text += "    static func initialViewController() -> UIViewController {\n"
        text += "        return storyboard().instantiateInitialViewController()!\n"
        text += "    }\n"
        text += "\n"
        text += "    func viewController() -> UIViewController {\n"
        text += "        return Self.storyboard().instantiateViewControllerWithIdentifier(self.rawValue)\n"
        text += "    }\n"
        text += "    static func viewController(identifier: Self) -> UIViewController {\n"
        text += "        return identifier.viewController()\n"
        text += "    }\n"
        text += "}\n\n"
        return text
        }()
    
    private func lowercaseFirst(string: String) -> String {
        let ns = string as NSString
        if ns.length > 0 {
            let firstLetter = ns.substringToIndex(1)
            let rest = ns.substringFromIndex(1)
            return firstLetter.lowercaseString + rest
        } else {
            return ""
        }
        
    }
    
    public func generate() -> String {
        var text = commonCode
        
        for (name, identifiers) in storyboards {
            let enumName = name.asSwiftIdentifier(forbiddenChars: "_")
            text += "enum \(enumName) : String, StoryboardScene {\n"
            text += "    static let storyboardName = \"\(name)\"\n"
            
            if !identifiers.isEmpty {
                text += "\n"
                
                for sceneInfo in identifiers {
                    let caseName = sceneInfo.identifier.asSwiftIdentifier(forbiddenChars: "_")
                    text += "    case \(caseName) = \"\(sceneInfo.identifier)\"\n"
                }
                    
                text += "\n"
                
                for sceneInfo in identifiers {
                    let caseName = sceneInfo.identifier.asSwiftIdentifier(forbiddenChars: "_")
                    let lcCaseName = lowercaseFirst(caseName)
                    let vcClass = sceneInfo.customClass ?? "UIViewController"
                    let cast = sceneInfo.customClass == nil ? "" : " as! \(vcClass)"
                    text += "    static var \(lcCaseName)ViewController : \(vcClass) { return \(enumName).\(caseName).viewController()\(cast) }\n"
                }
            }
            
            text += "}\n\n"
        }
        
        return text
    }
}

