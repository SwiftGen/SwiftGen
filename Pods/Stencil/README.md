# Stencil

[![Build Status](https://travis-ci.org/kylef/Stencil.svg?branch=master)](https://travis-ci.org/kylef/Stencil)

Stencil is a simple and powerful template language for Swift. It provides a
syntax similar to Django and Mustache. If you're familiar with these, you will
feel right at home with Stencil.

## Example

```html+django
There are {{ articles.count }} articles.

{% for article in articles %}
  - {{ article.title }} by {{ article.author }}.
{% endfor %}
```

```swift
let context = Context(dictionary: [
  "articles": [
    [ "title": "Migrating from OCUnit to XCTest", "author": "Kyle Fuller" ],
    [ "title": "Memory Management with ARC", "author": "Kyle Fuller" ],
  ]
])

do {
  let template = try Template(named: "template.stencil")
  let rendered = try template.render(context)
  print(rendered)
} catch {
  print("Failed to render template \(error)")
}
```

## Installation

Installation with CocoaPods is recommended.

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

## Templates

### Variables

A variable can be defined in your template using the following:

```html+django
{{ variable }}
```

Stencil will look up the variable inside the current variable context and
evaluate it. When a variable contains a dot, it will try doing the
following lookup:

- Context lookup
- Dictionary lookup
- Array lookup (first, last, count, index)
- Key value coding lookup

For example, if `people` was an array:

```html+django
There are {{ people.count }} people. {{ people.first }} is the first person,
followed by {{ people.1 }}.
```

#### Filters

Filters allow you to transform the values of variables. For example, they look like:

```html+django
{{ variable|uppercase }}
```

##### Capitalize

The capitalize filter allows you to capitalize a string.
For example, `stencil` to `Stencil`.

```html+django
{{ "stencil"|capitalize }}
```

##### Uppercase

The uppercase filter allows you to transform a string to uppercase.
For example, `Stencil` to `STENCIL`.

```html+django
{{ "Stencil"|uppercase }}
```

##### Lowercase

The uppercase filter allows you to transform a string to lowercase.
For example, `Stencil` to `stencil`.

```html+django
{{ "Stencil"|lowercase }}
```

### Tags

Tags are a mechanism to execute a piece of code, allowing you to have
control flow within your template.

```html+django
{% if variable %}
  {{ variable }} was found.
{% endif %}
```

A tag can also affect the context and define variables as follows:

```html+django
{% for item in items %}
  {{ item }}
{% endfor %}
```

Stencil has a couple of built-in tags which are listed below. You can also
extend Stencil by providing your own tags.

#### for

A for loop allows you to iterate over an array found by variable lookup.

```html+django
{% for item in items %}
  {{ item }}
{% empty %}
  There were no items.
{% endfor %}
```

#### if

```html+django
{% if variable %}
  The variable was found in the current context.
{% else %}
  The variable was not found.
{% endif %}
```

#### ifnot

```html+django
{% ifnot variable %}
  The variable was NOT found in the current context.
{% else %}
  The variable was found.
{% endif %}
```

#### include

You can include another template using the `include` tag.

```html+django
{% include "comment.html" %}
```

The `include` tag requires a TemplateLoader to be found inside your context with the paths, or bundles used to lookup the template.

```swift
let context = Context(dictionary: [
  "loader": TemplateLoader(bundle:[NSBundle.mainBundle()])
])
```

### Customisation

You can build your own custom filters and tags and pass them down while
rendering your template. Any custom filters or tags must be registered
with a namespace which contains all filters and tags available to the template.

```swift
let namespace = Namespace()
// Register your filters and tags with the namespace
let rendered = try template.render(context, namespace: namespace)
```

#### Registering custom filters

```swift
namespace.registerFilter("double") { value in
  if let value = value as? Int {
    return value * 2
  }

  return value
}
```

#### Building custom tags

You can build a custom template tag. There are a couple of APIs to allow
you to write your own custom tags. The following is the simplest form:

```swift
namespace.registerSimpleTag("custom") { context in
  return "Hello World"
}
```

When your tag is used via `{% custom %}` it will execute the registered block
of code allowing you to modify or retrieve a value from the context. Then
return either a string rendered in your template, or throw an error.

If you want to accept arguments or to capture different tokens between two sets
of template tags. You will need to call the `registerTag` API which accepts a
closure to handle the parsing. You can find examples of the `now`, `if` and
`for` tags found inside `Node.swift`.

The architecture of Stencil along with how to build advanced plugins can be
found in the [architecture](ARCHITECTURE.md) document.

### Comments

To comment out part of your template, you can use the following syntax:

```html+django
{# My comment is completely hidden #}
```

## License

Stencil is licensed under the BSD license. See [LICENSE](LICENSE) for more
info.
