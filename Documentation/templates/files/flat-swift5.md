## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | files/flat-swift5.stencil |
| Configuration example | <pre>files:<br />  inputs: dir/to/search/with/filter<br />  filter: .+\.*$<br />  outputs:<br />    templateName: flat-swift5<br />    output:Files.swift</pre> |
| Language | Swift 5 |
| Author | Mike Gray |

## When to use it

- When you need to generate *Swift 5* code.
- If you don't need a directory structure for your files
- **NOTE:** This template does not handle uniquing file names. Behavior with file name clashes is undefined

## Customization

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `bundle` | `BundleToken.bundle` | Allows you to set from which bundle files are loaded from. By default, it'll point to the same bundle as where the generated code is. |
| `enumName` | `Files` | Allows you to change the name of the generated `enum` containing the file tree. |
| `useExtension` | `true` | Whether or not to use the extension in the name of the constant. i.e. `let testTxt` vs `let test`. Behavior is undefined with file name conflicts. |
| `resourceTypeName` | `File` | Allows you to change the name of the struct type representing a file. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |

## Generated Code

**Extract:**

```swift
internal enum Files {
  /// test.txt
  internal static let testTxt = File(name: "test", ext: "txt", path: "", mimeType: "text/plain")
  /// subdir/A Video With Spaces.mp4
  internal static let aVideoWithSpacesMp4 = File(name: "A Video With Spaces", ext: "mp4", path: "subdir", mimeType: "video/mp4")
}
```

[Full generated code](../../../Tests/Fixtures/Generated/Files/flat-swift5/defaults.swift)

## Usage example

```swift
// Access files using the `url` or `path` fields
let txt = Files.testTxt.url
let video = Files.aVideoWithSpacesMp4.path

// In addition, there are `url(locale:)` and `path(locale:)` to specify a locale
let txt = Files.testTxt.url(locale: Locale.current)
let video = Files.aVideoWithSpacesMp4.path(locale: Locale.current)
```
