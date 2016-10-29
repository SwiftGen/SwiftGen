import Foundation
import SWXMLHash

public enum CoreDataModelParserError: ErrorType, CustomStringConvertible {
  case InvalidModelType(String)
  case AbsentPlistKey(key: String, plistPath: String)
  case UnknownAttributeType(String)

  public var description: String {
    switch self {
    case .InvalidModelType(let modelPath):
      return "Invalid model type: '\(modelPath)'"
    case .AbsentPlistKey(let key, let plistPath):
      return "'\(key)' absent in \(plistPath)"
    case .UnknownAttributeType(let attributeType):
      return "Unexpected attribute type: '\(attributeType)'"
    }
  }
}

public final class CoreDataModelParser {

  public private(set) var entities: [Entity] = [] {
    didSet {
      var index: [String: Entity] = [:]
      for entity in entities {
        index[entity.name] = entity
      }
      self.entitiesByName = index
    }
  }

  internal private(set) var entitiesByName: [String: Entity] = [:]

  private static let typesMapping: [String: AttributeType] = ["Boolean": .Boolean,
                                                              "Binary": .Binary,
                                                              "Date": .Date,
                                                              "Decimal": .Decimal,
                                                              "Double": .Double,
                                                              "Float": .Float,
                                                              "Integer 16": .Integer16,
                                                              "Integer 32": .Integer32,
                                                              "Integer 64": .Integer64,
                                                              "String": .String,
                                                              "Transformable": .Transformable]

  public init() {
  }

  public func parseModelFile(path: String) throws {
    let path = NSURL(fileURLWithPath: try currentVersion(forModelPath: path), isDirectory: true)
      .URLByAppendingPathComponent("contents")
      .path!

    let content = try String(contentsOfFile: path)
    let xml = SWXMLHash.parse(content)
    self.entities = try xml["model"]["entity"].map { try Entity(xml: $0) }
  }

  private func currentVersion(forModelPath modelPath: String) throws -> String {
    let url = NSURL(fileURLWithPath: modelPath, isDirectory: true)
    switch url.pathExtension {
    case .Some("xcdatamodel"):
      return modelPath
    case .Some("xcdatamodeld"):
      let currentVersionFile = url.URLByAppendingPathComponent(".xccurrentversion").path!
      guard NSFileManager.defaultManager().fileExistsAtPath(currentVersionFile) else {
        return url
          .URLByAppendingPathComponent(url.lastPathComponent!)
          .URLByDeletingPathExtension!
          .URLByAppendingPathExtension("xcdatamodel")
          .path!
      }
      let versionKey = "_XCCurrentVersionName"
      guard let plist = NSDictionary(contentsOfFile: currentVersionFile),
        let versionFile = plist[versionKey] as? String else {
          throw CoreDataModelParserError.AbsentPlistKey(key: versionKey, plistPath: currentVersionFile)
      }
      return url.URLByAppendingPathComponent(versionFile).path!
    default:
      throw CoreDataModelParserError.InvalidModelType(modelPath)
    }
  }

  public struct Entity {
    public let name: String
    public let className: String?
    public let attributes: [Attribute]
    public let relationships: [Relationship]
    public let fetchedProperties: [FetchedProperty]
    public let parentEntityName: String?
    public let userInfo: [String: String]
  }

  public enum AttributeType {
    case Binary
    case Boolean
    case Date
    case Decimal
    case Double
    case Float
    case Integer16
    case Integer32
    case Integer64
    case String
    case Transformable
  }

  public struct Attribute {
    public let name: String
    public let type: AttributeType
    public let isOptional: Bool
    public let isScalar: Bool
    public let userInfo: [String: String]
  }

  public struct FetchedProperty {
    public let name: String
    public let entityName: String
    public let predicateString: String
    public let userInfo: [String: String]

  }

  public struct Relationship {
    public let name: String
    public let entityName: String
    public let isOptional: Bool
    public let toMany: Bool
    public let isOrdered: Bool
    public let userInfo: [String: String]
  }

  public enum Language {
    case Swift
    case ObjC

    func scalarTypeForType(type: AttributeType) -> String? {
      switch (self, type) {
      case (.Swift, .Boolean):
        return "Bool"
      case (.ObjC, .Boolean):
        return "BOOL"
      case (.Swift, .Double):
        return "Double"
      case (.ObjC, .Double):
        return "double"
      case (.Swift, .Float):
        return "Float"
      case (.ObjC, .Float):
        return "float"
      case (.Swift, .Integer16):
        return "Int16"
      case (.ObjC, .Integer16):
        return "int16_t"
      case (.Swift, .Integer32):
        return "Int32"
      case (.ObjC, .Integer32):
        return "int32_t"
      case (.Swift, .Integer64):
        return "Int64"
      case (.ObjC, .Integer64):
        return "int64_t"
      case (_, .Binary),
           (_, .Date),
           (_, .Decimal),
           (_, .String),
           (_, .Transformable):
        return nil
      }
    }

    func typeForType(type: AttributeType) -> String {
      switch (self, type) {
      case (_, .Binary):
        return "NSData"
      case (_, .Date):
        return "NSDate"
      case (_, .Decimal):
        return "NSDecimalNumber"
      case (.Swift, .String):
        return "String"
      case (.ObjC, .String):
        return "NSString"
      case (_, .Transformable):
        return "NSObject"
      case (_, .Boolean),
           (_, .Double),
           (_, .Float),
           (_, .Integer16),
           (_, .Integer32),
           (_, .Integer64):
        return "NSNumber"
      }
    }
  }
}

extension CoreDataModelParser.Attribute: Equatable { }
public func == (lhs: CoreDataModelParser.Attribute, rhs: CoreDataModelParser.Attribute) -> Bool {
  return lhs.name == rhs.name &&
    lhs.type == rhs.type &&
    lhs.isOptional == rhs.isOptional &&
    lhs.isScalar == rhs.isScalar &&
    lhs.userInfo == rhs.userInfo
}


extension CoreDataModelParser.Relationship: Equatable { }
public func == (lhs: CoreDataModelParser.Relationship, rhs: CoreDataModelParser.Relationship) -> Bool {
  return lhs.name == rhs.name &&
    lhs.entityName == rhs.entityName &&
    lhs.isOptional == rhs.isOptional &&
    lhs.toMany == rhs.toMany &&
    lhs.isOrdered == rhs.isOrdered &&
    lhs.userInfo == rhs.userInfo
}

extension CoreDataModelParser.FetchedProperty: Equatable { }
public func == (lhs: CoreDataModelParser.FetchedProperty, rhs: CoreDataModelParser.FetchedProperty) -> Bool {
  return lhs.name == rhs.name &&
    lhs.entityName == rhs.entityName &&
    lhs.predicateString == rhs.predicateString &&
    lhs.userInfo == rhs.userInfo
}

extension CoreDataModelParser.Entity {
  private init(xml: XMLIndexer) throws {
    self.name = try xml.value(ofAttribute: "name")
    self.className = xml.value(ofAttribute: "representedClassName")
    self.attributes = try xml.children
      .flatMap { $0.element?.name == "attribute" ? try CoreDataModelParser.Attribute(xml: $0) : nil }

    self.relationships = try xml.children
      .flatMap { $0.element?.name == "relationship" ? try CoreDataModelParser.Relationship(xml: $0) : nil }

    self.fetchedProperties = try xml.children
      .flatMap { $0.element?.name == "fetchedProperty" ? try CoreDataModelParser.FetchedProperty(xml: $0) : nil }

    self.parentEntityName = xml.value(ofAttribute: "parentEntity")
    self.userInfo = try xml.coreDataUserInfo()
  }
}

extension CoreDataModelParser.FetchedProperty {
  private init(xml: XMLIndexer) throws {
    self.name = try xml.value(ofAttribute: "name")
    self.entityName = try xml["fetchRequest"][0].value(ofAttribute: "entity")
    self.predicateString = try xml["fetchRequest"][0].value(ofAttribute: "predicateString")
    self.userInfo = try xml.coreDataUserInfo()
  }
}

extension CoreDataModelParser.Relationship {
  private init(xml: XMLIndexer) throws {
    self.name = try xml.value(ofAttribute: "name")
    self.entityName = try xml.value(ofAttribute: "destinationEntity")
    self.isOptional = xml.value(ofAttribute: "optional") ?? false
    self.toMany = xml.value(ofAttribute: "toMany") ?? false
    self.isOrdered = xml.value(ofAttribute: "ordered") ?? false
    self.userInfo = try xml.coreDataUserInfo()
  }
}

extension CoreDataModelParser.Attribute {
  private init(xml: XMLIndexer) throws {
    let attributeType: String = try xml.value(ofAttribute: "attributeType")
    guard let type = CoreDataModelParser.typesMapping[attributeType] else {
      throw CoreDataModelParserError.UnknownAttributeType(attributeType)
    }
    self.name = try xml.value(ofAttribute: "name")
    self.type = type
    self.isScalar = xml.value(ofAttribute: "usesScalarValueType") ?? false
    self.isOptional = xml.value(ofAttribute: "optional") ?? false
    self.userInfo = try xml.coreDataUserInfo()
  }
}

extension XMLIndexer {
  private func coreDataUserInfo() throws -> [String: String] {
    var userInfo: [String: String] = [:]
    for entryNode in self["userInfo"][0].children {
      let key: String = try entryNode.value(ofAttribute: "key")
      let value: String = try entryNode.value(ofAttribute: "value")
      userInfo[key] = value
    }

    return userInfo
  }
}
