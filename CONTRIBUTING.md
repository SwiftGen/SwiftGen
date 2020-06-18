# Contributing Guidelines

This document contains information and guidelines about contributing to this project. Please read it before you start participating.

**Topics**

- [Asking Questions](#asking-questions)
- [Reporting Issues](#reporting-issues)
- [Creating Pull Requests](#creating-pull-requests)
- [Project Setup](#project-setup)

## Asking Questions

We don't use GitHub as a support forum. For any usage questions that are not specific to the project itself, please ask on [Stack Overflow](https://stackoverflow.com) instead. By doing so, you'll be more likely to quickly solve your problem, and you'll allow anyone else with the same question to find the answer. This also allows maintainers to focus on improving the project for others.

## Reporting Issues

A great way to contribute to the project is to send a detailed issue when you encounter a problem. We always appreciate a well-written, thorough bug reports.

When reporting issues, please include the following:

- The version of SwiftGen you're using (`swiftgen --version`)
- The version of Xcode you're using
- The version of iOS or macOS you're targeting
- The full output of any stack trace or compiler error
- A code snippet that reproduces the described behavior, if applicable
- Any other details that would be useful in understanding the problem

This information will help us review and fix your issue faster.

## Creating Pull Requests

Before you start developing new features and creating pull requests; *first* create an issue discussing these changes so that we can help you define the scope and implementation. Once discussed we can guide you through developing and creating the pull requests in the right repositories, in the right order, to ensure a smooth flow.

This is particularly necessary because the SwiftGen project is split up in multiple repositories, and some features might span multiple repositories.

### Requirements & Conventions

Each pull request will need to conform to some requirements, which should be automatically checked by our Danger bot. The main points are:

- Please check your indentation settings (2 spaces, no tabs). We're not forcing you to use a certain coding style, just trying to keep the code layout consistent.
- Ensure you've made a changelog entry, crediting yourself. Easiest if you just copy a previous entry to get the format right, if not, Danger bot will tell you.

### Following GitFlow branch naming convention

Your feature branches **should start from the `develop` branch**, not the `stable` branch.
_(The `stable` branch is reserved for released versions, while `develop` corresponds to the future version being worked on)_

Also, to help us triaging the branches, we use the following naming convention:

* Use `feature/xxx` (e.g. `feature/make-coffee`) for a non-breaking feature, which will not remove anything nor change the public API and won't require to bump to a major version
* Use `feature/breaking/xxx` (e.g. `feature/breaking/rename-context-keys`) for features that are breaking compatibility and will require us to bump the major version. (If you're not sure about that, just use `feature/xxx`)
* Use `fix/xxx` (e.g. `fix/crash-when-no-image`) to fix issues and errors

### Push Access to All Contributors

Once your Pull Request get merged, we'll be happy to give you push access to the SwiftGen repositories to thank you for your contribution and to help the project grow. For more information about that policy, see the [COMMUNITY.md](COMMUNITY.md) document.

## SwiftGen Project Organization

SwiftGen is actually structured as a GitHub organization containing various projects. The whole SwiftGen tool is built by assembling the various components of SwiftGen, hosted in their respective repositories in the organization.

Here's a recap of what each repository in the SwiftGen organization does:

### SwiftGen

This repository contains the following components:

#### swiftgen

The code for the command-line interface of SwiftGen.

It is the main target of the Xcode project, to build the MacOS command-line app which is only responsible for parsing its command-line arguments and then invoking the proper methods in the frameworks composing SwiftGen. This component also has a corresponding unit tests target, for testing configuration parsing.

If you need to add new command-line options and flags, that's the place to do it.

#### SwiftGenKit

The framework responsible for turning each kind of input resource (Asset Catalogs, Localizable strings files, Fonts, Storyboards…) into a structured dictionary — suitable to be used by Stencil. It is a separate target in the Xcode project, with it's own corresponding unit tests target (to test resource parsing and context generation).

If you want to add a new parser for a new type of resource, or fix a bug in the way some resources are parsed, or add new keys to the dictionary generated (and used as the context for your templates), that's the place to do so.

#### templates

Stored in it's dedicated folder, these are the templates bundled with SwiftGen on each new release (so that people have at least a set of sensible templates to use wthout having to create their own). This component also has a set of unit tests in the general project, to test the generation of source code from a given context.

### StencilSwiftKit

This repository contains the framework that enriches the `Stencil` template engine with some additional tags and filters that are useful when generating Swift code. This framework is actually used both by SwiftGen and [Sourcery](https://github.com/krzysztofzablocki/Sourcery).

You'll only make a PR on this repository if you need to add or fix filters or tags that are not part of Stencil.

If you want to fix or add templates, that's the place to do so. But you'll also need to do a Pull Request on that repo if you do some modifications to SwiftGenKit that would require new test fixtures or change the output of the unit tests.

### Eve

This repository does not contain any framework or app, but is rather the parent meta-repository to rule them all. It contains a bunch of scripts to make it easier to work in the SwiftGen ecosystem, allowing you to clone all the necessary SwiftGen repositories at once and make it easier to make them work properly between each other, like make sure they are in sync, etc.

It's unlikely you'll have to do a PR in this repository if you want to add features to SwiftGen, but you'll likely use this repository and its `Rakefile` to make a bunch of your contributor's life easier when working with all the SwiftGen repos at once.

## Project Setup

Before you can start developing a fix or a new feature in this project you'll need to be aware of how this project is structured, as described above.

Depending on the scope of the feature you want to develop, it might be easiest to checkout the [Eve repository](https://github.com/SwiftGen/Eve) and run `rake bootstrap` from there, which will checkout and initialize all repositories correctly and help you work inside the whole SwiftGen ecosystem.

### Requirements

First you need to make sure your machine fulfills the following requirements:

- You have [SwiftLint](https://github.com/realm/SwiftLint) installed – otherwise run `brew install swiftlint`. This will help you keep your code style consistent with the project's while contributing.
- For Core Contributors who plan to release new versions of SwiftGen, you'll also need:
  - To have [Homebrew](http://brew.sh) and [Bundler](https://bundler.io) installed
  - To install the project's tools dependencies by running `bundler install` from the project root directory

Unless you're adding (or updating) dependencies, you won't have to run `pod install` as all dependencies are already checked in to the repository.

### Building & Running

The Xcode workspace, by default, is configured to run SwiftGen built as an app bundle, with some default parameters. You can switch (and modify) these by going to `Product > Scheme > Edit Scheme... > Arguments`, and checking (and unchecking) the command you want to test.
