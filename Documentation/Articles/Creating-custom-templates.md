# Customize SwiftGen templates

SwiftGen is shipped with built-in templates that generally covers most of people's needs. But sometimes, you might want to adapt the output of SwiftGen to cover some special needs you might have. That's why SwiftGen is built on a system of templates that you can customize.

## Check parameters of built-in templates first

Before creating your own templates, you might want to check if there isn't already a build-in template fulfilling your needs. Some of our built-in templates already provide parameters that you can use in your config file to slightly modify their behavior and output.

You can [check the documentation of the bundled templates](../templates/) (or use `swiftgen template doc <parser> <templatename>` to open the documentation from your terminal) to see what parameters each template does support, and see if one already fits your needs.

Note: you can use the `swiftgen template list` command to list all the installed templates for each parser and pick one to start with.

## Creating your own custom template

If none of the built-in templates match your needs even with the various parameters they support, you might want to consider creating your own template.

The easiest way to create your own custom template is to duplicate an existing template then modify it. You can use `swiftgen template cat <parser> <templatename>` to help you with that:

* Start by choosing the built-in template that would be the best fitting starting point for your case
* Use `swiftgen template cat` to dump its content into a new file, e.g. `swiftgen template cat fonts swift5 >my-custom-fonts-template.stencil`
* Edit the new file (`my-custom-fonts-template.stencil`) to make your modifications to that template.
* Once you are happy with your new custom template, you can simply use `templatePath: my-custom-fonts-template.stencil` in your configuration file to use your customized template

See below for the Stencil format and syntax used to write template in SwiftGen.

### Tip: Iterative process when working on your templates

Because getting the exact result you want generally needs you to iterate and test the intermediate result over and over, it could be useful to have a good iterative process to check that your custom templates will generate what you actually want.

For this, you could [use a tool like `kicker`](Watch-a-folder-for-changes.md) that could help you automatically re-run `swiftgen` every time you save your changes to your custom template while working on it.  
That way, you can keep your favorite editor open in Split mode for example, with the template on one side and the result on the other, and let `kicker` update the generated result every time you save your template

## Templates Format, Nodes and Filters

Templates in SwiftGen are based on [Stencil](https://stencil.fuller.li/), a template engine inspired by Django and Mustache. The syntax of the templates [is explained in Stencil's documentation](https://stencil.fuller.li/en/latest/templates.html).

Additionally to the [tags and filters](https://stencil.fuller.li/en/latest/builtins.html) provided by Stencil, SwiftGen provides some additional ones, documented in the [StencilSwiftKit framework](https://github.com/SwiftGen/StencilSwiftKit).

## Templates Contexts

When SwiftGen generates your code, it provides what we call a context (basically a dictionary of variables) with the variables containing what assets/colors/strings/… the parser did detect, to render your Stencil template using those variables.

> This is part of the architecture of SwiftGen, where SwiftGen first parses your resources (like asset catalogs or strings files etc) into those "contexts" (abstract structures) and then inject those contexts to your templates to transform those into your generated code
> 
> ```
>                                          +----------+
>                                          | Template |
>                                          +-----+----+
> +---------------+        +-------------+       |      +------------+
> | Resource file |        | SwiftGenKit |       v      | Generated  |
> | (e.g. Assets) | -----> |   Context   | ------+----->| Swift code |
> +---------------+        +-------------+              +------------+
> 
> \_ _ _ _ _ _ _ _ _ _ _ _ _ _ _/   \_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _/
>      SwiftGenKit framework             Stencil Template Engine
> \_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _/
>                        SwiftGen Command Line
> ```


A full documentation of the produced context for each command can be found in the [SwiftGenKit documentation](../SwiftGenKit%20Contexts/).
