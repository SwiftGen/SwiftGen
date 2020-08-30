# Files parser

## Input

The files parser is intended to just list the name and mimetype of the files and subdirectories in a given directory. Unlike other parsers, this one doesn't parse the file content per se, but only list those files so that you can point to them (get back their path or URL relative to your bundle) easily in your code. The parser accepts multiple files or directories, which it will recursively search for files that match the given filter (default `.*`).

The list of files will be converted into a structured directory tree.

## Filter

The default filter for this command is: `.*`.

You can provide a custom filter using the `filter` option, it accepts any valid regular expression. See the [Config file documentation](../ConfigFile.md) for more information.

## Customization

This parser currently doesn't accept any options.

## Templates

* [See here](../templates/files) for a list of templates bundled with SwiftGen and their documentation.
* If you want to write custom templates, make sure to check the [stencil context documentation](../SwiftGenKit%20Contexts/files.md) to see what data is available after parsing.
