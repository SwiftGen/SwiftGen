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

Before you start developing new features and creating pull requests; *first* create an issue discussing these changes so that we can help you define the scope and implementation. Once discussed we can guide you through developing and creating the pull requests in the right repositories, in the right order, to ensure a smooth flow. This is particularly necessary because the SwiftGen project is split up in multiple repositories, and some features might span multiple repositories.

## Project Setup

Before you can start developing a fix or a new feature in this project you need to be aware of how this project is structured. Depending on the scope of the feature you want to develop, it might be easiest to checkout the [Eve repository](https://github.com/SwiftGen/Eve) and `bootstrap` it, which will checkout and initialize all repositories correctly.

### Requirements

First you need to make sure your machine fulfills the following requirements:

- You have [Homebrew](http://brew.sh) and [Bundler](https://bundler.io) installed
- You have [SwiftLint](https://github.com/realm/SwiftLint) installed – otherwise run `brew install swiftlint`
- Install the dependencies by running `bundler install` from the project root directory

Unless you're adding (or updating) dependencies, you won't have to run `pod install` as all dependencies are already checked in to the repository.

### Building & Running

The Xcode workspace, by default, is configured to run SwiftGen built as an app bundle, with some default parameters. You can switch (and modify) these by going to `Product > Scheme > Edit Scheme... > Arguments`, and checking (and unchecking) the command you want to test.
