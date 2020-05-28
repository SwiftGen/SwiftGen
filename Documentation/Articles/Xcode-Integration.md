# Integrate SwiftGen in your Xcode project

To integrate SwiftGen directly in an Xcode project, and make it generate the files every time you build your project, you can simply add a "Run Script Phase" to your Xcode project.

## Adding SwiftGen as a Run Script Phase

You can read [Apple's dedicated documentation which explains how to add a Run Script Phase (with illustrations) here](https://help.apple.com/xcode/mac/10.0/index.html?localePath=en.lproj#/devc8c930575).

In short, it consists of these steps:

* Select the project in the Project Navigator on the left of your Xcode window
* Select your App Target in the list
* Go in the "Build Phases" tab
* Click on the "+" button on the upper left corner and choose "New Run Script Phase"

Then name the script phase anyway you like, and write the script invoking SwiftGen the same way you'd invoke it from the Terminal.

---

For example, your Script Build Phase should look like this if you integrated SwiftGen via CocoaPods:

```sh
"$PODS_ROOT/SwiftGen/bin/swiftgen"
```

Or like this if you downloaded SwiftGen via the ZIP installation method and unzipped it at the root of your repository:

```sh
"$PROJECT_ROOT/SwiftGen/bin/swiftgen"
```

Or could look like this if you installed `swiftgen` system-wide with homebrew (adding some security in case your coworkers didn't install SwiftGen on their machine)
```sh
if which swiftgen >/dev/null; then
  swiftgen
else
  echo "warning: SwiftGen not installed, download it from https://github.com/SwiftGen/SwiftGen"
fi
```

---

Note: Those script phase examples above all assume that you're [using a `swiftgen.yml` config file](ConfigFile.md) to configure which SwiftGen parsers (`strings`, `fonts`, …) to run, the templates to use, etc

> Tip: If you don't use a `swiftgen.yml` config file, first I'd strongly suggest you to use one :wink: but if you still want to invoke SwiftGen multiple times, one parser at a time, I'd suggest to use `/bin/sh -e` (so add the `-e` flag) in the "Shell" field of your Build Phase, so that the build phase will fail as soon as one of the SwiftGen commands fails. Otherwise your Build Phase's exit code will only reflect the exit code of the last command of the script, so your Build Phase could be considered to pass even if one of the command except the last failed. This is another reason (in addition to performance) why using a config file is recommended instead.

### Fixing looping and/or cancelled build issues due to `IBDesignable`

When adding SwiftGen as a build phase in your project, if instead of using a Config file you invoked individual parsers from the command line via `swiftgen run`, then sometimes builds can cancel because Xcode doesn't like source code changes happening mid-build. It can also cause issues with `IBDesignable` views triggering looping builds when opening storyboards.

To avoid this, **we highly recommand using a `swiftgen.yml` configuration file instead of invoking the parsers directly from the command line**. But if you still want to invoke parsers from the command line, be sure to use `--output` to specify the output file to write (instead of a `> output-file.swift` redirection for example). Doing this allows SwiftGen to avoid re-writing the file to disk if the content is not modified.

Typically don't use:
```sh
swiftgen xcassets Resources/Images.xcassets --templateName swift5 > "Constants/Assets+Generated.swift"
```

But use:
```sh
swiftgen xcassets Resources/Images.xcassets --templateName swift5 --output "Constants/Assets+Generated.swift"
```

Or even better, just use `swiftgen` in your Script Build Phase, and specify this in your `swiftgen.yml` config file:

```yaml
xcassets:
  inputs: Resources/Images.xcassets
  outputs:
    templateName: swift5
    output: Constants/Assets+Generated.swift
```

That way, the `Constants/Assets+Generated.swift` file will only be overwritten if the contents of `Images.xcassets` has changed since the last generation, and will be kept unmodified otherwise.
