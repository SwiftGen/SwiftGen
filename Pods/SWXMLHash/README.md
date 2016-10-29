# SWXMLHash

[![CocoaPods](https://img.shields.io/cocoapods/p/SWXMLHash.svg)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/SWXMLHash.svg)](https://cocoapods.org/pods/SWXMLHash)
[![Join the chat at https://gitter.im/drmohundro/SWXMLHash](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/drmohundro/SWXMLHash?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![codebeat](https://codebeat.co/badges/893cc640-c5d9-45b2-a3ff-426e6e6b7b80)](https://codebeat.co/projects/github-com-drmohundro-swxmlhash)

SWXMLHash is a relatively simple way to parse XML in Swift. If you're familiar with `NSXMLParser`, this library is a simple wrapper around it. Conceptually, it provides a translation from XML to a dictionary of arrays (aka hash).

The API takes a lot of inspiration from [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON).

## Contents

* [Requirements](#requirements)
* [Installation](#installation)
* [Getting Started](#getting-started)
* [Configuration](#configuration)
* [Examples](#examples)
* [FAQ](#faq)
* [Changelog](#changelog)
* [Contributing](#contributing)
* [License](#license)

## Requirements

- iOS 8.0+ / Mac OS X 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 7.1+

(note that Xcode 8 beta and Swift 3 support are being tracked in [PR 78](https://github.com/drmohundro/SWXMLHash/pull/78))

## Installation

SWXMLHash can be installed using [CocoaPods](http://cocoapods.org/), [Carthage](https://github.com/Carthage/Carthage), or manually.

### CocoaPods

To install CocoaPods, run:

```bash
$ gem install cocoapods
```

Then create a `Podfile` with the following contents:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod 'SWXMLHash', '~> 2.5.0'
```

Finally, run the following command to install it:

```bash
$ pod install
```

### Carthage

To install Carthage, run (using Homebrew):

```bash
$ brew update
$ brew install carthage
```

Then add the following line to your `Cartfile`:

```
github "drmohundro/SWXMLHash" ~> 2.5
```

### Manual Installation

To install manually, you'll need to clone the SWXMLHash repository. You can do this in a separate directory or you can make use of git submodules - in this case, git submodules are recommended so that your repository has details about which commit of SWXMLHash you're using. Once this is done, you can just drop the `SWXMLHash.swift` file into your project.

> NOTE: if you're targeting iOS 7, you'll have to install manually because embedded frameworks require a minimum deployment target of iOS 8 or OSX Mavericks.

## Getting Started

If you're just getting started with SWXMLHash, I'd recommend cloning the repository down and opening the workspace. I've included a Swift playground in the workspace which makes it *very* easy to experiment with the API and the calls.

<img src="https://raw.githubusercontent.com/drmohundro/SWXMLHash/assets/swift-playground@2x.png" width="600" alt="Swift Playground" />

## Configuration

SWXMLHash allows for limited configuration in terms of its approach to parsing. To set any of the configuration options, you use the `configure` method, like so:

```swift
let xml = SWXMLHash.config {
              config in
              // set any config options here
          }.parse(xmlToParse)
```

The available options at this time are:

* `shouldProcessLazily`
    * This determines whether not to use lazy loading of the XML. It can significantly increase the performance of parsing if your XML is very large.
    * Defaults to `false`
* `shouldProcessNamespaces`
    * This setting is forwarded on to the internal `NSXMLParser` instance. It will return any XML elements without their namespace parts (i.e. "\<h:table\>" will be returned as "\<table\>")
    * Defaults to `false`

## Examples

All examples below can be found in the included [specs](https://github.com/drmohundro/SWXMLHash/blob/master/Tests/).

### Initialization

```swift
let xml = SWXMLHash.parse(xmlToParse)
```

Alternatively, if you're parsing a large XML file and need the best performance, you may wish to configure the parsing to be processed lazily. Lazy processing avoids loading the entire XML document into memory, so it could be preferable for performance reasons. See the error handling for one caveat regarding lazy loading.

```swift
let xml = SWXMLHash.config {
              config in
              config.shouldProcessLazily = true
          }.parse(xmlToParse)
```

The above approach uses the new config method, but there is also a `lazy` method directly off of `SWXMLHash`.

```swift
let xml = SWXMLHash.lazy(xmlToParse)
```

### Single Element Lookup

Given:

```xml
<root>
  <header>
    <title>Foo</title>
  </header>
  ...
</root>
```

Will return "Foo".

```swift
xml["root"]["header"]["title"].element?.text
```

### Multiple Elements Lookup

Given:

```xml
<root>
  ...
  <catalog>
    <book><author>Bob</author></book>
    <book><author>John</author></book>
    <book><author>Mark</author></book>
  </catalog>
  ...
</root>
```

The below will return "John".

```swift
xml["root"]["catalog"]["book"][1]["author"].element?.text
```

### Attributes Usage

Given:

```xml
<root>
  ...
  <catalog>
    <book id="1"><author>Bob</author></book>
    <book id="123"><author>John</author></book>
    <book id="456"><author>Mark</author></book>
  </catalog>
  ...
</root>
```

The below will return "123".

```swift
xml["root"]["catalog"]["book"][1].element?.attribute(by: "id")?.text
```

Alternatively, you can look up an element with specific attributes. The below will return "John".

```swift
xml["root"]["catalog"]["book"].withAttr("id", "123")["author"].element?.text
```

### Returning All Elements At Current Level

Given:

```xml
<root>
  ...
  <catalog>
    <book><genre>Fiction</genre></book>
    <book><genre>Non-fiction</genre></book>
    <book><genre>Technical</genre></book>
  </catalog>
  ...
</root>
```

The below will return "Fiction, Non-fiction, Technical" (note the `all` method).

```swift
", ".join(xml["root"]["catalog"]["book"].all.map { elem in
  elem["genre"].element!.text!
})
```

Alternatively, you can just iterate over the elements using `for-in` directly against an element.

```swift
for elem in xml["root"]["catalog"]["book"] {
  NSLog(elem["genre"].element!.text!)
}
```

### Returning All Child Elements At Current Level

Given:

```xml
<root>
  <catalog>
    <book>
      <genre>Fiction</genre>
      <title>Book</title>
      <date>1/1/2015</date>
    </book>
  </catalog>
</root>
```

The below will `NSLog` "root", "catalog", "book", "genre", "title", and "date" (note the `children` method).

```swift
func enumerate(indexer: XMLIndexer) {
  for child in indexer.children {
    NSLog(child.element!.name)
    enumerate(child)
  }
}

enumerate(xml)
```

### Error Handling

Using Swift 2.0's new error handling feature:

```swift
do {
  try xml!.byKey("root").byKey("what").byKey("header").byKey("foo")
} catch let error as XMLIndexer.Error {
  // error is an XMLIndexer.Error instance that you can deal with
}
```

__Or__ using the existing indexing functionality (__NOTE__ that the `.Error` case has been renamed to `.XMLError` so as to not conflict with the `XMLIndexer.Error` error type):

```swift
switch xml["root"]["what"]["header"]["foo"] {
case .Element(let elem):
  // everything is good, code away!
case .XMLError(let error):
  // error is an XMLIndexer.Error instance that you can deal with
}
```

Note that error handling as shown above will not work with lazy loaded XML. The lazy parsing doesn't actually occur until the `element` or `all` method are called - as a result, there isn't any way to know prior to asking for an element if it exists or not.

### Types conversion

Given:

```xml
<root>
  <books>
    <book isbn="0000000001">
      <title>Book A</title>
      <price>12.5</price>
      <year>2015</year>
    </book>
    <book isbn="0000000002">
      <title>Book B</title>
      <price>10</price>
      <year>1988</year>
    </book>
    <book isbn="0000000003">
      <title>Book C</title>
      <price>8.33</price>
      <year>1990</year>
      <amount>10</amount>
    </book>
  <books>
</root>
```
with `Book` struct implementing `XMLIndexerDeserializable`:

```swift
struct Book: XMLIndexerDeserializable {
    let title: String
    let price: Double
    let year: Int
    let amount: Int?
    let isbn: Int

    static func deserialize(node: XMLIndexer) throws -> Book {
        return try Book(
            title: node["title"].value(),
            price: node["price"].value(),
            year: node["year"].value(),
            amount: node["amount"].value(),
            isbn: node.value(ofAttribute: "isbn")
        )
    }
}
```

The below will return array of `Book` structs:

```swift
let books: [Book] = try xml["root"]["books"]["book"].value()
```

<img src="https://raw.githubusercontent.com/ncreated/SWXMLHash/assets/types-conversion%402x.png" width="600" alt="Types Conversion" />

You can convert any XML to your custom type by implementing `XMLIndexerDeserializable` for any non-leaf node (e.g. `<book>` in the example above).

For leaf nodes (e.g. `<title>` in the example above), built-in converters support `Int`, `Double`, `Float`, `Bool`, and `String` values (both non- and -optional variants). Custom converters can be added by implementing `XMLElementDeserializable`.

For attributes (e.g. `isbn=` in the example above), built-in converters support the same types as above, and additional converters can be added by implementing `XMLAttributeDeserializable`.

Types conversion supports error handling, optionals and arrays. For more examples, look into `SWXMLHashTests.swift` or play with types conversion directly in the Swift playground.


## FAQ

### Does SWXMLHash handle URLs for me?

No - SWXMLHash only handles parsing of XML. If you have a URL that has XML content on it, I'd recommend using a library like [AlamoFire](https://github.com/Alamofire/Alamofire) to download the content into a string and then parsing it.

### Does SWXMLHash support writing XML content?

No, not at the moment - SWXMLHash only supports parsing XML (via indexing, deserialization, etc.).

### I'm getting an "Ambiguous reference to member 'subscript'" when I call `.value()`.

`.value()` is used for deserialization - you have to have something that implements `XMLIndexerDeserializable` and that can handle deserialization to the left-hand side of expression.

For example, given the following:

```swift
let dateValue: NSDate = try! xml["root"]["date"].value()
```

You'll get an error because there isn't any built-in deserializer for `NSDate`. See the above documentation on adding your own deserialization support.

### I'm getting an `EXC_BAD_ACCESS (SIGSEGV)` when I call `parse()`

Chances are very good that your XML content has what is called a "byte order mark" or BOM. SWXMLHash uses `NSXMLParser` for its parsing logic and there are issues with it and handling BOM characters. See [issue #65](https://github.com/drmohundro/SWXMLHash/issues/65) for more details. Others who have run into this problem have just rstripped the BOM out of their content prior to parsing.

### Have a different question?

Feel free to shoot me an email, post a [question on StackOverflow](http://stackoverflow.com/questions/tagged/swxmlhash), or open an issue if you think you've found a bug. I'm happy to try to help!

## Changelog

See [CHANGELOG](CHANGELOG.md) for a list of all changes and their corresponding versions.

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md) for guidelines to contribute back to SWXMLHash.

## License

SWXMLHash is released under the MIT license. See [LICENSE](LICENSE) for details.
