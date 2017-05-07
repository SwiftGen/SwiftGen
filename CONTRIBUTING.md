# Contributing Guidelines

This document contains information and guidelines about contributing to this project. Please read it before you start participating.

**Topics**

- [Asking Questions](#asking-questions)
- [Reporting Issues](#reporting-issues)
- [Project Setup](#project-setup)

## Asking Questions

We don't use GitHub as a support forum. For any usage questions that are not specific to the project itself, please ask on [Stack Overflow](https://stackoverflow.com) instead. By doing so, you'll be more likely to quickly solve your problem, and you'll allow anyone else with the same question to find the answer. This also allows maintainers to focus on improving the project for others.

## Reporting Issues

A great way to contribute to the project is to send a detailed issue when you encounter a problem. We always appreciate a well-written, thorough bug reports.

When reporting issues, please include the following:

- The version of Xcode you're using
- The version of iOS or macOS you're targeting
- The full output of any stack trace or compiler error
- A code snippet that reproduces the described behavior, if applicable
- Any other details that would be useful in understanding the problem

This information will help us review and fix your issue faster.

## Project Setup

Before you can start developing a fix or a new feature in this project you need to be aware of how this project is structured. Especially since SwiftGen is a command line tool written in Swift some things need to be handled differently.

### Requirements

First you need to make sure your machine fulfills the following requirements:

- You have [Homebrew](http://brew.sh), [CocoaPods](https://cocoapods.org) and [xcpretty](https://github.com/supermarin/xcpretty) installed
- You have [SwiftLint](https://github.com/realm/SwiftLint) installed – otherwise run `brew install swiftlint`
- Install the dependencies by running `pod install` from the project root directory

Note that `pod install` should succeed with two warnings stating "[...] target overrides the `EMBEDDED_CONTENT_CONTAINS_SWIFT` build setting [...]". This warnings are due to the command line nature of SwiftGen and can be safely ignored.

### Building Correctly

SwiftGen doesn't have an app bundle wrapping the binary executable, frameworks and resources like regular macOS `.app` bundles, but instead builds a standalone binary executable. But being written in Swift, it needs to be linked against the Swift dynamic libraries (various `libswiftXXX.dylib` libraries) and also has other dependencies (like Stencil & Commander frameworks) that it needs to be linked against too.

All this means simply building the project won't result to such a binary like the one you receive when installing SwiftGen via Homebrew. Instead you need to run `rake install` from the projects root directory to build SwiftGen.

Please note that there is also a test target within the project which builds just fine despite the above mentioned problems.
