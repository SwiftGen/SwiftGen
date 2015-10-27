//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation

public final class StoryboardParser {
  typealias Scene = (storyboardID: String, tag: String, customClass: String?)
  
  struct Segue {
    let segueID: String
    let customClass: String?
  }
  
  var storyboardsScenes = [String: [Scene]]()
  var storyboardsSegues = [String: [Segue]]()
  
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
            appendSegue(Segue(segueID: segueID, customClass: customClass))
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
      
      private func appendSegue(segue: Segue) {
        guard !segues.contains(segue) else { return }
        segues.append(segue)
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
}

extension StoryboardParser.Segue: Equatable { }
func ==(lhs: StoryboardParser.Segue, rhs: StoryboardParser.Segue) -> Bool {
  return lhs.segueID == rhs.segueID
}
