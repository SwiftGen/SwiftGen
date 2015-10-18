//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation
import Stencil

public final class StoryboardEnumBuilder {
  private typealias Scene = (storyboardID: String, tag: String, customClass: String?)
  private typealias Segue = (segueID: String, customClass: String?)
  private var storyboardsScenes = [String: [Scene]]()
  private var storyboardsSegues = [String: [Segue]]()
  
  
  public init() {}
  
  public func addStoryboardAtPath(path: String) {
    let parser = NSXMLParser(contentsOfURL: NSURL.fileURLWithPath(path))
    
    class ParserDelegate : NSObject, NSXMLParserDelegate {
      var scenes = [Scene]()
      var segues = [Segue]()
      var inScene = false
      var readyForFirstObject = false
      var readyForConnections = false
      
      @objc func parser(parser: NSXMLParser, didStartElement elementName: String,
        namespaceURI: String?, qualifiedName qName: String?,
        attributes attributeDict: [String : String])
      {
        
        switch elementName {
        case "scene":
          inScene = true
        case "objects" where inScene:
          readyForFirstObject = true
        case let tag where readyForFirstObject:
          if let storyboardID = attributeDict["storyboardIdentifier"] {
            let customClass = attributeDict["customClass"]
            scenes.append(Scene(storyboardID, tag, customClass))
          }
          readyForFirstObject = false
        case "connections":
          readyForConnections = true
        case "segue" where readyForConnections:
          if let segueID = attributeDict["identifier"] {
            let customClass = attributeDict["customClass"]
            segues.append(Segue(segueID, customClass))
          }
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
        case "connections":
          readyForConnections = false
        default:
          break;
        }
      }
    }
    
    let delegate = ParserDelegate()
    parser?.delegate = delegate
    parser?.parse()
    
    let storyboardName = ((path as NSString).lastPathComponent as NSString).stringByDeletingPathExtension
    storyboardsScenes[storyboardName] = delegate.scenes
    storyboardsSegues[storyboardName] = delegate.segues
  }
  
  public func parseDirectory(path: String) {
    if let dirEnum = NSFileManager.defaultManager().enumeratorAtPath(path) {
      while let subPath = dirEnum.nextObject() as? NSString {
        if subPath.pathExtension == "storyboard" {
          self.addStoryboardAtPath((path as NSString).stringByAppendingPathComponent(subPath as String))
        }
      }
    }
  }
  
  public func stencilContext() -> Context {
    let storyboards = Set(storyboardsScenes.keys).union(storyboardsSegues.keys).sort(<)
    let storyboardsMap = storyboards.map { (storyboardName: String) -> [String:AnyObject] in
      var sbMap: [String:AnyObject] = ["name": storyboardName]
      if let scenes = storyboardsScenes[storyboardName] {
        sbMap["scenes"] = scenes
          .sort({$0.storyboardID < $1.storyboardID})
          .map { (scene: Scene) -> [String:String] in
            let customClass = scene.customClass ?? (scene.tag != "viewController" ? "UI" + uppercaseFirst(scene.tag) : nil)
            if let customClass = customClass {
              return ["identifier": scene.storyboardID, "class": customClass]
            } else {
              return ["identifier": scene.storyboardID]
            }
        }
      }
      if let segues = storyboardsSegues[storyboardName] {
        sbMap["segues"] = segues
          .sort({$0.segueID < $1.segueID})
          .map { (segue: Segue) -> [String:String] in
            ["identifier": segue.segueID, "class": segue.customClass ?? "UIStoryboardSegue"]
        }
      }
      return sbMap
    }
    return Context(dictionary: ["storyboards": storyboardsMap])
  }
  
  // MARK: - Private Helpers
  
  private func uppercaseFirst(string: String) -> String {
    guard let first = string.characters.first else {
      return string
    }
    return String(first).uppercaseString + String(string.characters.dropFirst())
  }
  
}
