# Files parser

## Input

The files parser is intended to just list the name and mimetype of the files and subdirectories in a given directory. Unlike other parsers, this one doesn't parse the file content per se, but only list those files so that you can point to them (get back their path or URL relative to your bundle) easily in your code. The parser accepts multiple files or directories, which it will recursively search for files that match the given filter (default `.*`).

The list of files will be converted into a structured directory tree, where each directory contains a list of the files and directories within that directory. For example the following file tree:

```
Files/
  test.txt
  a video.mp4
  subfolder/
    more.txt
    files.txt
  folder/
    file.dat
```

will be parsed into the following structure (not showing the rest of the structure, such as values and types):

```swift
[
  "files": [
    "test.txt",
    "a video.mp4"
  ],
  "directories": [
    "subfolder": [
      "files": [
        "more.txt",
        "files.txt"
      ]
    ],
    "folder": [
      "files": [
        "file.dat"
      ]
    ]
  ]
]
```

## Filter

The default filter for this command is: `.*`.

You can provide a custom filter using the `filter` option, it accepts any valid regular expression. See the [Config file documentation](../ConfigFile.md) for more information.

## Customization

| Option Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `relativeTo` | N/A | Use to specify a specific directory from which files will be referenced. |
| `compact` | N/A | Set to `true` to eliminate a common ancestor hierarchy to reduce nested `enums` when using the `structured-swift5` template. |

## Templates

* [See here](../templates/files) for a list of templates bundled with SwiftGen and their documentation.
* If you want to write custom templates, make sure to check the [stencil context documentation](../SwiftGenKit%20Contexts/files.md) to see what data is available after parsing.

## `relativeTo`

When accessing files from the `Bundle`, the files need to be accessed in reference to the bundle path. More often than not, Xcode flattens that hierarchy into one folder. However, including folder references in the project copies those hierarchies as is, and `Bundle.url(...)` and `Bundle.path(...)` need relative subdirectory reference. `relativeTo` allows you to specify the root resources directory if you need it.

<details>
<summary>Example</summary>

With a given arbitrary deep hierarchy:

```
Files/
  *other files*
  folder/
    *other files*
    another folder/
      file.dat
```

and a filter set to `.+\.dat$` to match all `.dat` files, set `relativeTo` to `[full path]/Files/` to output:

```yaml
directories:
- name: folder
  directories:
    - name: another folder
      files:
      - name: "file"
        ext: "dat"
        path: "folder/another folder"
        mimeType: "application/octet-stream"
```

Using the `structured-swift5` template will produce the following output:

```swift
internal enum Files {
  /// folder/
  internal enum folder {
    /// folder/another folder/
    internal enum anotherFolder {
      /// folder/another folder/file.dat
      internal static let fileDat = File(name: "file", ext: "dat", path: "folder/another folder", mimeType: "application/octet-stream")
    }
  }
}
```

</details>

## `compact`

Similarly to `relativeTo`, compact would only be necessary with some arbitrary hierarchy of files and is useful when used with `relativeTo`. If you're needing to parse files deep in the hierarchy, but want to maintain a subset of the file tree with the `structured-swift5` template, `compact` reduces common ancestor directory references which contain only another directory. The `flat-swift5` template has a similar effect, however eliminates all nested `enums` instead.

<details>
<summary>Example</summary>

With a given arbitrary deep hierarchy:

```
Files/
  *other files*
  folder/
    *other files*
    another folder/
      file.dat
    some other folder/
      data.dat
```

and a filter set to `.+\.dat$` to match all `.dat` files, set `relativeTo` to `[full path]/Files/` and `compact` to `true` to output:

```yaml
directories:
- name: another folder
  files:
  - name: "file"
    ext: "dat"
    path: "folder/another folder"
    mimeType: "application/octet-stream"
- name: some other folder
  files:
  - name: "data"
    ext: "dat"
    path: "folder/some other folder"
    mimeType: "application/octet-stream"
```

Using the `structured-swift5` template will produce the following output:

```swift
internal enum Files {
  /// folder/another folder/
  internal enum anotherFolder {
    /// folder/another folder/file.dat
    internal static let fileDat = File(name: "file", ext: "dat", path: "folder/another folder", mimeType: "application/octet-stream")
  }
  /// folder/some other folder/
  internal enum someOtherFolder {
    /// folder/some other folder/data.dat
    internal static let fileDat = File(name: "data", ext: "dat", path: "folder/some other folder", mimeType: "application/octet-stream")
  }
}
```

</details>
