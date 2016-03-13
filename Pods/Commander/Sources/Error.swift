#if os(Linux)
  import Glibc
#else
  import Darwin.libc
#endif


protocol ANSIConvertible : ErrorType, CustomStringConvertible {
  var ansiDescription: String { get }
}


extension ANSIConvertible {
  func print() {
    if isatty(fileno(stderr)) != 0 {
      fputs("\(ansiDescription)\n", stderr)
    } else {
      fputs("\(description)\n", stderr)
    }
  }
}


enum ANSI: UInt8, CustomStringConvertible {
  case Reset = 0

  case Black = 30
  case Red
  case Green
  case Yellow
  case Blue
  case Magenta
  case Cyan
  case White
  case Default

  var description: String {
    return "\u{001B}[\(self.rawValue)m"
  }
}
