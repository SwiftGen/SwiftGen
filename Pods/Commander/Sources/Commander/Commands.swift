/// Automatically generated file from Examples/generator.swift

// MARK: Commands


/// Create a command which takes 1 argument using a closure
public func command<A:ArgumentConvertible>(_ closure: @escaping (A) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser))
  }
}

/// Create a command which takes 2 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible>(_ closure: @escaping (A, A1) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser))
  }
}

/// Create a command which takes 3 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible>(_ closure: @escaping (A, A1, A2) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser))
  }
}

/// Create a command which takes 4 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser))
  }
}

/// Create a command which takes 5 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser))
  }
}

/// Create a command which takes 6 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser))
  }
}

/// Create a command which takes 7 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser))
  }
}

/// Create a command which takes 8 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser))
  }
}

/// Create a command which takes 9 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser))
  }
}

/// Create a command which takes 10 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser))
  }
}

/// Create a command which takes 11 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser))
  }
}

/// Create a command which takes 12 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser))
  }
}

/// Create a command which takes 13 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser))
  }
}

/// Create a command which takes 14 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser))
  }
}

/// Create a command which takes 15 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser), try A14(parser: parser))
  }
}

/// Create a command which takes 16 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser), try A14(parser: parser), try A15(parser: parser))
  }
}

/// Create a command which takes 17 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser), try A14(parser: parser), try A15(parser: parser), try A16(parser: parser))
  }
}

/// Create a command which takes 18 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser), try A14(parser: parser), try A15(parser: parser), try A16(parser: parser), try A17(parser: parser))
  }
}

/// Create a command which takes 19 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser), try A14(parser: parser), try A15(parser: parser), try A16(parser: parser), try A17(parser: parser), try A18(parser: parser))
  }
}

/// Create a command which takes 20 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser), try A14(parser: parser), try A15(parser: parser), try A16(parser: parser), try A17(parser: parser), try A18(parser: parser), try A19(parser: parser))
  }
}

/// Create a command which takes 21 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser), try A14(parser: parser), try A15(parser: parser), try A16(parser: parser), try A17(parser: parser), try A18(parser: parser), try A19(parser: parser), try A20(parser: parser))
  }
}

/// Create a command which takes 22 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser), try A14(parser: parser), try A15(parser: parser), try A16(parser: parser), try A17(parser: parser), try A18(parser: parser), try A19(parser: parser), try A20(parser: parser), try A21(parser: parser))
  }
}

/// Create a command which takes 23 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser), try A14(parser: parser), try A15(parser: parser), try A16(parser: parser), try A17(parser: parser), try A18(parser: parser), try A19(parser: parser), try A20(parser: parser), try A21(parser: parser), try A22(parser: parser))
  }
}

/// Create a command which takes 24 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible, A23:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser), try A14(parser: parser), try A15(parser: parser), try A16(parser: parser), try A17(parser: parser), try A18(parser: parser), try A19(parser: parser), try A20(parser: parser), try A21(parser: parser), try A22(parser: parser), try A23(parser: parser))
  }
}

/// Create a command which takes 25 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible, A23:ArgumentConvertible, A24:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser), try A14(parser: parser), try A15(parser: parser), try A16(parser: parser), try A17(parser: parser), try A18(parser: parser), try A19(parser: parser), try A20(parser: parser), try A21(parser: parser), try A22(parser: parser), try A23(parser: parser), try A24(parser: parser))
  }
}

/// Create a command which takes 26 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible, A23:ArgumentConvertible, A24:ArgumentConvertible, A25:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser), try A14(parser: parser), try A15(parser: parser), try A16(parser: parser), try A17(parser: parser), try A18(parser: parser), try A19(parser: parser), try A20(parser: parser), try A21(parser: parser), try A22(parser: parser), try A23(parser: parser), try A24(parser: parser), try A25(parser: parser))
  }
}

/// Create a command which takes 27 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible, A23:ArgumentConvertible, A24:ArgumentConvertible, A25:ArgumentConvertible, A26:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser), try A14(parser: parser), try A15(parser: parser), try A16(parser: parser), try A17(parser: parser), try A18(parser: parser), try A19(parser: parser), try A20(parser: parser), try A21(parser: parser), try A22(parser: parser), try A23(parser: parser), try A24(parser: parser), try A25(parser: parser), try A26(parser: parser))
  }
}

/// Create a command which takes 28 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible, A23:ArgumentConvertible, A24:ArgumentConvertible, A25:ArgumentConvertible, A26:ArgumentConvertible, A27:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser), try A14(parser: parser), try A15(parser: parser), try A16(parser: parser), try A17(parser: parser), try A18(parser: parser), try A19(parser: parser), try A20(parser: parser), try A21(parser: parser), try A22(parser: parser), try A23(parser: parser), try A24(parser: parser), try A25(parser: parser), try A26(parser: parser), try A27(parser: parser))
  }
}

/// Create a command which takes 29 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible, A23:ArgumentConvertible, A24:ArgumentConvertible, A25:ArgumentConvertible, A26:ArgumentConvertible, A27:ArgumentConvertible, A28:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser), try A14(parser: parser), try A15(parser: parser), try A16(parser: parser), try A17(parser: parser), try A18(parser: parser), try A19(parser: parser), try A20(parser: parser), try A21(parser: parser), try A22(parser: parser), try A23(parser: parser), try A24(parser: parser), try A25(parser: parser), try A26(parser: parser), try A27(parser: parser), try A28(parser: parser))
  }
}

/// Create a command which takes 30 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible, A23:ArgumentConvertible, A24:ArgumentConvertible, A25:ArgumentConvertible, A26:ArgumentConvertible, A27:ArgumentConvertible, A28:ArgumentConvertible, A29:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser), try A14(parser: parser), try A15(parser: parser), try A16(parser: parser), try A17(parser: parser), try A18(parser: parser), try A19(parser: parser), try A20(parser: parser), try A21(parser: parser), try A22(parser: parser), try A23(parser: parser), try A24(parser: parser), try A25(parser: parser), try A26(parser: parser), try A27(parser: parser), try A28(parser: parser), try A29(parser: parser))
  }
}

/// Create a command which takes 31 argument using a closure
public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible, A23:ArgumentConvertible, A24:ArgumentConvertible, A25:ArgumentConvertible, A26:ArgumentConvertible, A27:ArgumentConvertible, A28:ArgumentConvertible, A29:ArgumentConvertible, A30:ArgumentConvertible>(_ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29, A30) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser), try A14(parser: parser), try A15(parser: parser), try A16(parser: parser), try A17(parser: parser), try A18(parser: parser), try A19(parser: parser), try A20(parser: parser), try A21(parser: parser), try A22(parser: parser), try A23(parser: parser), try A24(parser: parser), try A25(parser: parser), try A26(parser: parser), try A27(parser: parser), try A28(parser: parser), try A29(parser: parser), try A30(parser: parser))
  }
}


// MARK: Argument Descriptor Commands


/// Create a command which takes 1 argument using a closure with arguments
public func command<A:ArgumentDescriptor>(_ descriptor:A, _ closure: @escaping (A.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0)
  }
}

/// Create a command which takes 2 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ closure: @escaping (A.ValueType, A1.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1)
  }
}

/// Create a command which takes 3 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2)
  }
}

/// Create a command which takes 4 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3)
  }
}

/// Create a command which takes 5 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4)
  }
}

/// Create a command which takes 6 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5)
  }
}

/// Create a command which takes 7 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6)
  }
}

/// Create a command which takes 8 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7)
  }
}

/// Create a command which takes 9 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8)
  }
}

/// Create a command which takes 10 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9)
  }
}

/// Create a command which takes 11 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)
  }
}

/// Create a command which takes 12 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11)
  }
}

/// Create a command which takes 13 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12)
  }
}

/// Create a command which takes 14 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13)
  }
}

/// Create a command which takes 15 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ descriptor14:A14, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
        BoxedArgumentDescriptor(value: descriptor14),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)
    let value14 = try descriptor14.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14)
  }
}

/// Create a command which takes 16 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ descriptor14:A14, _ descriptor15:A15, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
        BoxedArgumentDescriptor(value: descriptor14),
        BoxedArgumentDescriptor(value: descriptor15),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)
    let value14 = try descriptor14.parse(parser)
    let value15 = try descriptor15.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15)
  }
}

/// Create a command which takes 17 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ descriptor14:A14, _ descriptor15:A15, _ descriptor16:A16, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
        BoxedArgumentDescriptor(value: descriptor14),
        BoxedArgumentDescriptor(value: descriptor15),
        BoxedArgumentDescriptor(value: descriptor16),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)
    let value14 = try descriptor14.parse(parser)
    let value15 = try descriptor15.parse(parser)
    let value16 = try descriptor16.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15, value16)
  }
}

/// Create a command which takes 18 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ descriptor14:A14, _ descriptor15:A15, _ descriptor16:A16, _ descriptor17:A17, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
        BoxedArgumentDescriptor(value: descriptor14),
        BoxedArgumentDescriptor(value: descriptor15),
        BoxedArgumentDescriptor(value: descriptor16),
        BoxedArgumentDescriptor(value: descriptor17),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)
    let value14 = try descriptor14.parse(parser)
    let value15 = try descriptor15.parse(parser)
    let value16 = try descriptor16.parse(parser)
    let value17 = try descriptor17.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15, value16, value17)
  }
}

/// Create a command which takes 19 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ descriptor14:A14, _ descriptor15:A15, _ descriptor16:A16, _ descriptor17:A17, _ descriptor18:A18, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
        BoxedArgumentDescriptor(value: descriptor14),
        BoxedArgumentDescriptor(value: descriptor15),
        BoxedArgumentDescriptor(value: descriptor16),
        BoxedArgumentDescriptor(value: descriptor17),
        BoxedArgumentDescriptor(value: descriptor18),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)
    let value14 = try descriptor14.parse(parser)
    let value15 = try descriptor15.parse(parser)
    let value16 = try descriptor16.parse(parser)
    let value17 = try descriptor17.parse(parser)
    let value18 = try descriptor18.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15, value16, value17, value18)
  }
}

/// Create a command which takes 20 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ descriptor14:A14, _ descriptor15:A15, _ descriptor16:A16, _ descriptor17:A17, _ descriptor18:A18, _ descriptor19:A19, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
        BoxedArgumentDescriptor(value: descriptor14),
        BoxedArgumentDescriptor(value: descriptor15),
        BoxedArgumentDescriptor(value: descriptor16),
        BoxedArgumentDescriptor(value: descriptor17),
        BoxedArgumentDescriptor(value: descriptor18),
        BoxedArgumentDescriptor(value: descriptor19),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)
    let value14 = try descriptor14.parse(parser)
    let value15 = try descriptor15.parse(parser)
    let value16 = try descriptor16.parse(parser)
    let value17 = try descriptor17.parse(parser)
    let value18 = try descriptor18.parse(parser)
    let value19 = try descriptor19.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15, value16, value17, value18, value19)
  }
}

/// Create a command which takes 21 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ descriptor14:A14, _ descriptor15:A15, _ descriptor16:A16, _ descriptor17:A17, _ descriptor18:A18, _ descriptor19:A19, _ descriptor20:A20, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
        BoxedArgumentDescriptor(value: descriptor14),
        BoxedArgumentDescriptor(value: descriptor15),
        BoxedArgumentDescriptor(value: descriptor16),
        BoxedArgumentDescriptor(value: descriptor17),
        BoxedArgumentDescriptor(value: descriptor18),
        BoxedArgumentDescriptor(value: descriptor19),
        BoxedArgumentDescriptor(value: descriptor20),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)
    let value14 = try descriptor14.parse(parser)
    let value15 = try descriptor15.parse(parser)
    let value16 = try descriptor16.parse(parser)
    let value17 = try descriptor17.parse(parser)
    let value18 = try descriptor18.parse(parser)
    let value19 = try descriptor19.parse(parser)
    let value20 = try descriptor20.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15, value16, value17, value18, value19, value20)
  }
}

/// Create a command which takes 22 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ descriptor14:A14, _ descriptor15:A15, _ descriptor16:A16, _ descriptor17:A17, _ descriptor18:A18, _ descriptor19:A19, _ descriptor20:A20, _ descriptor21:A21, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
        BoxedArgumentDescriptor(value: descriptor14),
        BoxedArgumentDescriptor(value: descriptor15),
        BoxedArgumentDescriptor(value: descriptor16),
        BoxedArgumentDescriptor(value: descriptor17),
        BoxedArgumentDescriptor(value: descriptor18),
        BoxedArgumentDescriptor(value: descriptor19),
        BoxedArgumentDescriptor(value: descriptor20),
        BoxedArgumentDescriptor(value: descriptor21),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)
    let value14 = try descriptor14.parse(parser)
    let value15 = try descriptor15.parse(parser)
    let value16 = try descriptor16.parse(parser)
    let value17 = try descriptor17.parse(parser)
    let value18 = try descriptor18.parse(parser)
    let value19 = try descriptor19.parse(parser)
    let value20 = try descriptor20.parse(parser)
    let value21 = try descriptor21.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15, value16, value17, value18, value19, value20, value21)
  }
}

/// Create a command which takes 23 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ descriptor14:A14, _ descriptor15:A15, _ descriptor16:A16, _ descriptor17:A17, _ descriptor18:A18, _ descriptor19:A19, _ descriptor20:A20, _ descriptor21:A21, _ descriptor22:A22, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
        BoxedArgumentDescriptor(value: descriptor14),
        BoxedArgumentDescriptor(value: descriptor15),
        BoxedArgumentDescriptor(value: descriptor16),
        BoxedArgumentDescriptor(value: descriptor17),
        BoxedArgumentDescriptor(value: descriptor18),
        BoxedArgumentDescriptor(value: descriptor19),
        BoxedArgumentDescriptor(value: descriptor20),
        BoxedArgumentDescriptor(value: descriptor21),
        BoxedArgumentDescriptor(value: descriptor22),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)
    let value14 = try descriptor14.parse(parser)
    let value15 = try descriptor15.parse(parser)
    let value16 = try descriptor16.parse(parser)
    let value17 = try descriptor17.parse(parser)
    let value18 = try descriptor18.parse(parser)
    let value19 = try descriptor19.parse(parser)
    let value20 = try descriptor20.parse(parser)
    let value21 = try descriptor21.parse(parser)
    let value22 = try descriptor22.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15, value16, value17, value18, value19, value20, value21, value22)
  }
}

/// Create a command which takes 24 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor, A23:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ descriptor14:A14, _ descriptor15:A15, _ descriptor16:A16, _ descriptor17:A17, _ descriptor18:A18, _ descriptor19:A19, _ descriptor20:A20, _ descriptor21:A21, _ descriptor22:A22, _ descriptor23:A23, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType, A23.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
        BoxedArgumentDescriptor(value: descriptor14),
        BoxedArgumentDescriptor(value: descriptor15),
        BoxedArgumentDescriptor(value: descriptor16),
        BoxedArgumentDescriptor(value: descriptor17),
        BoxedArgumentDescriptor(value: descriptor18),
        BoxedArgumentDescriptor(value: descriptor19),
        BoxedArgumentDescriptor(value: descriptor20),
        BoxedArgumentDescriptor(value: descriptor21),
        BoxedArgumentDescriptor(value: descriptor22),
        BoxedArgumentDescriptor(value: descriptor23),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)
    let value14 = try descriptor14.parse(parser)
    let value15 = try descriptor15.parse(parser)
    let value16 = try descriptor16.parse(parser)
    let value17 = try descriptor17.parse(parser)
    let value18 = try descriptor18.parse(parser)
    let value19 = try descriptor19.parse(parser)
    let value20 = try descriptor20.parse(parser)
    let value21 = try descriptor21.parse(parser)
    let value22 = try descriptor22.parse(parser)
    let value23 = try descriptor23.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15, value16, value17, value18, value19, value20, value21, value22, value23)
  }
}

/// Create a command which takes 25 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor, A23:ArgumentDescriptor, A24:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ descriptor14:A14, _ descriptor15:A15, _ descriptor16:A16, _ descriptor17:A17, _ descriptor18:A18, _ descriptor19:A19, _ descriptor20:A20, _ descriptor21:A21, _ descriptor22:A22, _ descriptor23:A23, _ descriptor24:A24, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType, A23.ValueType, A24.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
        BoxedArgumentDescriptor(value: descriptor14),
        BoxedArgumentDescriptor(value: descriptor15),
        BoxedArgumentDescriptor(value: descriptor16),
        BoxedArgumentDescriptor(value: descriptor17),
        BoxedArgumentDescriptor(value: descriptor18),
        BoxedArgumentDescriptor(value: descriptor19),
        BoxedArgumentDescriptor(value: descriptor20),
        BoxedArgumentDescriptor(value: descriptor21),
        BoxedArgumentDescriptor(value: descriptor22),
        BoxedArgumentDescriptor(value: descriptor23),
        BoxedArgumentDescriptor(value: descriptor24),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)
    let value14 = try descriptor14.parse(parser)
    let value15 = try descriptor15.parse(parser)
    let value16 = try descriptor16.parse(parser)
    let value17 = try descriptor17.parse(parser)
    let value18 = try descriptor18.parse(parser)
    let value19 = try descriptor19.parse(parser)
    let value20 = try descriptor20.parse(parser)
    let value21 = try descriptor21.parse(parser)
    let value22 = try descriptor22.parse(parser)
    let value23 = try descriptor23.parse(parser)
    let value24 = try descriptor24.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15, value16, value17, value18, value19, value20, value21, value22, value23, value24)
  }
}

/// Create a command which takes 26 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor, A23:ArgumentDescriptor, A24:ArgumentDescriptor, A25:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ descriptor14:A14, _ descriptor15:A15, _ descriptor16:A16, _ descriptor17:A17, _ descriptor18:A18, _ descriptor19:A19, _ descriptor20:A20, _ descriptor21:A21, _ descriptor22:A22, _ descriptor23:A23, _ descriptor24:A24, _ descriptor25:A25, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType, A23.ValueType, A24.ValueType, A25.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
        BoxedArgumentDescriptor(value: descriptor14),
        BoxedArgumentDescriptor(value: descriptor15),
        BoxedArgumentDescriptor(value: descriptor16),
        BoxedArgumentDescriptor(value: descriptor17),
        BoxedArgumentDescriptor(value: descriptor18),
        BoxedArgumentDescriptor(value: descriptor19),
        BoxedArgumentDescriptor(value: descriptor20),
        BoxedArgumentDescriptor(value: descriptor21),
        BoxedArgumentDescriptor(value: descriptor22),
        BoxedArgumentDescriptor(value: descriptor23),
        BoxedArgumentDescriptor(value: descriptor24),
        BoxedArgumentDescriptor(value: descriptor25),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)
    let value14 = try descriptor14.parse(parser)
    let value15 = try descriptor15.parse(parser)
    let value16 = try descriptor16.parse(parser)
    let value17 = try descriptor17.parse(parser)
    let value18 = try descriptor18.parse(parser)
    let value19 = try descriptor19.parse(parser)
    let value20 = try descriptor20.parse(parser)
    let value21 = try descriptor21.parse(parser)
    let value22 = try descriptor22.parse(parser)
    let value23 = try descriptor23.parse(parser)
    let value24 = try descriptor24.parse(parser)
    let value25 = try descriptor25.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15, value16, value17, value18, value19, value20, value21, value22, value23, value24, value25)
  }
}

/// Create a command which takes 27 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor, A23:ArgumentDescriptor, A24:ArgumentDescriptor, A25:ArgumentDescriptor, A26:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ descriptor14:A14, _ descriptor15:A15, _ descriptor16:A16, _ descriptor17:A17, _ descriptor18:A18, _ descriptor19:A19, _ descriptor20:A20, _ descriptor21:A21, _ descriptor22:A22, _ descriptor23:A23, _ descriptor24:A24, _ descriptor25:A25, _ descriptor26:A26, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType, A23.ValueType, A24.ValueType, A25.ValueType, A26.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
        BoxedArgumentDescriptor(value: descriptor14),
        BoxedArgumentDescriptor(value: descriptor15),
        BoxedArgumentDescriptor(value: descriptor16),
        BoxedArgumentDescriptor(value: descriptor17),
        BoxedArgumentDescriptor(value: descriptor18),
        BoxedArgumentDescriptor(value: descriptor19),
        BoxedArgumentDescriptor(value: descriptor20),
        BoxedArgumentDescriptor(value: descriptor21),
        BoxedArgumentDescriptor(value: descriptor22),
        BoxedArgumentDescriptor(value: descriptor23),
        BoxedArgumentDescriptor(value: descriptor24),
        BoxedArgumentDescriptor(value: descriptor25),
        BoxedArgumentDescriptor(value: descriptor26),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)
    let value14 = try descriptor14.parse(parser)
    let value15 = try descriptor15.parse(parser)
    let value16 = try descriptor16.parse(parser)
    let value17 = try descriptor17.parse(parser)
    let value18 = try descriptor18.parse(parser)
    let value19 = try descriptor19.parse(parser)
    let value20 = try descriptor20.parse(parser)
    let value21 = try descriptor21.parse(parser)
    let value22 = try descriptor22.parse(parser)
    let value23 = try descriptor23.parse(parser)
    let value24 = try descriptor24.parse(parser)
    let value25 = try descriptor25.parse(parser)
    let value26 = try descriptor26.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15, value16, value17, value18, value19, value20, value21, value22, value23, value24, value25, value26)
  }
}

/// Create a command which takes 28 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor, A23:ArgumentDescriptor, A24:ArgumentDescriptor, A25:ArgumentDescriptor, A26:ArgumentDescriptor, A27:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ descriptor14:A14, _ descriptor15:A15, _ descriptor16:A16, _ descriptor17:A17, _ descriptor18:A18, _ descriptor19:A19, _ descriptor20:A20, _ descriptor21:A21, _ descriptor22:A22, _ descriptor23:A23, _ descriptor24:A24, _ descriptor25:A25, _ descriptor26:A26, _ descriptor27:A27, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType, A23.ValueType, A24.ValueType, A25.ValueType, A26.ValueType, A27.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
        BoxedArgumentDescriptor(value: descriptor14),
        BoxedArgumentDescriptor(value: descriptor15),
        BoxedArgumentDescriptor(value: descriptor16),
        BoxedArgumentDescriptor(value: descriptor17),
        BoxedArgumentDescriptor(value: descriptor18),
        BoxedArgumentDescriptor(value: descriptor19),
        BoxedArgumentDescriptor(value: descriptor20),
        BoxedArgumentDescriptor(value: descriptor21),
        BoxedArgumentDescriptor(value: descriptor22),
        BoxedArgumentDescriptor(value: descriptor23),
        BoxedArgumentDescriptor(value: descriptor24),
        BoxedArgumentDescriptor(value: descriptor25),
        BoxedArgumentDescriptor(value: descriptor26),
        BoxedArgumentDescriptor(value: descriptor27),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)
    let value14 = try descriptor14.parse(parser)
    let value15 = try descriptor15.parse(parser)
    let value16 = try descriptor16.parse(parser)
    let value17 = try descriptor17.parse(parser)
    let value18 = try descriptor18.parse(parser)
    let value19 = try descriptor19.parse(parser)
    let value20 = try descriptor20.parse(parser)
    let value21 = try descriptor21.parse(parser)
    let value22 = try descriptor22.parse(parser)
    let value23 = try descriptor23.parse(parser)
    let value24 = try descriptor24.parse(parser)
    let value25 = try descriptor25.parse(parser)
    let value26 = try descriptor26.parse(parser)
    let value27 = try descriptor27.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15, value16, value17, value18, value19, value20, value21, value22, value23, value24, value25, value26, value27)
  }
}

/// Create a command which takes 29 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor, A23:ArgumentDescriptor, A24:ArgumentDescriptor, A25:ArgumentDescriptor, A26:ArgumentDescriptor, A27:ArgumentDescriptor, A28:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ descriptor14:A14, _ descriptor15:A15, _ descriptor16:A16, _ descriptor17:A17, _ descriptor18:A18, _ descriptor19:A19, _ descriptor20:A20, _ descriptor21:A21, _ descriptor22:A22, _ descriptor23:A23, _ descriptor24:A24, _ descriptor25:A25, _ descriptor26:A26, _ descriptor27:A27, _ descriptor28:A28, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType, A23.ValueType, A24.ValueType, A25.ValueType, A26.ValueType, A27.ValueType, A28.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
        BoxedArgumentDescriptor(value: descriptor14),
        BoxedArgumentDescriptor(value: descriptor15),
        BoxedArgumentDescriptor(value: descriptor16),
        BoxedArgumentDescriptor(value: descriptor17),
        BoxedArgumentDescriptor(value: descriptor18),
        BoxedArgumentDescriptor(value: descriptor19),
        BoxedArgumentDescriptor(value: descriptor20),
        BoxedArgumentDescriptor(value: descriptor21),
        BoxedArgumentDescriptor(value: descriptor22),
        BoxedArgumentDescriptor(value: descriptor23),
        BoxedArgumentDescriptor(value: descriptor24),
        BoxedArgumentDescriptor(value: descriptor25),
        BoxedArgumentDescriptor(value: descriptor26),
        BoxedArgumentDescriptor(value: descriptor27),
        BoxedArgumentDescriptor(value: descriptor28),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)
    let value14 = try descriptor14.parse(parser)
    let value15 = try descriptor15.parse(parser)
    let value16 = try descriptor16.parse(parser)
    let value17 = try descriptor17.parse(parser)
    let value18 = try descriptor18.parse(parser)
    let value19 = try descriptor19.parse(parser)
    let value20 = try descriptor20.parse(parser)
    let value21 = try descriptor21.parse(parser)
    let value22 = try descriptor22.parse(parser)
    let value23 = try descriptor23.parse(parser)
    let value24 = try descriptor24.parse(parser)
    let value25 = try descriptor25.parse(parser)
    let value26 = try descriptor26.parse(parser)
    let value27 = try descriptor27.parse(parser)
    let value28 = try descriptor28.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15, value16, value17, value18, value19, value20, value21, value22, value23, value24, value25, value26, value27, value28)
  }
}

/// Create a command which takes 30 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor, A23:ArgumentDescriptor, A24:ArgumentDescriptor, A25:ArgumentDescriptor, A26:ArgumentDescriptor, A27:ArgumentDescriptor, A28:ArgumentDescriptor, A29:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ descriptor14:A14, _ descriptor15:A15, _ descriptor16:A16, _ descriptor17:A17, _ descriptor18:A18, _ descriptor19:A19, _ descriptor20:A20, _ descriptor21:A21, _ descriptor22:A22, _ descriptor23:A23, _ descriptor24:A24, _ descriptor25:A25, _ descriptor26:A26, _ descriptor27:A27, _ descriptor28:A28, _ descriptor29:A29, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType, A23.ValueType, A24.ValueType, A25.ValueType, A26.ValueType, A27.ValueType, A28.ValueType, A29.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
        BoxedArgumentDescriptor(value: descriptor14),
        BoxedArgumentDescriptor(value: descriptor15),
        BoxedArgumentDescriptor(value: descriptor16),
        BoxedArgumentDescriptor(value: descriptor17),
        BoxedArgumentDescriptor(value: descriptor18),
        BoxedArgumentDescriptor(value: descriptor19),
        BoxedArgumentDescriptor(value: descriptor20),
        BoxedArgumentDescriptor(value: descriptor21),
        BoxedArgumentDescriptor(value: descriptor22),
        BoxedArgumentDescriptor(value: descriptor23),
        BoxedArgumentDescriptor(value: descriptor24),
        BoxedArgumentDescriptor(value: descriptor25),
        BoxedArgumentDescriptor(value: descriptor26),
        BoxedArgumentDescriptor(value: descriptor27),
        BoxedArgumentDescriptor(value: descriptor28),
        BoxedArgumentDescriptor(value: descriptor29),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)
    let value14 = try descriptor14.parse(parser)
    let value15 = try descriptor15.parse(parser)
    let value16 = try descriptor16.parse(parser)
    let value17 = try descriptor17.parse(parser)
    let value18 = try descriptor18.parse(parser)
    let value19 = try descriptor19.parse(parser)
    let value20 = try descriptor20.parse(parser)
    let value21 = try descriptor21.parse(parser)
    let value22 = try descriptor22.parse(parser)
    let value23 = try descriptor23.parse(parser)
    let value24 = try descriptor24.parse(parser)
    let value25 = try descriptor25.parse(parser)
    let value26 = try descriptor26.parse(parser)
    let value27 = try descriptor27.parse(parser)
    let value28 = try descriptor28.parse(parser)
    let value29 = try descriptor29.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15, value16, value17, value18, value19, value20, value21, value22, value23, value24, value25, value26, value27, value28, value29)
  }
}

/// Create a command which takes 31 argument using a closure with arguments
public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor, A23:ArgumentDescriptor, A24:ArgumentDescriptor, A25:ArgumentDescriptor, A26:ArgumentDescriptor, A27:ArgumentDescriptor, A28:ArgumentDescriptor, A29:ArgumentDescriptor, A30:ArgumentDescriptor>(_ descriptor:A, _ descriptor1:A1, _ descriptor2:A2, _ descriptor3:A3, _ descriptor4:A4, _ descriptor5:A5, _ descriptor6:A6, _ descriptor7:A7, _ descriptor8:A8, _ descriptor9:A9, _ descriptor10:A10, _ descriptor11:A11, _ descriptor12:A12, _ descriptor13:A13, _ descriptor14:A14, _ descriptor15:A15, _ descriptor16:A16, _ descriptor17:A17, _ descriptor18:A18, _ descriptor19:A19, _ descriptor20:A20, _ descriptor21:A21, _ descriptor22:A22, _ descriptor23:A23, _ descriptor24:A24, _ descriptor25:A25, _ descriptor26:A26, _ descriptor27:A27, _ descriptor28:A28, _ descriptor29:A29, _ descriptor30:A30, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType, A23.ValueType, A24.ValueType, A25.ValueType, A26.ValueType, A27.ValueType, A28.ValueType, A29.ValueType, A30.ValueType) throws -> ()) -> CommandType {
  return AnonymousCommand { parser in
    let help = Help([
        BoxedArgumentDescriptor(value: descriptor),
        BoxedArgumentDescriptor(value: descriptor1),
        BoxedArgumentDescriptor(value: descriptor2),
        BoxedArgumentDescriptor(value: descriptor3),
        BoxedArgumentDescriptor(value: descriptor4),
        BoxedArgumentDescriptor(value: descriptor5),
        BoxedArgumentDescriptor(value: descriptor6),
        BoxedArgumentDescriptor(value: descriptor7),
        BoxedArgumentDescriptor(value: descriptor8),
        BoxedArgumentDescriptor(value: descriptor9),
        BoxedArgumentDescriptor(value: descriptor10),
        BoxedArgumentDescriptor(value: descriptor11),
        BoxedArgumentDescriptor(value: descriptor12),
        BoxedArgumentDescriptor(value: descriptor13),
        BoxedArgumentDescriptor(value: descriptor14),
        BoxedArgumentDescriptor(value: descriptor15),
        BoxedArgumentDescriptor(value: descriptor16),
        BoxedArgumentDescriptor(value: descriptor17),
        BoxedArgumentDescriptor(value: descriptor18),
        BoxedArgumentDescriptor(value: descriptor19),
        BoxedArgumentDescriptor(value: descriptor20),
        BoxedArgumentDescriptor(value: descriptor21),
        BoxedArgumentDescriptor(value: descriptor22),
        BoxedArgumentDescriptor(value: descriptor23),
        BoxedArgumentDescriptor(value: descriptor24),
        BoxedArgumentDescriptor(value: descriptor25),
        BoxedArgumentDescriptor(value: descriptor26),
        BoxedArgumentDescriptor(value: descriptor27),
        BoxedArgumentDescriptor(value: descriptor28),
        BoxedArgumentDescriptor(value: descriptor29),
        BoxedArgumentDescriptor(value: descriptor30),
    ])

    if parser.hasOption("help") {
      throw help
    }

    let value0 = try descriptor.parse(parser)
    let value1 = try descriptor1.parse(parser)
    let value2 = try descriptor2.parse(parser)
    let value3 = try descriptor3.parse(parser)
    let value4 = try descriptor4.parse(parser)
    let value5 = try descriptor5.parse(parser)
    let value6 = try descriptor6.parse(parser)
    let value7 = try descriptor7.parse(parser)
    let value8 = try descriptor8.parse(parser)
    let value9 = try descriptor9.parse(parser)
    let value10 = try descriptor10.parse(parser)
    let value11 = try descriptor11.parse(parser)
    let value12 = try descriptor12.parse(parser)
    let value13 = try descriptor13.parse(parser)
    let value14 = try descriptor14.parse(parser)
    let value15 = try descriptor15.parse(parser)
    let value16 = try descriptor16.parse(parser)
    let value17 = try descriptor17.parse(parser)
    let value18 = try descriptor18.parse(parser)
    let value19 = try descriptor19.parse(parser)
    let value20 = try descriptor20.parse(parser)
    let value21 = try descriptor21.parse(parser)
    let value22 = try descriptor22.parse(parser)
    let value23 = try descriptor23.parse(parser)
    let value24 = try descriptor24.parse(parser)
    let value25 = try descriptor25.parse(parser)
    let value26 = try descriptor26.parse(parser)
    let value27 = try descriptor27.parse(parser)
    let value28 = try descriptor28.parse(parser)
    let value29 = try descriptor29.parse(parser)
    let value30 = try descriptor30.parse(parser)

    if !parser.isEmpty {
      throw UsageError("Unknown Arguments: \(parser)", help)
    }

    try closure(value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15, value16, value17, value18, value19, value20, value21, value22, value23, value24, value25, value26, value27, value28, value29, value30)
  }
}


// MARK: Group commands

extension Group {
  // MARK: Argument Description Commands

  /// Add a command which takes no argument using a closure
  public func command(_ name:String, description:String? = nil, _ closure: @escaping () throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 1 arguments using a closure
  public func command<A:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 2 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 3 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 4 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 5 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 6 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 7 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 8 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 9 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 10 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 11 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 12 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 13 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 14 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 15 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 16 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 17 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 18 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 19 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 20 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 21 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 22 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 23 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 24 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible, A23:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 25 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible, A23:ArgumentConvertible, A24:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 26 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible, A23:ArgumentConvertible, A24:ArgumentConvertible, A25:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 27 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible, A23:ArgumentConvertible, A24:ArgumentConvertible, A25:ArgumentConvertible, A26:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 28 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible, A23:ArgumentConvertible, A24:ArgumentConvertible, A25:ArgumentConvertible, A26:ArgumentConvertible, A27:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 29 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible, A23:ArgumentConvertible, A24:ArgumentConvertible, A25:ArgumentConvertible, A26:ArgumentConvertible, A27:ArgumentConvertible, A28:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 30 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible, A23:ArgumentConvertible, A24:ArgumentConvertible, A25:ArgumentConvertible, A26:ArgumentConvertible, A27:ArgumentConvertible, A28:ArgumentConvertible, A29:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 31 arguments using a closure
  public func command<A:ArgumentConvertible, A1:ArgumentConvertible, A2:ArgumentConvertible, A3:ArgumentConvertible, A4:ArgumentConvertible, A5:ArgumentConvertible, A6:ArgumentConvertible, A7:ArgumentConvertible, A8:ArgumentConvertible, A9:ArgumentConvertible, A10:ArgumentConvertible, A11:ArgumentConvertible, A12:ArgumentConvertible, A13:ArgumentConvertible, A14:ArgumentConvertible, A15:ArgumentConvertible, A16:ArgumentConvertible, A17:ArgumentConvertible, A18:ArgumentConvertible, A19:ArgumentConvertible, A20:ArgumentConvertible, A21:ArgumentConvertible, A22:ArgumentConvertible, A23:ArgumentConvertible, A24:ArgumentConvertible, A25:ArgumentConvertible, A26:ArgumentConvertible, A27:ArgumentConvertible, A28:ArgumentConvertible, A29:ArgumentConvertible, A30:ArgumentConvertible>(_ name: String, description: String? = nil, _ closure: @escaping (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29, A30) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  // MARK: Argument Descriptor Commands


  /// Add a command which takes 1 arguments using a closure
  public func command<A:ArgumentDescriptor>(_ name: String, _ descriptor: A, description: String? = nil, _ closure: @escaping (A.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, closure))
  }

  /// Add a command which takes 2 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  closure))
  }

  /// Add a command which takes 3 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  closure))
  }

  /// Add a command which takes 4 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  closure))
  }

  /// Add a command which takes 5 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  closure))
  }

  /// Add a command which takes 6 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  closure))
  }

  /// Add a command which takes 7 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  closure))
  }

  /// Add a command which takes 8 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  closure))
  }

  /// Add a command which takes 9 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  closure))
  }

  /// Add a command which takes 10 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  closure))
  }

  /// Add a command which takes 11 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  closure))
  }

  /// Add a command which takes 12 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  closure))
  }

  /// Add a command which takes 13 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  closure))
  }

  /// Add a command which takes 14 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  closure))
  }

  /// Add a command which takes 15 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, _ descriptor14: A14, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  descriptor14,  closure))
  }

  /// Add a command which takes 16 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, _ descriptor14: A14, _ descriptor15: A15, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  descriptor14,  descriptor15,  closure))
  }

  /// Add a command which takes 17 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, _ descriptor14: A14, _ descriptor15: A15, _ descriptor16: A16, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  descriptor14,  descriptor15,  descriptor16,  closure))
  }

  /// Add a command which takes 18 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, _ descriptor14: A14, _ descriptor15: A15, _ descriptor16: A16, _ descriptor17: A17, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  descriptor14,  descriptor15,  descriptor16,  descriptor17,  closure))
  }

  /// Add a command which takes 19 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, _ descriptor14: A14, _ descriptor15: A15, _ descriptor16: A16, _ descriptor17: A17, _ descriptor18: A18, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  descriptor14,  descriptor15,  descriptor16,  descriptor17,  descriptor18,  closure))
  }

  /// Add a command which takes 20 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, _ descriptor14: A14, _ descriptor15: A15, _ descriptor16: A16, _ descriptor17: A17, _ descriptor18: A18, _ descriptor19: A19, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  descriptor14,  descriptor15,  descriptor16,  descriptor17,  descriptor18,  descriptor19,  closure))
  }

  /// Add a command which takes 21 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, _ descriptor14: A14, _ descriptor15: A15, _ descriptor16: A16, _ descriptor17: A17, _ descriptor18: A18, _ descriptor19: A19, _ descriptor20: A20, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  descriptor14,  descriptor15,  descriptor16,  descriptor17,  descriptor18,  descriptor19,  descriptor20,  closure))
  }

  /// Add a command which takes 22 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, _ descriptor14: A14, _ descriptor15: A15, _ descriptor16: A16, _ descriptor17: A17, _ descriptor18: A18, _ descriptor19: A19, _ descriptor20: A20, _ descriptor21: A21, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  descriptor14,  descriptor15,  descriptor16,  descriptor17,  descriptor18,  descriptor19,  descriptor20,  descriptor21,  closure))
  }

  /// Add a command which takes 23 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, _ descriptor14: A14, _ descriptor15: A15, _ descriptor16: A16, _ descriptor17: A17, _ descriptor18: A18, _ descriptor19: A19, _ descriptor20: A20, _ descriptor21: A21, _ descriptor22: A22, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  descriptor14,  descriptor15,  descriptor16,  descriptor17,  descriptor18,  descriptor19,  descriptor20,  descriptor21,  descriptor22,  closure))
  }

  /// Add a command which takes 24 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor, A23:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, _ descriptor14: A14, _ descriptor15: A15, _ descriptor16: A16, _ descriptor17: A17, _ descriptor18: A18, _ descriptor19: A19, _ descriptor20: A20, _ descriptor21: A21, _ descriptor22: A22, _ descriptor23: A23, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType, A23.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  descriptor14,  descriptor15,  descriptor16,  descriptor17,  descriptor18,  descriptor19,  descriptor20,  descriptor21,  descriptor22,  descriptor23,  closure))
  }

  /// Add a command which takes 25 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor, A23:ArgumentDescriptor, A24:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, _ descriptor14: A14, _ descriptor15: A15, _ descriptor16: A16, _ descriptor17: A17, _ descriptor18: A18, _ descriptor19: A19, _ descriptor20: A20, _ descriptor21: A21, _ descriptor22: A22, _ descriptor23: A23, _ descriptor24: A24, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType, A23.ValueType, A24.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  descriptor14,  descriptor15,  descriptor16,  descriptor17,  descriptor18,  descriptor19,  descriptor20,  descriptor21,  descriptor22,  descriptor23,  descriptor24,  closure))
  }

  /// Add a command which takes 26 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor, A23:ArgumentDescriptor, A24:ArgumentDescriptor, A25:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, _ descriptor14: A14, _ descriptor15: A15, _ descriptor16: A16, _ descriptor17: A17, _ descriptor18: A18, _ descriptor19: A19, _ descriptor20: A20, _ descriptor21: A21, _ descriptor22: A22, _ descriptor23: A23, _ descriptor24: A24, _ descriptor25: A25, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType, A23.ValueType, A24.ValueType, A25.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  descriptor14,  descriptor15,  descriptor16,  descriptor17,  descriptor18,  descriptor19,  descriptor20,  descriptor21,  descriptor22,  descriptor23,  descriptor24,  descriptor25,  closure))
  }

  /// Add a command which takes 27 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor, A23:ArgumentDescriptor, A24:ArgumentDescriptor, A25:ArgumentDescriptor, A26:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, _ descriptor14: A14, _ descriptor15: A15, _ descriptor16: A16, _ descriptor17: A17, _ descriptor18: A18, _ descriptor19: A19, _ descriptor20: A20, _ descriptor21: A21, _ descriptor22: A22, _ descriptor23: A23, _ descriptor24: A24, _ descriptor25: A25, _ descriptor26: A26, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType, A23.ValueType, A24.ValueType, A25.ValueType, A26.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  descriptor14,  descriptor15,  descriptor16,  descriptor17,  descriptor18,  descriptor19,  descriptor20,  descriptor21,  descriptor22,  descriptor23,  descriptor24,  descriptor25,  descriptor26,  closure))
  }

  /// Add a command which takes 28 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor, A23:ArgumentDescriptor, A24:ArgumentDescriptor, A25:ArgumentDescriptor, A26:ArgumentDescriptor, A27:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, _ descriptor14: A14, _ descriptor15: A15, _ descriptor16: A16, _ descriptor17: A17, _ descriptor18: A18, _ descriptor19: A19, _ descriptor20: A20, _ descriptor21: A21, _ descriptor22: A22, _ descriptor23: A23, _ descriptor24: A24, _ descriptor25: A25, _ descriptor26: A26, _ descriptor27: A27, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType, A23.ValueType, A24.ValueType, A25.ValueType, A26.ValueType, A27.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  descriptor14,  descriptor15,  descriptor16,  descriptor17,  descriptor18,  descriptor19,  descriptor20,  descriptor21,  descriptor22,  descriptor23,  descriptor24,  descriptor25,  descriptor26,  descriptor27,  closure))
  }

  /// Add a command which takes 29 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor, A23:ArgumentDescriptor, A24:ArgumentDescriptor, A25:ArgumentDescriptor, A26:ArgumentDescriptor, A27:ArgumentDescriptor, A28:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, _ descriptor14: A14, _ descriptor15: A15, _ descriptor16: A16, _ descriptor17: A17, _ descriptor18: A18, _ descriptor19: A19, _ descriptor20: A20, _ descriptor21: A21, _ descriptor22: A22, _ descriptor23: A23, _ descriptor24: A24, _ descriptor25: A25, _ descriptor26: A26, _ descriptor27: A27, _ descriptor28: A28, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType, A23.ValueType, A24.ValueType, A25.ValueType, A26.ValueType, A27.ValueType, A28.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  descriptor14,  descriptor15,  descriptor16,  descriptor17,  descriptor18,  descriptor19,  descriptor20,  descriptor21,  descriptor22,  descriptor23,  descriptor24,  descriptor25,  descriptor26,  descriptor27,  descriptor28,  closure))
  }

  /// Add a command which takes 30 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor, A23:ArgumentDescriptor, A24:ArgumentDescriptor, A25:ArgumentDescriptor, A26:ArgumentDescriptor, A27:ArgumentDescriptor, A28:ArgumentDescriptor, A29:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, _ descriptor14: A14, _ descriptor15: A15, _ descriptor16: A16, _ descriptor17: A17, _ descriptor18: A18, _ descriptor19: A19, _ descriptor20: A20, _ descriptor21: A21, _ descriptor22: A22, _ descriptor23: A23, _ descriptor24: A24, _ descriptor25: A25, _ descriptor26: A26, _ descriptor27: A27, _ descriptor28: A28, _ descriptor29: A29, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType, A23.ValueType, A24.ValueType, A25.ValueType, A26.ValueType, A27.ValueType, A28.ValueType, A29.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  descriptor14,  descriptor15,  descriptor16,  descriptor17,  descriptor18,  descriptor19,  descriptor20,  descriptor21,  descriptor22,  descriptor23,  descriptor24,  descriptor25,  descriptor26,  descriptor27,  descriptor28,  descriptor29,  closure))
  }

  /// Add a command which takes 31 arguments using a closure
  public func command<A:ArgumentDescriptor, A1:ArgumentDescriptor, A2:ArgumentDescriptor, A3:ArgumentDescriptor, A4:ArgumentDescriptor, A5:ArgumentDescriptor, A6:ArgumentDescriptor, A7:ArgumentDescriptor, A8:ArgumentDescriptor, A9:ArgumentDescriptor, A10:ArgumentDescriptor, A11:ArgumentDescriptor, A12:ArgumentDescriptor, A13:ArgumentDescriptor, A14:ArgumentDescriptor, A15:ArgumentDescriptor, A16:ArgumentDescriptor, A17:ArgumentDescriptor, A18:ArgumentDescriptor, A19:ArgumentDescriptor, A20:ArgumentDescriptor, A21:ArgumentDescriptor, A22:ArgumentDescriptor, A23:ArgumentDescriptor, A24:ArgumentDescriptor, A25:ArgumentDescriptor, A26:ArgumentDescriptor, A27:ArgumentDescriptor, A28:ArgumentDescriptor, A29:ArgumentDescriptor, A30:ArgumentDescriptor>(_ name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, _ descriptor14: A14, _ descriptor15: A15, _ descriptor16: A16, _ descriptor17: A17, _ descriptor18: A18, _ descriptor19: A19, _ descriptor20: A20, _ descriptor21: A21, _ descriptor22: A22, _ descriptor23: A23, _ descriptor24: A24, _ descriptor25: A25, _ descriptor26: A26, _ descriptor27: A27, _ descriptor28: A28, _ descriptor29: A29, _ descriptor30: A30, description: String? = nil, _ closure: @escaping (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType, A14.ValueType, A15.ValueType, A16.ValueType, A17.ValueType, A18.ValueType, A19.ValueType, A20.ValueType, A21.ValueType, A22.ValueType, A23.ValueType, A24.ValueType, A25.ValueType, A26.ValueType, A27.ValueType, A28.ValueType, A29.ValueType, A30.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1,  descriptor2,  descriptor3,  descriptor4,  descriptor5,  descriptor6,  descriptor7,  descriptor8,  descriptor9,  descriptor10,  descriptor11,  descriptor12,  descriptor13,  descriptor14,  descriptor15,  descriptor16,  descriptor17,  descriptor18,  descriptor19,  descriptor20,  descriptor21,  descriptor22,  descriptor23,  descriptor24,  descriptor25,  descriptor26,  descriptor27,  descriptor28,  descriptor29,  descriptor30,  closure))
  }

}

