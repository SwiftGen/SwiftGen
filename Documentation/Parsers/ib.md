# Interface Builder parser

## Input

The interface builder parser accepts either a file or a directory, which it'll search for `storyboard` files. The parser will load all the scenes and all the segues for each storyboard. It supports both AppKit (macOS) and UIKit (iOS, watchOS, tvOS) storyboards.

### Filter

The default filter for this command is: `[^/]\.storyboard$`. That means it'll accept any file with the extension `storyboard`.

You can provide a custom filter using the `filter` option, it accepts any valid regular expression. See the [Config file documentation](../ConfigFile.md) for more information.

## Customization

This parser currently doesn't accept any options.

## Templates

* [See here](../templates/ib) for a list of templates bundled with SwiftGen and their documentation.
* If you want to write custom templates, make sure to check the [stencil context documentation](../SwiftGenKit%20Contexts/ib.md) to see what data is available after parsing.
