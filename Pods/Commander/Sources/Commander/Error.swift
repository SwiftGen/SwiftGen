#if os(Linux)
  import Glibc
#else
  import Darwin
#endif


protocol ANSIConvertible : Error, CustomStringConvertible {
  var ansiDescription: String { get }
}


extension ANSIConvertible {
  func print() {
    // Check if we are in any term env and the output is a tty.
    if ANSI.isTerminalSupported {
      fputs("\(ansiDescription)\n", stderr)
    } else {
      fputs("\(description)\n", stderr)
    }
  }
}


enum ANSI: UInt8, CustomStringConvertible {
  case reset = 0

  case black = 30
  case red
  case green
  case yellow
  case blue
  case magenta
  case cyan
  case white
  case `default`

  var description: String {
    return "\u{001B}[\(self.rawValue)m"
  }

  static var isTerminalSupported: Bool {
    if let termType = getenv("TERM"), String(cString: termType).lowercased() != "dumb" &&
      isatty(fileno(stdout)) != 0 {
      return true
    } else {
      return false
    }
  }

  func print(_ string: String, to output: UnsafeMutablePointer<FILE> = stdout) {
    if ANSI.isTerminalSupported {
      fputs("\(self)\(string)\(ANSI.reset)\n", output)
    } else {
      fputs("\(string)\n", output)
    }
  }
}
