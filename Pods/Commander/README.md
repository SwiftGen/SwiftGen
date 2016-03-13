<img src="Commander.png" width=80 height=83 alt="Commander" />

# Commander

[![Build Status](https://img.shields.io/travis/kylef/Commander/master.svg?style=flat)](https://travis-ci.org/kylef/Commander)

Commander is a small Swift framework allowing you to craft beautiful command
line interfaces in a composable way.

## Usage

##### Simple Hello World

```swift
import Commander

let main = command {
  print("Hello World")
}

main.run()
```

##### Type-safe argument handling

The closure passed to the command function takes any arguments that
conform to `ArgumentConvertible`, Commander will automatically convert the
arguments to these types. If they can't be converted the user will receive a
nice error message informing them that their argument doesn't match the
expected type.

`String`, `Int`, `Double`, and `Float` are extended to conform to
`ArgumentConvertible`, you can easily extend any other class or structure
so you can use it as an argument to your command.

```swift
command { (hostname:String, port:Int) in
  print("Connecting to \(hostname) on port \(port)...")
}
```

##### Grouping commands

You can group a collection of commands together.

```swift
Group {
  $0.command("login") { (name:String) in
    print("Hello \(name)")
  }

  $0.command("logout") {
    print("Goodbye.")
  }
}
```

Usage:

```shell
$ auth
Usage:

    $ auth COMMAND

Commands:

    + login
    + logout

$ auth login Kyle
Hello Kyle
$ auth logout
Goodbye.
```

#### Describing arguments

You can describe arguments and options for a command to auto-generate help,
this is done by passing in descriptors of these arguments.

For example, to describe a command which takes two options, `--name` and
`--count` where the default value for name is `world` and the default value for
count is `1`.

```swift
command(
  Option("name", "world"),
  Option("count", 1, description: "The number of times to print.")
) { name, count in
  for _ in 0..<count {
    print("Hello \(name)")
  }
}
```

```shell
$ hello --help
Usage:

    $ hello

Options:
    --name
    --count - The number of times to print.

$ hello
Hello world

$ hello --name Kyle
Hello Kyle

$ hello --name Kyle --count 4
Hello Kyle
Hello Kyle
Hello Kyle
Hello Kyle
```

##### Types of descriptors

- Argument - A positional argument.
- Option - An optional option with a value.
- Flag - A boolean, on/off flag.
- VaradicArgument - A varadic argument

#### Using the argument parser

**NOTE**: *`ArgumentParser` itself is `ArgumentConvertible` so you can also
get hold of the raw argument parser to perform any custom parsing.*

```swift
command { (name:String, parser:ArgumentParser) in
  if parser.hasOption("verbose") {
    print("Verbose mode enabled")
  }

  print("Hello \(name)")
}
```

```shell
$ tool Kyle --verbose
Verbose mode enabled
Hello Kyle
```

### Examples tools using Commander

- [QueryKit](https://github.com/QueryKit/querykit-cli) via CocoaPods Rome

## Installation

You can install Commander in many ways, with SPM (Swift Package Manager), [Conche](https://github.com/Conche/Conche), CocoaPods or [CocoaPods-Rome](https://github.com/neonichu/Rome).

### Frameworks and `rpath`

It's important to note that the `.framework` or dynamic library file for
Commander (and any other dependency) must be available at run-time for your
command line tool. Unless you are using SPM.

Applications will look in their `rpath` which contains paths of where it expects
the `.framework`s to be found at.

Using a Swift script, you can use the `-F` flag for setting framework search
paths, as follows:

```swift
#!/usr/bin/env xcrun swift -F Rome

import Commander
```

For compiled Swift code, you will need to add an rpath pointing to your
dependency frameworks, as follows:

```shell
$ install_name_tool -add_rpath "@executable_path/../Frameworks/"  "bin/querykit"
```

Where "../Frameworks" relative to the executable path is used to find the
frameworks and `bin/querykit` is the executable.

When installing your executable on other systems it's important to copy the
frameworks and the binary.

### Architecture

##### `CommandType`

`CommandType` is the core protocol behind commands, it's an object or
structure that has a `run` method which takes an `ArgumentParser`.

Both the `command` functions and `Group` return a command that conforms to
`CommandType` which can easily be interchanged.

```swift
protocol CommandType {
  func run(parser:ArgumentParser) throws
}
```

##### `ArgumentConvertible`

The convenience `command` function takes a closure for your command that
takes arguments which conform to the `ArgumentConvertible` protocol. This
allows Commander to easily convert arguments to the types you would like
to use for your command.

```swift
protocol ArgumentConvertible {
  init(parser: ArgumentParser) throws
}
```

##### `ArgumentParser`

The `ArgumentParser` is an object that allowing you to pull out options,
flags and positional arguments.

## License

Commander is available under the BSD license. See the [LICENSE file](LICENSE)
for more info.
