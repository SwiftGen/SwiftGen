# Files parser

## Input

The files parser is intended to just list the name and mimetype of the files and subdirectories in a given directory. Unlike other parsers, this one doesn't parse the file content per se, but only list those files so that you can point to them (get back their path or URL relative to your bundle) easily in your code. The parser accepts multiple files or directories, which it will recursively search for files that match the given filter (default `.*`).

The list of files will be converted into a structured directory tree.

## Output

The output context has the following structure:

-`files`: `Array<File>` — list of files in the base directory specified
-`dirs`: `Array` — tree structure of subdirectory and its contents
 -`name`: `String` — name of the directory
 -`files`: `Array<File>` — list of files in this directory
 -`dirs`: `Array` — recursive tree of subdirectories

Each `File` has the following properties:

-`name`: `String` — name of the file
-`ext`: `String` — file extension
-`path`: `String` — the path to the file, relative to the folder being scanned
-`mimeType`: `String` — mime type of the file

## Example

```yaml
files:
- name: "File"
  ext: ""
  path: ""
  mimeType: "application/octet-stream"
- name: "test"
  ext: "txt"
  path: ""
  mimeType: "text/plain"
dirs:
- name: "empty intermediate"
  dirs:
  - name: "subfolder"
    files:
    - name: "another video"
      ext: "mp4"
      path: "empty intermediate/subfolder"
      mimeType: "video/mp4"
- name: "subdir"
  files:
  - name: "A Video With Spaces"
    ext: "mp4"
    path: "subdir"
    mimeType: "video/mp4"
  dirs:
  - name: "subdir"
    files:
    - ext: "svg"
      mimeType: "image/svg+xml"
      name: "graphic"
      path: "subdir/subdir"
```
