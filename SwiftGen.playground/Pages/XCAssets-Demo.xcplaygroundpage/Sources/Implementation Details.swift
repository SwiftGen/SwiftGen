#if os(OSX)
  import AppKit
#elseif os(iOS)
  import ARKit
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Extra for playgrounds
public var bundle: Bundle!

// MARK: - Implementation Details

public struct ARResourceGroupAsset {
  public fileprivate(set) var name: String

  #if os(iOS)
  @available(iOS 11.3, *)
  public var referenceImages: Set<ARReferenceImage> {
    return ARReferenceImage.referenceImages(in: self)
  }

  @available(iOS 12.0, *)
  public var referenceObjects: Set<ARReferenceObject> {
    return ARReferenceObject.referenceObjects(in: self)
  }
  #endif

  // Extra for playgrounds
  public init(name: String) {
    self.name = name
  }
}

#if os(iOS)
@available(iOS 11.3, *)
public extension ARReferenceImage {
  static func referenceImages(in asset: ARResourceGroupAsset) -> Set<ARReferenceImage> {
    return referenceImages(inGroupNamed: asset.name, bundle: bundle) ?? Set()
  }
}

@available(iOS 12.0, *)
public extension ARReferenceObject {
  static func referenceObjects(in asset: ARResourceGroupAsset) -> Set<ARReferenceObject> {
    return referenceObjects(inGroupNamed: asset.name, bundle: bundle) ?? Set()
  }
}
#endif

public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(OSX)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  // Extra for playgrounds
  public init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init?(asset: ColorAsset) {
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

public struct DataAsset {
  public fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  public var data: NSDataAsset {
    guard let data = NSDataAsset(asset: self) else {
      fatalError("Unable to load data asset named \(name).")
    }
    return data
  }
  #endif

  // Extra for playgrounds
  public init(name: String) {
    self.name = name
  }
}

#if os(iOS) || os(tvOS) || os(OSX)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
public extension NSDataAsset {
  convenience init?(asset: DataAsset) {
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(OSX)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(OSX)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  // Extra for playgrounds
  public init(name: String) {
    self.name = name
  }
}

public extension ImageAsset.Image {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}
