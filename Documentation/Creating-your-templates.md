# Customize SwiftGen templates

This document describes how to make your own templates for SwiftGen, so it can generate code more to your liking and code following your own coding conventions. For in depth documentation of the bundled templates, we refer you to the documentation for [each specific template](templates).

## Templates files on disk (Search Path priority)

When you invoke SwiftGen, you can specify templates by name or by path.

### Using a full path

If you use the `templatePath` configuration option, you'll need to specify the **relative path** to the template you want to use. This allows you to store your templates anywhere you want (typically in the same folder or git repository of the project in need of those custom templates).

### Using a name

When you use the `templateName` configuration option, you only specify a **template name**. SwiftGen then searches a matching template using the following rules (where `<parser>` is one of `colors`, `ib`, `json`, `plist`, `strings`, `xcassets`, … depending on the parser you invoke):

* It searches for a file named `<name>.stencil` in `~/Library/Application Support/SwiftGen/templates/<parser>/`, which is supposed to contain your own custom templates for that particular parser.
* If it does not find one, it searches for a file named `<name>.stencil` in `<installdir>/share/swiftgen/templates/<parser>` which contains the templates bundled with SwiftGen for that particular parser.

For example `templateName: foo` will search for a template named `foo.stencil` in Application Support, then in `/usr/local/share/SwiftGen/templates/xcassets` (assuming you installed SwiftGen using Homebrew in `/usr/local`)

## List installed templates

The `swiftgen template list` command will list all the installed templates (as YAML output) for each parser, both for bundled templates and custom templates.

```bash
$ swiftgen template list
colors:
  custom:
  bundled:
   - literals-swift4
   - literals-swift5
   - swift4
   - swift5
coredata:
  custom:
  bundled:
   - swift4
   - swift5
fonts:
  custom:
  bundled:
   - swift4
   - swift5
ib:
  custom:
   - mytemplate
  bundled:
   - scenes-swift4
   - scenes-swift5
   - segues-swift4
   - segues-swift5
json:
  custom:
  bundled:
   - inline-swift4
   - inline-swift5
   - runtime-swift4
   - runtime-swift5
plist:
  custom:
  bundled:
   - inline-swift4
   - inline-swift5
   - runtime-swift4
   - runtime-swift5
strings:
  custom:
   - mycustomtemplate
  bundled:
   - flat-swift4
   - flat-swift5
   - objc-h
   - objc-m
   - structured-swift4
   - structured-swift5
xcassets:
  custom:
  bundled:
   - swift4
   - swift5
yaml:
  custom:
  bundled:
   - inline-swift4
   - inline-swift5
storyboards:
  custom:
  bundled:
   - scenes-swift4
   - scenes-swift5
   - segues-swift4
   - segues-swift5
```

## Printing a template, creating a new template

You can use the `swiftgen template cat <parser> <templatename>` command to print the template of that given name for that given parser to `stdout`. e.g. `swiftgen template cat fonts swift5` will print to your terminal the template that would be used if you invoke `fonts` with `template: swift5`.

You can use this feature to easily create a new template from an existing one.
In particular, the easiest way to create your own templates is to:

* duplicate an existing template by dumping it into a new file like this: `swiftgen template cat fonts swift5 >my-custom-fonts-template.stencil`
* then edit the new `my-custom-fonts-template.stencil` file to make your modifications to that template
* Once you've done this you can then simply use `templatePath: my-custom-fonts-template.stencil` in your configuration file to use you customized template!

## Templates Format, Nodes and Filters

Templates in SwiftGen are based on [Stencil](https://stencil.fuller.li/), a template engine inspired by Django and Mustache. The syntax of the templates [is explained in Stencil's documentation](https://stencil.fuller.li/en/latest/templates.html).

Additionally to the [tags and filters](https://stencil.fuller.li/en/latest/builtins.html) provided by Stencil, SwiftGen provides some additional ones, documented in the [StencilSwiftKit framework](https://github.com/SwiftGen/StencilSwiftKit).

## Templates Contexts

When SwiftGen generates your code, it provides a context (a dictionary) with the variables containing what assets/colors/strings/… the parser did detect, to render your Stencil template using those variables.

A full documentation of the produced context for each command can be found in the [SwiftGenKit documentation](SwiftGenKit%20Contexts).
