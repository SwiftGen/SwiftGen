#if os(macOS)
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

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
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
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #endif
  }
}

public struct DataAsset {
  public fileprivate(set) var name: String

  @available(iOS 9.0, tvOS 9.0, watchOS 6.0, macOS 10.11, *)
  public var data: NSDataAsset {
    guard let data = NSDataAsset(asset: self) else {
      fatalError("Unable to load data asset named \(name).")
    }
    return data
  }

  // Extra for playgrounds
  public init(name: String) {
    self.name = name
  }
}

@available(iOS 9.0, tvOS 9.0, watchOS 6.0, macOS 10.11, *)
public extension NSDataAsset {
  convenience init?(asset: DataAsset) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(macOS)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  public var image: Image {
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
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
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

public struct SymbolAsset {
  public fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(watchOS)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  public typealias Configuration = UIImage.Configuration
  public typealias Image = UIImage

  @available(iOS 12.0, tvOS 12.0, watchOS 5.0, *)
  public var image: Image {
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load symbol asset named \(name).")
    }
    return result
  }

  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  public func image(with configuration: Configuration) -> Image {
    guard let result = Image(named: name, in: bundle, with: configuration) else {
      fatalError("Unable to load symbol asset named \(name).")
    }
    return result
  }
  #endif

  // Extra for playgrounds
  public init(name: String) {
    self.name = name
  }
}
