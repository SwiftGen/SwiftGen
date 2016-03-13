# PathKit

[![Build Status](https://travis-ci.org/kylef/PathKit.svg)](https://travis-ci.org/kylef/PathKit)

Effortless path operations in Swift.

## Usage

```swift
let path = Path("/usr/bin/swift")
```

#### Joining paths

```swift
let path = Path("/usr/bin") + Path("swift")
```

#### Determine if a path is absolute

```swift
path.isAbsolute()
```

#### Determine if a path is relative

```swift
path.isRelative()
```

#### Determine if a file or directory exists at the path

```swift
path.exists()
```

#### Determine if a path is a directory

```swift
path.isDirectory()
```

#### Get an absolute path

```swift
let absolutePath = path.absolute()
```

#### Normalize a path

This cleans up any redundant `..` or `.` and double slashes in paths.

```swift
let normalizedPath = path.normalize()
```

#### Deleting a path

```swift
path.delete()
```

#### Moving a path

```swift
path.move(newPath)
```

#### Current working directory

```swift
Path.current
Path.current = "/usr/bin"
```

#### Changing the current working directory

```swift
path.chdir {
  // Path.current would be set to path during execution of this closure
}
```

#### Children paths

```swift
path.children()
```

#### Reading

```swift
path.read()
```

#### Writing

```swift
path.write("Hello World!")
```

#### Glob

```swift
let paths = Path.glob("*.swift")
```

### Contact

Kyle Fuller

- https://fuller.li
- https://twitter.com/kylefuller

### License

PathKit is licensed under the [BSD License](LICENSE).

