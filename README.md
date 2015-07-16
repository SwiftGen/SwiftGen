# SwiftL10n

This is a tool to auto-generate Swift code from `Localizable.strings` files.

The tool will:

* Generate a Swift `enum` that will map all your `Localizable.strings` keys to an `enum case`
* Add associated values to that `enum case` if it detects that it contains `%@` or similar placeholders.
* You can then use that enum with the `tr` function to get the localized string associated with it.

```
tr(.AlertTitle) // "Some title for the alert"
L10n.AlertMessage.string // "Some alert message"
tr(.Greetings("John", 30)) // "I'm John and I'm 30"
```

## Example

Given this `Localizable.strings` file:

```
"alert_title" = "Title of the alert";
"alert_message" = "Some alert body there";
"greetings" = "Hello, my name is %@ and I'm %d";
"apples.count" = "You have %d apples";
"bananas.owner" = "Those %d bananas belong to %@.";
```

The generated code will contain this:

```
enum L10n {
	case AlertTitle
	case AlertMessage
	case Greetings(String, Int)
	case ApplesCount(Int)
	case BananasOwner(Int, String)
}

extension L10n : CustomStringConvertible {
	var description : String { return self.string }

	var string : String {
		/* Implementation Details */
	}
	...
}

func tr(key: L10n) -> String {
	return key.string
}
```


So you can use it this way in your Swift code:

```
let title = L10n.AlertTitle.string
// -> "Title of the Alert"

// Alternative syntax, shorter
let msg = tr(.AlertMessage)
// -> "Body of the Alert"

// Strings with parameters
let nbApples = tr(.ApplesCount(5))
// -> "You have 5 apples"

// More parameters of various types!
let ban = tr(.BananasOwner(2, "John"))
// -> "Those 2 bananas belong to John."
```

## Current State

The current code is written in Swift 2.0 in Xcode 7b3 (because I like it and that's the next thing anyway).

For now all this is done in a Playground that contains 2 pages:

* "Generator" contains the actual code that loads the "Localizable.strings" file located in the Resources of the playground, process it, and output the generated code in the console
* "Tests" contains some code to play with the target code we want to be generated and demonstrate how you would use it.

## Limitations

This is an early stage sample, for now only tested in a Playground. Next steps include:

* Transforming it into a stand-alone Swift script, runnable from the Command Line and that will take the input file as parameter
* Support more format placeholders, like `%x`, `%g`, etc
* Support positionable placeholders, like `%2$@`, etc (which change the order in which the parameters are parsed)
* Add some security during the parsing of placeholders, to avoid parsing too far in case we have an `%` that is not terminated by a known format type character
  * e.g. today `%x makes %g fail` will start parsing the placeholder from `%` and won't stop until it encounters `@`, `f` or `d` — the only types supported so far — which will only happen on `fail`, so it will consider `%x makes %g f` like it were `%f` altogether, skipping a parameter in the process.


## Licence

This code will be released under the MIT Licence.

Any ideas and contributions welcome!
