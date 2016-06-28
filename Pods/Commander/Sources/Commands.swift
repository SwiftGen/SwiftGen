/// Automatically generated file from Examples/generator.swift

// MARK: Commands


/// Create a command which takes 1 argument using a closure
public func command<A: ArgumentConvertible>(closure: (A) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser))
  }
}

/// Create a command which takes 2 argument using a closure
public func command<A: ArgumentConvertible, A1: ArgumentConvertible>(closure: (A, A1) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser))
  }
}

/// Create a command which takes 3 argument using a closure
public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible>(closure: (A, A1, A2) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser))
  }
}

/// Create a command which takes 4 argument using a closure
public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible>(closure: (A, A1, A2, A3) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser))
  }
}

/// Create a command which takes 5 argument using a closure
public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible>(closure: (A, A1, A2, A3, A4) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser))
  }
}

/// Create a command which takes 6 argument using a closure
public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible>(closure: (A, A1, A2, A3, A4, A5) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser))
  }
}

/// Create a command which takes 7 argument using a closure
public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible, A6: ArgumentConvertible>(closure: (A, A1, A2, A3, A4, A5, A6) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser))
  }
}

/// Create a command which takes 8 argument using a closure
public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible, A6: ArgumentConvertible, A7: ArgumentConvertible>(closure: (A, A1, A2, A3, A4, A5, A6, A7) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser))
  }
}

/// Create a command which takes 9 argument using a closure
public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible, A6: ArgumentConvertible, A7: ArgumentConvertible, A8: ArgumentConvertible>(closure: (A, A1, A2, A3, A4, A5, A6, A7, A8) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser))
  }
}

/// Create a command which takes 10 argument using a closure
public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible, A6: ArgumentConvertible, A7: ArgumentConvertible, A8: ArgumentConvertible, A9: ArgumentConvertible>(closure: (A, A1, A2, A3, A4, A5, A6, A7, A8, A9) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser))
  }
}

/// Create a command which takes 11 argument using a closure
public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible, A6: ArgumentConvertible, A7: ArgumentConvertible, A8: ArgumentConvertible, A9: ArgumentConvertible, A10: ArgumentConvertible>(closure: (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser))
  }
}

/// Create a command which takes 12 argument using a closure
public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible, A6: ArgumentConvertible, A7: ArgumentConvertible, A8: ArgumentConvertible, A9: ArgumentConvertible, A10: ArgumentConvertible, A11: ArgumentConvertible>(closure: (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser))
  }
}

/// Create a command which takes 13 argument using a closure
public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible, A6: ArgumentConvertible, A7: ArgumentConvertible, A8: ArgumentConvertible, A9: ArgumentConvertible, A10: ArgumentConvertible, A11: ArgumentConvertible, A12: ArgumentConvertible>(closure: (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser))
  }
}

/// Create a command which takes 14 argument using a closure
public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible, A6: ArgumentConvertible, A7: ArgumentConvertible, A8: ArgumentConvertible, A9: ArgumentConvertible, A10: ArgumentConvertible, A11: ArgumentConvertible, A12: ArgumentConvertible, A13: ArgumentConvertible>(closure: (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13) throws-> ()) -> CommandType {
  return AnonymousCommand { parser in
    try closure(try A(parser: parser), try A1(parser: parser), try A2(parser: parser), try A3(parser: parser), try A4(parser: parser), try A5(parser: parser), try A6(parser: parser), try A7(parser: parser), try A8(parser: parser), try A9(parser: parser), try A10(parser: parser), try A11(parser: parser), try A12(parser: parser), try A13(parser: parser))
  }
}


// MARK: Argument Descriptor Commands


/// Create a command which takes 1 argument using a closure with arguments
public func command<A: ArgumentDescriptor>(descriptor: A, closure: (A.ValueType) throws -> ()) -> CommandType {
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
public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor>(descriptor: A, _ descriptor1: A1, closure: (A.ValueType, A1.ValueType) throws -> ()) -> CommandType {
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
public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor>(descriptor: A, _ descriptor1: A1, _ descriptor2: A2, closure: (A.ValueType, A1.ValueType, A2.ValueType) throws -> ()) -> CommandType {
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
public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor>(descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType) throws -> ()) -> CommandType {
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
public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor>(descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType) throws -> ()) -> CommandType {
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
public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor>(descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType) throws -> ()) -> CommandType {
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
public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor, A6: ArgumentDescriptor>(descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType) throws -> ()) -> CommandType {
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
public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor, A6: ArgumentDescriptor, A7: ArgumentDescriptor>(descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType) throws -> ()) -> CommandType {
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
public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor, A6: ArgumentDescriptor, A7: ArgumentDescriptor, A8: ArgumentDescriptor>(descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType) throws -> ()) -> CommandType {
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
public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor, A6: ArgumentDescriptor, A7: ArgumentDescriptor, A8: ArgumentDescriptor, A9: ArgumentDescriptor>(descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType) throws -> ()) -> CommandType {
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
public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor, A6: ArgumentDescriptor, A7: ArgumentDescriptor, A8: ArgumentDescriptor, A9: ArgumentDescriptor, A10: ArgumentDescriptor>(descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType) throws -> ()) -> CommandType {
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
public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor, A6: ArgumentDescriptor, A7: ArgumentDescriptor, A8: ArgumentDescriptor, A9: ArgumentDescriptor, A10: ArgumentDescriptor, A11: ArgumentDescriptor>(descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType) throws -> ()) -> CommandType {
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
public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor, A6: ArgumentDescriptor, A7: ArgumentDescriptor, A8: ArgumentDescriptor, A9: ArgumentDescriptor, A10: ArgumentDescriptor, A11: ArgumentDescriptor, A12: ArgumentDescriptor>(descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType) throws -> ()) -> CommandType {
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
public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor, A6: ArgumentDescriptor, A7: ArgumentDescriptor, A8: ArgumentDescriptor, A9: ArgumentDescriptor, A10: ArgumentDescriptor, A11: ArgumentDescriptor, A12: ArgumentDescriptor, A13: ArgumentDescriptor>(descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType) throws -> ()) -> CommandType {
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


// MARK: Group commands

extension Group {
  // MARK: Argument Description Commands

  /// Add a command which takes no argument using a closure
  public func command(name: String, description: String? = nil, closure:() throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 1 arguments using a closure
  public func command<A: ArgumentConvertible>(name: String, description: String? = nil, closure: (A) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 2 arguments using a closure
  public func command<A: ArgumentConvertible, A1: ArgumentConvertible>(name: String, description: String? = nil, closure: (A, A1) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 3 arguments using a closure
  public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible>(name: String, description: String? = nil, closure: (A, A1, A2) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 4 arguments using a closure
  public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible>(name: String, description: String? = nil, closure: (A, A1, A2, A3) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 5 arguments using a closure
  public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible>(name: String, description: String? = nil, closure: (A, A1, A2, A3, A4) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 6 arguments using a closure
  public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible>(name: String, description: String? = nil, closure: (A, A1, A2, A3, A4, A5) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 7 arguments using a closure
  public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible, A6: ArgumentConvertible>(name: String, description: String? = nil, closure: (A, A1, A2, A3, A4, A5, A6) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 8 arguments using a closure
  public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible, A6: ArgumentConvertible, A7: ArgumentConvertible>(name: String, description: String? = nil, closure: (A, A1, A2, A3, A4, A5, A6, A7) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 9 arguments using a closure
  public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible, A6: ArgumentConvertible, A7: ArgumentConvertible, A8: ArgumentConvertible>(name: String, description: String? = nil, closure: (A, A1, A2, A3, A4, A5, A6, A7, A8) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 10 arguments using a closure
  public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible, A6: ArgumentConvertible, A7: ArgumentConvertible, A8: ArgumentConvertible, A9: ArgumentConvertible>(name: String, description: String? = nil, closure: (A, A1, A2, A3, A4, A5, A6, A7, A8, A9) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 11 arguments using a closure
  public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible, A6: ArgumentConvertible, A7: ArgumentConvertible, A8: ArgumentConvertible, A9: ArgumentConvertible, A10: ArgumentConvertible>(name: String, description: String? = nil, closure: (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 12 arguments using a closure
  public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible, A6: ArgumentConvertible, A7: ArgumentConvertible, A8: ArgumentConvertible, A9: ArgumentConvertible, A10: ArgumentConvertible, A11: ArgumentConvertible>(name: String, description: String? = nil, closure: (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 13 arguments using a closure
  public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible, A6: ArgumentConvertible, A7: ArgumentConvertible, A8: ArgumentConvertible, A9: ArgumentConvertible, A10: ArgumentConvertible, A11: ArgumentConvertible, A12: ArgumentConvertible>(name: String, description: String? = nil, closure: (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  /// Add a command which takes 14 arguments using a closure
  public func command<A: ArgumentConvertible, A1: ArgumentConvertible, A2: ArgumentConvertible, A3: ArgumentConvertible, A4: ArgumentConvertible, A5: ArgumentConvertible, A6: ArgumentConvertible, A7: ArgumentConvertible, A8: ArgumentConvertible, A9: ArgumentConvertible, A10: ArgumentConvertible, A11: ArgumentConvertible, A12: ArgumentConvertible, A13: ArgumentConvertible>(name: String, description: String? = nil, closure: (A, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13) throws -> ()) {
    addCommand(name, description, Commander.command(closure))
  }

  // MARK: Argument Descriptor Commands


  /// Add a command which takes 1 arguments using a closure
  public func command<A: ArgumentDescriptor>(name: String, _ descriptor: A, description: String? = nil, closure: (A.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, closure: closure))
  }

  /// Add a command which takes 2 arguments using a closure
  public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor>(name: String, _ descriptor: A, _ descriptor1: A1, description: String? = nil, closure: (A.ValueType, A1.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1, closure: closure))
  }

  /// Add a command which takes 3 arguments using a closure
  public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor>(name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, description: String? = nil, closure: (A.ValueType, A1.ValueType, A2.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1, descriptor2, closure: closure))
  }

  /// Add a command which takes 4 arguments using a closure
  public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor>(name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, description: String? = nil, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1, descriptor2, descriptor3, closure: closure))
  }

  /// Add a command which takes 5 arguments using a closure
  public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor>(name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, description: String? = nil, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1, descriptor2, descriptor3, descriptor4, closure: closure))
  }

  /// Add a command which takes 6 arguments using a closure
  public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor>(name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, description: String? = nil, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1, descriptor2, descriptor3, descriptor4, descriptor5, closure: closure))
  }

  /// Add a command which takes 7 arguments using a closure
  public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor, A6: ArgumentDescriptor>(name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, description: String? = nil, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1, descriptor2, descriptor3, descriptor4, descriptor5, descriptor6, closure: closure))
  }

  /// Add a command which takes 8 arguments using a closure
  public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor, A6: ArgumentDescriptor, A7: ArgumentDescriptor>(name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, description: String? = nil, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1, descriptor2, descriptor3, descriptor4, descriptor5, descriptor6, descriptor7, closure: closure))
  }

  /// Add a command which takes 9 arguments using a closure
  public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor, A6: ArgumentDescriptor, A7: ArgumentDescriptor, A8: ArgumentDescriptor>(name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, description: String? = nil, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1, descriptor2, descriptor3, descriptor4, descriptor5, descriptor6, descriptor7, descriptor8, closure: closure))
  }

  /// Add a command which takes 10 arguments using a closure
  public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor, A6: ArgumentDescriptor, A7: ArgumentDescriptor, A8: ArgumentDescriptor, A9: ArgumentDescriptor>(name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, description: String? = nil, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1, descriptor2, descriptor3, descriptor4, descriptor5, descriptor6, descriptor7, descriptor8, descriptor9, closure: closure))
  }

  /// Add a command which takes 11 arguments using a closure
  public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor, A6: ArgumentDescriptor, A7: ArgumentDescriptor, A8: ArgumentDescriptor, A9: ArgumentDescriptor, A10: ArgumentDescriptor>(name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, description: String? = nil, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1, descriptor2, descriptor3, descriptor4, descriptor5, descriptor6, descriptor7, descriptor8, descriptor9, descriptor10, closure: closure))
  }

  /// Add a command which takes 12 arguments using a closure
  public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor, A6: ArgumentDescriptor, A7: ArgumentDescriptor, A8: ArgumentDescriptor, A9: ArgumentDescriptor, A10: ArgumentDescriptor, A11: ArgumentDescriptor>(name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, description: String? = nil, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1, descriptor2, descriptor3, descriptor4, descriptor5, descriptor6, descriptor7, descriptor8, descriptor9, descriptor10, descriptor11, closure: closure))
  }

  /// Add a command which takes 13 arguments using a closure
  public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor, A6: ArgumentDescriptor, A7: ArgumentDescriptor, A8: ArgumentDescriptor, A9: ArgumentDescriptor, A10: ArgumentDescriptor, A11: ArgumentDescriptor, A12: ArgumentDescriptor>(name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, description: String? = nil, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1, descriptor2, descriptor3, descriptor4, descriptor5, descriptor6, descriptor7, descriptor8, descriptor9, descriptor10, descriptor11, descriptor12, closure: closure))
  }

  /// Add a command which takes 14 arguments using a closure
  public func command<A: ArgumentDescriptor, A1: ArgumentDescriptor, A2: ArgumentDescriptor, A3: ArgumentDescriptor, A4: ArgumentDescriptor, A5: ArgumentDescriptor, A6: ArgumentDescriptor, A7: ArgumentDescriptor, A8: ArgumentDescriptor, A9: ArgumentDescriptor, A10: ArgumentDescriptor, A11: ArgumentDescriptor, A12: ArgumentDescriptor, A13: ArgumentDescriptor>(name: String, _ descriptor: A, _ descriptor1: A1, _ descriptor2: A2, _ descriptor3: A3, _ descriptor4: A4, _ descriptor5: A5, _ descriptor6: A6, _ descriptor7: A7, _ descriptor8: A8, _ descriptor9: A9, _ descriptor10: A10, _ descriptor11: A11, _ descriptor12: A12, _ descriptor13: A13, description: String? = nil, closure: (A.ValueType, A1.ValueType, A2.ValueType, A3.ValueType, A4.ValueType, A5.ValueType, A6.ValueType, A7.ValueType, A8.ValueType, A9.ValueType, A10.ValueType, A11.ValueType, A12.ValueType, A13.ValueType) throws -> ()) {
    addCommand(name, description, Commander.command(descriptor, descriptor1, descriptor2, descriptor3, descriptor4, descriptor5, descriptor6, descriptor7, descriptor8, descriptor9, descriptor10, descriptor11, descriptor12, descriptor13, closure: closure))
  }

}
