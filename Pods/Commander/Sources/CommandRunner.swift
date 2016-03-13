#if os(Linux)
  import Glibc
#else
  import Darwin.libc
#endif


/// Extensions to CommandType to provide convinience running methods for CLI tools
extension CommandType {
  /// Run the command using the `Process.argument`, removing the executable name
  @noreturn public func run(version:String? = nil) {
    let parser = ArgumentParser(arguments: Process.arguments)

    if parser.hasOption("version") && !parser.hasOption("help") {
      if let version = version {
        print(version)
        exit(0)
      }
    }

    let executableName = parser.shift()!  // Executable Name

    do {
      try run(parser)
    } catch let error as Help {
      let help = error.reraise("$ \(executableName)")
      help.print()
      exit(1)
    } catch GroupError.NoCommand(let path, let group) {
      var usage = "$ \(executableName)"
      if let path = path {
        usage += " \(path)"
      }
      let help = Help([], command: usage, group: group)
      help.print()
      exit(1)
    } catch let error as ANSIConvertible {
      error.print()
      exit(1)
    } catch let error as CustomStringConvertible {
      fputs("\(ANSI.Red)\(error.description)\(ANSI.Reset)\n", stderr)
      exit(1)
    } catch {
      fputs("\(ANSI.Red)Unknown error occurred.\(ANSI.Reset)\n", stderr)
      exit(1)
    }

    exit(0)
  }
}
