# Using SwiftGen in Continuous Integration

The recommended way to use SwiftGen is to [add it as a Script Build Phase in your Xcode project](Xcode-Integration.md), so that your constants are always updated automatically if needed every time you build your project.

But some people don't like that (for example they don't want to risk adding compilation time… even if SwiftGen is optimized to be very fast and don't change the generated files if no changes has been made) and prefer to run SwiftGen manually in their terminal when the modify things.

If you're in that case, you could then be interested in making your Continuous Integration (CI) system check that the developers didn't forget to run SwiftGen to update their constants when they needed to.

Here is an example workflow using the *xcassets* features of SwiftGen:

1. The developer adds an image to (or removes one from) *Images.xcassets*
2. The developer runs `swiftgen` to regenerate the `ImageCatalog.swift` file (assuming they have the `xcassets` entry in their `swiftgen.yml` configuration file)
3. The developer commits his changes and pushes them to the remote server
4. The continuous integration tool runs the same `swiftgen` command. If the generated file changed, it means the developer forgot to do step 2 to update it after changing the *Images.xcassets* file. The CI would then be able to **return a failure** message to warn you that you forgot that step and force you to do it and re-commit.

---

For example if you're using CircleCI, your `circleci.yml` file could include steps like this:

```yaml
 steps:
   - run:
      name: Check if we forgot to run SwiftGen
      command: swiftgen && exit $(git status --porcelain DerivedSources/ImageCatalog.swift | wc -l)
```

This will run `swiftgen`, then use `git status` to check if the file changed after running swiftgen, and exit with 1 if the file has at least one change, aborting the build.
