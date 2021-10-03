//
// SwiftGen UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import SwiftGenCLI

public extension Config {
  var commandNames: Set<String> {
    Set(commands.map { $0.command.name })
  }

  func entries(for cmd: String) -> [ConfigEntry] {
    commands.filter { $0.command.name == cmd }.map { $0.entry }
  }
}
