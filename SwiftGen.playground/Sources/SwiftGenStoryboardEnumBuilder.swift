import Foundation
//@import SwiftIdentifier

public class SwiftGenStoryboardEnumBuilder {
    typealias SceneInfo = (identifier: String, customClass: String?)
    private var storyboards = [String : [SceneInfo]]()
    
    public init() {}
    
    public func addStoryboardAtPath(path: String) {
        let parser = NSXMLParser(contentsOfURL: NSURL.fileURLWithPath(path))
        
        class ParserDelegate : NSObject, NSXMLParserDelegate {
            var identifiers = [SceneInfo]()
            var inScene = false
            var readyForFirstObject = false
            
            @objc func parser(parser: NSXMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String : String])
            {
                
                switch elementName {
                case "scene":
                    inScene = true
                case "objects" where inScene:
                    readyForFirstObject = true
                case _ where readyForFirstObject:
                    if let identifier = attributeDict["storyboardIdentifier"] {
                        let customClass = attributeDict["customClass"]
                        identifiers.append(SceneInfo(identifier, customClass))
                    }
                    readyForFirstObject = false
                default:
                    break
                }
            }
            
            @objc func parser(parser: NSXMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?)
            {
                switch elementName {
                case "scene":
                    inScene = false
                case "objects" where inScene:
                    readyForFirstObject = false
                default:
                    break;
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
            while let subPath = dirEnum.nextObject() as? String {
                if subPath.pathExtension == "storyboard" {
                    self.addStoryboardAtPath(path.stringByAppendingPathComponent(subPath))
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
        text += "    static func storyboard() -> UIStoryboard\n"
        text += "    static func initialViewController() -> UIViewController\n"
        text += "    func viewController() -> UIViewController\n"
        text += "    static func viewController(identifier: Self) -> UIViewController\n"

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
        // TODO: lowercase all letters that are uppercase at the beggining, except the last of the series. But always lowercase the first
        //       e.g. : "FooBar" --> "fooBar" but also "URLFooBar" --> "urlFooBar" and not "uRLFooBar" like it's implemented now
        if ns.length > 0 {
            let firstLetter = ns.substringToIndex(1)
            let rest = ns.substringFromIndex(1)
            return firstLetter.lowercaseString + rest
        } else {
            return ""
        }
        
    }
    
    public func build() -> String {
        var text = commonCode

        for (name, identifiers) in storyboards {
            let enumName = name.asSwiftIdentifier(forbiddenChars: "_")
            text += "enum \(enumName) : String, StoryboardScene {\n"
            text += "    static let storyboardName = \"\(name)\"\n"
            
            if !identifiers.isEmpty {
                text += "\n"
                
                for sceneInfo in identifiers {
                    let caseName = sceneInfo.identifier.asSwiftIdentifier(forbiddenChars: "_")
                    let lcCaseName = lowercaseFirst(caseName)
                    let vcClass = sceneInfo.customClass ?? "UIViewController"
                    let cast = sceneInfo.customClass == nil ? "" : " as! \(vcClass)"

                    text += "    case \(caseName) = \"\(sceneInfo.identifier)\"\n"
                    text += "    static var \(lcCaseName)ViewController : \(vcClass) {\n"
                    text += "        return \(enumName).\(caseName).viewController()\(cast)\n"
                    text += "    }\n\n"

                }
            }
            
            text += "}\n\n"
        }
        
        return text
    }
}

