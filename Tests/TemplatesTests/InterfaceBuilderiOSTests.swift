//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

class InterfaceBuilderiOSTests: InterfaceBuilderTests {
  func testScenesSwift3() {
    test(template: "scenes-swift3",
         contextNames: Contexts.all,
         directory: .interfaceBuilder,
         resourceDirectory: .interfaceBuilderiOS,
         contextVariations: variations)
  }

  func testSeguesSwift3() {
    test(template: "segues-swift3",
         contextNames: Contexts.all,
         directory: .interfaceBuilder,
         resourceDirectory: .interfaceBuilderiOS,
         contextVariations: variations)
  }

  func testScenesSwift4() {
    test(template: "scenes-swift4",
         contextNames: Contexts.all,
         directory: .interfaceBuilder,
         resourceDirectory: .interfaceBuilderiOS,
         contextVariations: variations)
  }

  func testSeguesSwift4() {
    test(template: "segues-swift4",
         contextNames: Contexts.all,
         directory: .interfaceBuilder,
         resourceDirectory: .interfaceBuilderiOS,
         contextVariations: variations)
  }
}
