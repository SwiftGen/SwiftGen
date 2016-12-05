# Stencil

[![Build Status](https://travis-ci.org/kylef/Stencil.svg?branch=master)](https://travis-ci.org/kylef/Stencil)

Stencil is a simple and powerful template language for Swift. It provides a
syntax similar to Django and Mustache. If you're familiar with these, you will
feel right at home with Stencil.

## Example

```html+django
There are {{ articles.count }} articles.

<ul>
  {% for article in articles %}
    <li>{{ article.title }} by {{ article.author }}</li>
  {% endfor %}
</ul>
```

```swift
struct Article {
  let title: String
  let author: String
}

let context = Context(dictionary: [
  "articles": [
    Article(title: "Migrating from OCUnit to XCTest", author: "Kyle Fuller"),
    Article(title: "Memory Management with ARC", author: "Kyle Fuller"),
  ]
])

do {
  let template = try Template(named: "template.html")
  let rendered = try template.render(context)
  print(rendered)
} catch {
  print("Failed to render template \(error)")
}
```

## Installation

Installation with Swift Package Manager is recommended.

### CocoaPods

```ruby
pod 'Stencil'
```

## Philosophy

Stencil follows the same philosophy of Django:

> If you have a background in programming, or if you’re used to languages which
> mix programming code directly into HTML, you’ll want to bear in mind that the
> Django template system is not simply Python embedded into HTML. This is by
> design: the template system is meant to express presentation, not program
> logic.

## The User Guide

- [Templates](http://stencil.fuller.li/en/latest/templates.html)
- [Built-in template tags and filters](http://stencil.fuller.li/en/latest/builtins.html)
- [Custom Template Tags and Filters](http://stencil.fuller.li/en/latest/custom-template-tags-and-filters.html)

## License

Stencil is licensed under the BSD license. See [LICENSE](LICENSE) for more
info.
