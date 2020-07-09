# Using SwiftLint to enfore the usage of SwiftGen in your codebase

If you want to generate warnings (or even errors) in your Xcode project if your developers accidentally use the string-based Apple APIs instead of the SwiftGen generated constants in your code, you can leverage [SwiftLint](https://github.com/Realm/SwiftLint) to do that for you.

SwiftLint allows you to add custom rules to your `.swiftlint.yml` config file, based on Regular Expressions.
You can use those to detect uses of things like `UIColor(red:green:blue:alpha:)` and suggest to use `Assets.xxx` instead, or detect uses of `NSLocalizedString` and suggest to replace them with the `L10n` generated constants, etc.

## Example configuration

Here's an example of custom rules you can add to your `.swiftlint.yml` SwiftLint configuration file:

```yaml
custom_rules:
  swiftgen_assets:
    name: "SwiftGen Assets"
    regex: '(UIImage|UIColor)(\.init)?\(named: ?"?.+"?(, ?in:.+?, ?compatibleWith:.+?)?\)|#imageLiteral\(resourceName: ?".+"\)'
    message: "Use Asset.<asset> instead"
    severity: error
  swiftgen_colors:
    name: "SwiftGen Colors"
    regex: '(UIColor(\.init)?|#colorLiteral)\(((red|displayP3Red):.+?,green:.+?,blue:.+?,alpha:.+?)|(white:.+?,alpha:.+?)|(hue:.+?,saturation:.+?,brightness:.+?,alpha:.+?)\)'
    message: "Use ColorName.<color> instead"
    severity: error
  swiftgen_fonts:
    name: "SwiftGen Fonts"
    regex: 'UIFont(\.init)?\(name: ?"?.+"?, ?size:.+?\)'
    message: "Use FontFamily.<family>.<variant>.size(<size>) instead"
    severity: error
  swiftgen_storyboards:
    name: "SwiftGen Storyboard Scenes"
    regex: '(UIStoryboard\(name: ?"?.+"?, ?bundle:.+\))|(instantiateViewController\(withIdentifier:.+?\))|(instantiateInitialViewController\(\))'
    message: "Use StoryboardScene.<storyboad>.<scene>.instantiate() instead"
    severity: error
  swiftgen_strings:
    name: "SwiftGen Strings"
    regex: 'NSLocalizedString'
    message: "Use L10n.key instead"
    severity: error
```

Feel free to use this and adapt to your needs, especially:

* This example makes SwiftLint generate _errors_ when it finds an usage of the Apple API where a SwiftGen constant should be used instead. Maybe you prefer to be less strict about it and use `severity: warning` rather than error in your project
* The `message` this example configuration displays mention the name of the `enums` generated that the user should use. If you've customized the name of such enum (typically with `params: { "enumName": "somethingElse" }` in your `swiftgen.yml` config file), you may want to adapt the messages reported by SwiftLint accordingly.

## Contribution

This example configuration is only an example/suggestion. It may not be perfect, we haven't tested _all_ the use cases, so maybe the regular expressions will have to be tuned/improved if you find a false positive or a use case that those didn't catch. If that's the case, don't hesitate to contribute by at least commenting on https://github.com/SwiftGen/SwiftGen/issues/446 to help us improve this!
