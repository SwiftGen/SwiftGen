//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation

public final class StoryboardParser {
  struct InitialScene {
    let objectID: String
    let tag: String
    let customClass: String?
  }

  struct Scene {
    let storyboardID: String
    let tag: String
    let customClass: String?
  }

  struct Segue {
    let segueID: String
    let customClass: String?
  }

  var initialScenes = [String: InitialScene]()
  var storyboardsScenes = [String: Set<Scene>]()
  var storyboardsSegues = [String: Set<Segue>]()

  public init() {}

  fileprivate class ParserDelegate: NSObject, XMLParserDelegate {
    var initialViewControllerObjectID: String?
    var initialScene: InitialScene?
    var scenes = Set<Scene>()
    var segues = Set<Segue>()
    var inScene = false
    var readyForFirstObject = false
    var readyForConnections = false

    @objc func parser(_ parser: XMLParser, didStartElement elementName: String,
                      namespaceURI: String?, qualifiedName qName: String?,
                      attributes attributeDict: [String: String]) {

      switch elementName {
      case "document":
        initialViewControllerObjectID = attributeDict["initialViewController"]
      case "scene":
        inScene = true
      case "objects" where inScene:
        readyForFirstObject = true
      case let tag where (readyForFirstObject && tag != "viewControllerPlaceholder"):
        let customClass = attributeDict["customClass"]
        if let objectID = attributeDict["id"], objectID == initialViewControllerObjectID {
          initialScene = InitialScene(objectID: objectID, tag: tag, customClass: customClass)
        }
        if let storyboardID = attributeDict["storyboardIdentifier"] {
          scenes.insert(Scene(storyboardID: storyboardID, tag: tag, customClass: customClass))
        }
        readyForFirstObject = false
      case "connections":
        readyForConnections = true
      case "segue" where readyForConnections:
        if let segueID = attributeDict["identifier"] {
          let customClass = attributeDict["customClass"]
          segues.insert(Segue(segueID: segueID, customClass: customClass))
        }
      default:
        break
      }
    }

    @objc func parser(_ parser: XMLParser, didEndElement elementName: String,
                      namespaceURI: String?, qualifiedName qName: String?) {
      switch elementName {
      case "scene":
        inScene = false
      case "objects" where inScene:
        readyForFirstObject = false
      case "connections":
        readyForConnections = false
      default:
        break
      }
    }
  }

  public func addStoryboardAtPath(_ path: String) {
    let parser = XMLParser(contentsOf: URL(fileURLWithPath: path))

    let delegate = ParserDelegate()
    parser?.delegate = delegate
    parser?.parse()

    let storyboardName = ((path as NSString).lastPathComponent as NSString).deletingPathExtension
    initialScenes[storyboardName] = delegate.initialScene
    storyboardsScenes[storyboardName] = delegate.scenes
    storyboardsSegues[storyboardName] = delegate.segues
  }

  public func parseDirectory(_ path: String) {
    if let dirEnum = FileManager.default.enumerator(atPath: path) {
      while let subPath = dirEnum.nextObject() as? NSString {
        if subPath.pathExtension == "storyboard" {
          self.addStoryboardAtPath((path as NSString).appendingPathComponent(subPath as String))
        }
      }
    }
  }
}

extension StoryboardParser.Scene: Equatable { }
func == (lhs: StoryboardParser.Scene, rhs: StoryboardParser.Scene) -> Bool {
  return lhs.storyboardID == rhs.storyboardID && lhs.tag == rhs.tag && lhs.customClass == rhs.customClass
}

extension StoryboardParser.Scene: Hashable {
  var hashValue: Int {
    return "\(storyboardID);\(tag);\(customClass)".hashValue
  }
}

extension StoryboardParser.Segue: Equatable { }
func == (lhs: StoryboardParser.Segue, rhs: StoryboardParser.Segue) -> Bool {
  return lhs.segueID == rhs.segueID && lhs.customClass == rhs.customClass
}

extension StoryboardParser.Segue: Hashable {
  var hashValue: Int {
    return "\(segueID);\(customClass)".hashValue
  }
}
