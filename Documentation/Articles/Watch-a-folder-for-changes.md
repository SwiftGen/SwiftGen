# Run SwiftGen every time a folder is changed

To use SwiftGen we recommend that you [[use a Script Build Phase|Integrate-SwiftGen-in-an-xcodeproj]] to make sure your generated files are always in sync with your sources.

But as an alternative, you might be interested in watching a specific directory instead, and invoke `swiftgen` when files in this watched directory change.

* That prevents you to have to trigger a build to make your constants up-to-date after adding new files or strings for example (supposing that you start the watcher every time you start developing on you project to start the watching and auto-update of your files, though)
* This can also be **super useful if you plan to create your own custom templates**, as it will allow you to watch your template file and iterate to check what the generated code looks like very time you modify and save your template, allowing some trial-and-error mode until you reach exactly the desired output.

---

If you're interested in such a solution, we recommend to use [kicker](https://github.com/alloy/kicker) which is a very handy and fully-configurable tool to watch files and folders and automatically execute custom commands and recipes when files are added, removed or modified.

## Examples

### Watch an Assts catalog and regenerate constants every time it changed

To watch your Assets catalog folder and regenerate the constants for images every time your asset catalog is changed, you can use:

```sh
kicker -e "swiftgen images -t swift3 -o Generated/Images-Generated.swift /path/to/Images.xcassets" /path/to/your/Images.xcassets
```

### Create a custom template and look at the generated code live as you edit and save it

And if you're writing a custom template, you can use a command similar to the following to watch the template file you're writing and auto-regenerate the output using that same template every time you modify it:

```sh
kicker -e "swiftgen images -p /path/to/my/custom/template.stencil -o test-output.swift /path/to/Images.xcassets" /path/to/my/custom/template.stencil
```

This use of kicker (or any other tool allowing to do similar watching of a folder) can allow you to edit custom templates like you use Swift Playgrounds: you can split your screen or your favorite text editor (Sublime Text, Atom, …) in 2 windows, one containing the template you edit, the other containing the output, and see the test output on the second window being updated live.
