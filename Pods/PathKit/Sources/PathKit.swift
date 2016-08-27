// PathKit - Effortless path operations

import Darwin
import Foundation


/// Represents a filesystem path.
public struct Path {
  /// The character used by the OS to separate two path elements
  public static let separator = "/"

  /// The underlying string representation
  internal var path: String

  internal static var fileManager = NSFileManager.defaultManager()

  // MARK: Init

  public init() {
    self.path = ""
  }

  /// Create a Path from a given String
  public init(_ path: String) {
    self.path = path
  }

  /// Create a Path by joining multiple path components together
  public init<S: CollectionType where S.Generator.Element == String>(components: S) {
    if components.isEmpty {
      path = "."
    } else if components.first == Path.separator && components.count > 1 {
      let p = components.joinWithSeparator(Path.separator)
      path = p.substringFromIndex(p.startIndex.successor())
    } else {
      path = components.joinWithSeparator(Path.separator)
    }
  }
}


// MARK: StringLiteralConvertible

extension Path : StringLiteralConvertible {
  public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
  public typealias UnicodeScalarLiteralType = StringLiteralType

  public init(extendedGraphemeClusterLiteral path: StringLiteralType) {
    self.init(stringLiteral: path)
  }

  public init(unicodeScalarLiteral path: StringLiteralType) {
    self.init(stringLiteral: path)
  }

  public init(stringLiteral value: StringLiteralType) {
    self.path = value
  }
}


// MARK: CustomStringConvertible

extension Path : CustomStringConvertible {
  public var description: String {
    return self.path
  }
}


// MARK: Hashable

extension Path : Hashable {
  public var hashValue: Int {
    return path.hashValue
  }
}


// MARK: Path Info

extension Path {
  /// Test whether a path is absolute.
  ///
  /// - Returns: `true` iff the path begings with a slash
  ///
  public var isAbsolute: Bool {
    return path.hasPrefix(Path.separator)
  }

  /// Test whether a path is relative.
  ///
  /// - Returns: `true` iff a path is relative (not absolute)
  ///
  public var isRelative: Bool {
    return !isAbsolute
  }

  /// Concatenates relative paths to the current directory and derives the normalized path
  ///
  /// - Returns: the absolute path in the actual filesystem
  ///
  public func absolute() -> Path {
    if isAbsolute {
      return normalize()
    }

    return (Path.current + self).normalize()
  }

  /// Normalizes the path, this cleans up redundant ".." and ".", double slashes
  /// and resolves "~".
  ///
  /// - Returns: a new path made by removing extraneous path components from the underlying String
  ///   representation.
  ///
  public func normalize() -> Path {
    return Path((self.path as NSString).stringByStandardizingPath)
  }

  /// De-normalizes the path, by replacing the current user home directory with "~".
  ///
  /// - Returns: a new path made by removing extraneous path components from the underlying String
  ///   representation.
  ///
  public func abbreviate() -> Path {
    return Path((self.path as NSString).stringByAbbreviatingWithTildeInPath)
  }

  /// Returns the path of the item pointed to by a symbolic link.
  ///
  /// - Returns: the path of directory or file to which the symbolic link refers
  ///
  public func symlinkDestination() throws -> Path {
    let symlinkDestination = try Path.fileManager.destinationOfSymbolicLinkAtPath(path)
    let symlinkPath = Path(symlinkDestination)
    if symlinkPath.isRelative {
      return self + ".." + symlinkPath
    } else {
      return symlinkPath
    }
  }
}


// MARK: Path Components

extension Path {
  /// The last path component
  ///
  /// - Returns: the last path component
  ///
  public var lastComponent: String {
    return (path as NSString).lastPathComponent
  }

  /// The last path component without file extension
  ///
  /// - Note: This returns "." for "..".
  ///
  /// - Returns: the last path component without file extension
  ///
  public var lastComponentWithoutExtension: String {
    return (lastComponent as NSString).stringByDeletingPathExtension
  }

  /// Splits the string representation on the directory separator.
  /// Absolute paths remain the leading slash as first component.
  ///
  /// - Returns: all path components
  ///
  public var components: [String] {
    return (path as NSString).pathComponents
  }

  /// The file extension behind the last dot of the last component.
  ///
  /// - Returns: the file extension
  ///
  public var `extension`: String? {
    let pathExtension = (path as NSString).pathExtension
    if  pathExtension.isEmpty {
      return nil
    }

    return pathExtension
  }
}


// MARK: File Info

extension Path {
  /// Test whether a file or directory exists at a specified path
  ///
  /// - Returns: `false` iff the path doesn't exist on disk or its existence could not be
  ///   determined
  ///
  public var exists: Bool {
    return Path.fileManager.fileExistsAtPath(self.path)
  }

  /// Test whether a path is a directory.
  ///
  /// - Returns: `true` if the path is a directory or a symbolic link that points to a directory;
  ///   `false` if the path is not a directory or the path doesn't exist on disk or its existence
  ///   could not be determined
  ///
  public var isDirectory: Bool {
    var directory = ObjCBool(false)
    guard Path.fileManager.fileExistsAtPath(normalize().path, isDirectory: &directory) else {
      return false
    }
    return directory.boolValue
  }

  /// Test whether a path is a regular file.
  ///
  /// - Returns: `true` if the path is neither a directory nor a symbolic link that points to a
  ///   directory; `false` if the path is a directory or a symbolic link that points to a
  ///   directory or the path doesn't exist on disk or its existence
  ///   could not be determined
  ///
  public var isFile: Bool {
    var directory = ObjCBool(false)
    guard Path.fileManager.fileExistsAtPath(normalize().path, isDirectory: &directory) else {
      return false
    }
    return !directory.boolValue
  }

  /// Test whether a path is a symbolic link.
  ///
  /// - Returns: `true` if the path is a symbolic link; `false` if the path doesn't exist on disk
  ///   or its existence could not be determined
  ///
  public var isSymlink: Bool {
    do {
      let _ = try Path.fileManager.destinationOfSymbolicLinkAtPath(path)
      return true
    } catch {
      return false
    }
  }

  /// Test whether a path is readable
  ///
  /// - Returns: `true` if the current process has read privileges for the file at path;
  ///   otherwise `false` if the process does not have read privileges or the existence of the
  ///   file could not be determined.
  ///
  public var isReadable: Bool {
    return Path.fileManager.isReadableFileAtPath(self.path)
  }

  /// Test whether a path is writeable
  ///
  /// - Returns: `true` if the current process has write privileges for the file at path;
  ///   otherwise `false` if the process does not have write privileges or the existence of the
  ///   file could not be determined.
  ///
  public var isWritable: Bool {
    return Path.fileManager.isWritableFileAtPath(self.path)
  }

  /// Test whether a path is executable
  ///
  /// - Returns: `true` if the current process has execute privileges for the file at path;
  ///   otherwise `false` if the process does not have execute privileges or the existence of the
  ///   file could not be determined.
  ///
  public var isExecutable: Bool {
    return Path.fileManager.isExecutableFileAtPath(self.path)
  }

  /// Test whether a path is deletable
  ///
  /// - Returns: `true` if the current process has delete privileges for the file at path;
  ///   otherwise `false` if the process does not have delete privileges or the existence of the
  ///   file could not be determined.
  ///
  public var isDeletable: Bool {
    return Path.fileManager.isDeletableFileAtPath(self.path)
  }
}


// MARK: File Manipulation

extension Path {
  /// Create the directory.
  ///
  /// - Note: This method fails if any of the intermediate parent directories does not exist.
  ///   This method also fails if any of the intermediate path elements corresponds to a file and
  ///   not a directory.
  ///
  public func mkdir() throws -> () {
    try Path.fileManager.createDirectoryAtPath(self.path, withIntermediateDirectories: false, attributes: nil)
  }

  /// Create the directory and any intermediate parent directories that do not exist.
  ///
  /// - Note: This method fails if any of the intermediate path elements corresponds to a file and
  ///   not a directory.
  ///
  public func mkpath() throws -> () {
    try Path.fileManager.createDirectoryAtPath(self.path, withIntermediateDirectories: true, attributes: nil)
  }

  /// Delete the file or directory.
  ///
  /// - Note: If the path specifies a directory, the contents of that directory are recursively
  ///   removed.
  ///
  public func delete() throws -> () {
    try Path.fileManager.removeItemAtPath(self.path)
  }

  /// Move the file or directory to a new location synchronously.
  ///
  /// - Parameter destination: The new path. This path must include the name of the file or
  ///   directory in its new location.
  ///
  public func move(destination: Path) throws -> () {
    try Path.fileManager.moveItemAtPath(self.path, toPath: destination.path)
  }

  /// Copy the file or directory to a new location synchronously.
  ///
  /// - Parameter destination: The new path. This path must include the name of the file or
  ///   directory in its new location.
  ///
  public func copy(destination: Path) throws -> () {
    try Path.fileManager.copyItemAtPath(self.path, toPath: destination.path)
  }

  /// Creates a hard link at a new destination.
  ///
  /// - Parameter destination: The location where the link will be created.
  ///
  public func link(destination: Path) throws -> () {
    try Path.fileManager.linkItemAtPath(self.path, toPath: destination.path)
  }

  /// Creates a symbolic link at a new destination.
  ///
  /// - Parameter destintation: The location where the link will be created.
  ///
  public func symlink(destination: Path) throws -> () {
    try Path.fileManager.createSymbolicLinkAtPath(self.path, withDestinationPath: destination.path)
  }
}


// MARK: Current Directory

extension Path {
  /// The current working directory of the process
  ///
  /// - Returns: the current working directory of the process
  ///
  public static var current: Path {
    get {
      return self.init(Path.fileManager.currentDirectoryPath)
    }
    set {
      Path.fileManager.changeCurrentDirectoryPath(newValue.description)
    }
  }

  /// Changes the current working directory of the process to the path during the execution of the
  /// given block.
  ///
  /// - Note: The original working directory is restored when the block returns or throws.
  /// - Parameter closure: A closure to be executed while the current directory is configured to
  ///   the path.
  ///
  public func chdir(@noescape closure: () throws -> ()) rethrows {
    let previous = Path.current
    Path.current = self
    defer { Path.current = previous }
    try closure()
    }
}


// MARK: Temporary

extension Path {
  /// - Returns: the path to either the user’s or application’s home directory,
  ///   depending on the platform.
  ///
  public static var home: Path {
    return Path(NSHomeDirectory())
  }

  /// - Returns: the path of the temporary directory for the current user.
  ///
  public static var temporary: Path {
    return Path(NSTemporaryDirectory())
  }

  /// - Returns: the path of a temporary directory unique for the process.
  /// - Note: Based on `NSProcessInfo.globallyUniqueString`.
  ///
  public static func processUniqueTemporary() throws -> Path {
    let path = temporary + NSProcessInfo.processInfo().globallyUniqueString
    if !path.exists {
      try path.mkdir()
    }
    return path
  }

  /// - Returns: the path of a temporary directory unique for each call.
  /// - Note: Based on `NSUUID`.
  ///
  public static func uniqueTemporary() throws -> Path {
    let path = try processUniqueTemporary() + NSUUID().UUIDString
    try path.mkdir()
    return path
  }
}


// MARK: Contents

extension Path {
  /// Reads the file.
  ///
  /// - Returns: the contents of the file at the specified path.
  ///
  public func read() throws -> NSData {
    return try NSData(contentsOfFile: path, options: NSDataReadingOptions(rawValue: 0))
  }

  /// Reads the file contents and encoded its bytes to string applying the given encoding.
  ///
  /// - Parameter encoding: the encoding which should be used to decode the data.
  ///   (by default: `NSUTF8StringEncoding`)
  ///
  /// - Returns: the contents of the file at the specified path as string.
  ///
  public func read(encoding: NSStringEncoding = NSUTF8StringEncoding) throws -> String {
    return try NSString(contentsOfFile: path, encoding: encoding) as String
  }

  /// Write a file.
  ///
  /// - Note: Works atomically: the data is written to a backup file, and then — assuming no
  ///   errors occur — the backup file is renamed to the name specified by path.
  ///
  /// - Parameter data: the contents to write to file.
  ///
  public func write(data: NSData) throws {
    try data.writeToFile(normalize().path, options: .DataWritingAtomic)
  }

  /// Reads the file.
  ///
  /// - Note: Works atomically: the data is written to a backup file, and then — assuming no
  ///   errors occur — the backup file is renamed to the name specified by path.
  ///
  /// - Parameter string: the string to write to file.
  ///
  /// - Parameter encoding: the encoding which should be used to represent the string as bytes.
  ///   (by default: `NSUTF8StringEncoding`)
  ///
  /// - Returns: the contents of the file at the specified path as string.
  ///
  public func write(string: String, encoding: NSStringEncoding = NSUTF8StringEncoding) throws {
    try string.writeToFile(normalize().path, atomically: true, encoding: encoding)
  }
}


// MARK: Traversing

extension Path {
  /// Get the parent directory
  ///
  /// - Returns: the normalized path of the parent directory
  ///
  public func parent() -> Path {
    return self + ".."
  }

  /// Performs a shallow enumeration in a directory
  ///
  /// - Returns: paths to all files, directories and symbolic links contained in the directory
  ///
  public func children() throws -> [Path] {
    return try Path.fileManager.contentsOfDirectoryAtPath(path).map {
      self + Path($0)
    }
  }

  /// Performs a deep enumeration in a directory
  ///
  /// - Returns: paths to all files, directories and symbolic links contained in the directory or
  ///   any subdirectory.
  ///
  public func recursiveChildren() throws -> [Path] {
    return try Path.fileManager.subpathsOfDirectoryAtPath(path).map {
      self + Path($0)
    }
  }
}


// MARK: Globbing

extension Path {
  public static func glob(pattern: String) -> [Path] {
    var gt = glob_t()
    let cPattern = strdup(pattern)
    defer {
      globfree(&gt)
      free(cPattern)
    }

    let flags = GLOB_TILDE | GLOB_BRACE | GLOB_MARK
    if Darwin.glob(cPattern, flags, nil, &gt) == 0 {
      return (0..<Int(gt.gl_matchc)).flatMap { index in
        if let path = String.fromCString(gt.gl_pathv[index]) {
          return Path(path)
        }

        return nil
      }
    }

    // GLOB_NOMATCH
    return []
  }

  public func glob(pattern: String) -> [Path] {
    return Path.glob((self + pattern).description)
  }
}


// MARK: SequenceType

extension Path : SequenceType {
  /// Enumerates the contents of a directory, returning the paths of all files and directories
  /// contained within that directory. These paths are relative to the directory.
  public struct DirectoryEnumerator: GeneratorType {
    public typealias Element = Path

    let path: Path
    let directoryEnumerator: NSDirectoryEnumerator

    init(path: Path) {
      self.path = path
      self.directoryEnumerator = Path.fileManager.enumeratorAtPath(path.path)!
    }

    public func next() -> Path? {
      if let next = directoryEnumerator.nextObject() as! String? {
        return path + next
      }
      return nil
    }

    /// Skip recursion into the most recently obtained subdirectory.
    public func skipDescendants() {
      directoryEnumerator.skipDescendants()
    }
  }

  /// Perform a deep enumeration of a directory.
  ///
  /// - Returns: a directory enumerator that can be used to perform a deep enumeration of the
  ///   directory.
  ///
  public func generate() -> DirectoryEnumerator {
    return DirectoryEnumerator(path: self)
  }
}


// MARK: Equatable

extension Path : Equatable {}

/// Determines if two paths are identical
///
/// - Note: The comparison is string-based. Be aware that two different paths (foo.txt and
///   ./foo.txt) can refer to the same file.
///
public func ==(lhs: Path, rhs: Path) -> Bool {
  return lhs.path == rhs.path
}


// MARK: Pattern Matching

/// Implements pattern-matching for paths.
///
/// - Returns: `true` iff one of the following conditions is true:
///     - the paths are equal (based on `Path`'s `Equatable` implementation)
///     - the paths can be normalized to equal Paths.
///
public func ~=(lhs: Path, rhs: Path) -> Bool {
  return lhs == rhs
    || lhs.normalize() == rhs.normalize()
}


// MARK: Comparable

extension Path : Comparable {}

/// Defines a strict total order over Paths based on their underlying string representation.
public func <(lhs: Path, rhs: Path) -> Bool {
  return lhs.path < rhs.path
}


// MARK: Operators

/// Appends a Path fragment to another Path to produce a new Path
public func +(lhs: Path, rhs: Path) -> Path {
  return lhs.path + rhs.path
}

/// Appends a String fragment to another Path to produce a new Path
public func +(lhs: Path, rhs: String) -> Path {
  return lhs.path + rhs
}

/// Appends a String fragment to another String to produce a new Path
internal func +(lhs: String, rhs: String) -> Path {
  if rhs.hasPrefix(Path.separator) {
    // Absolute paths replace relative paths
    return Path(rhs)
  } else {
    var lSlice = (lhs as NSString).pathComponents.fullSlice
    var rSlice = (rhs as NSString).pathComponents.fullSlice

    // Get rid of trailing "/" at the left side
    if lSlice.count > 1 && lSlice.last == Path.separator {
      lSlice.removeLast()
    }

    // Advance after the first relevant "."
    lSlice = lSlice.filter { $0 != "." }.fullSlice
    rSlice = rSlice.filter { $0 != "." }.fullSlice

    // Eats up trailing components of the left and leading ".." of the right side
    while lSlice.last != ".." && rSlice.first == ".." {
      if (lSlice.count > 1 || lSlice.first != Path.separator) && !lSlice.isEmpty {
        // A leading "/" is never popped
        lSlice.removeLast()
      }
      if !rSlice.isEmpty {
        rSlice.removeFirst()
      }

      switch (lSlice.isEmpty, rSlice.isEmpty) {
      case (true, _):
        break
      case (_, true):
        break
      default:
        continue
      }
    }

    return Path(components: lSlice + rSlice)
  }
}

extension Array {
  var fullSlice: ArraySlice<Element> {
    return self[0..<self.endIndex]
  }
}
