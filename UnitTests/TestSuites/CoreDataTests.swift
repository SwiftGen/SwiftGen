//
//  CoreDataTests.swift
//  SwiftGen
//
//  Created by Igor Palaguta on 31.10.16.
//  Copyright © 2016 AliSoftware. All rights reserved.
//

import XCTest
@testable import GenumKit

class CoreDataTests: XCTestCase {

  func testEmpty() {
    let parser = CoreDataModelParser()

    let template = GenumTemplate(templateString: fixtureString("coredata-model-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("CoreData-Model-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testModelWithDefault() {
    let parser = CoreDataModelParser()
    try! parser.parseModelFile(self.fixturePath("TypesModel.xcdatamodeld"))

    let template = GenumTemplate(templateString: fixtureString("coredata-model-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("CoreData-Model-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testUnversionedModelWithDefault() {
    let parser = CoreDataModelParser()
    try! parser.parseModelFile(self.fixturePath("TypesModel.xcdatamodel", subDirectory: "TypesModel.xcdatamodeld"))

    let template = GenumTemplate(templateString: fixtureString("coredata-model-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("CoreData-Model-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testMachineWithDefault() {
    let parser = CoreDataModelParser()
    try! parser.parseModelFile(self.fixturePath("TypesModel.xcdatamodeld"))

    let template = GenumTemplate(templateString: fixtureString("coredata-machine-default.stencil"))

    let entityNames = ["AllTypes", "NumericTypes", "ScalarTypes"]

    for entityName in entityNames {
      let entity = parser.entitiesByName[entityName]!
      let result = try! template.render(parser.stencilContextForEntity(entity))

      let expected = self.fixtureString("CoreData-Machine-Default-\(entityName)Class.swift.out")
      XCTDiffStrings(result, expected)
    }
  }

  func testMachineWithMogenerator() {
    let parser = CoreDataModelParser()
    try! parser.parseModelFile(self.fixturePath("TypesModel.xcdatamodeld"))

    let template = GenumTemplate(templateString: fixtureString("coredata-machine-mogenerator.stencil"))

    let entityNames = ["AllTypes", "NumericTypes", "ScalarTypes"]

    for entityName in entityNames {
      let entity = parser.entitiesByName[entityName]!
      let result = try! template.render(parser.stencilContextForEntity(entity))

      let expected = self.fixtureString("CoreData-Machine-Mogenerator-\(entityName)Class.swift.out")
      XCTDiffStrings(result, expected)
    }
  }

  func testHumanWithDefault() {
    let parser = CoreDataModelParser()
    try! parser.parseModelFile(self.fixturePath("TypesModel.xcdatamodeld"))

    let template = GenumTemplate(templateString: fixtureString("coredata-human-default.stencil"))

    let entity = parser.entitiesByName["AllTypes"]!
    let result = try! template.render(parser.stencilContextForEntity(entity))

    let expected = self.fixtureString("CoreData-Human-Default-\(entity.className!).swift.out")
    XCTDiffStrings(result, expected)
  }

  func testHumanWithMogenerator() {
    let parser = CoreDataModelParser()
    try! parser.parseModelFile(self.fixturePath("TypesModel.xcdatamodeld"))

    let template = GenumTemplate(templateString: fixtureString("coredata-human-mogenerator.stencil"))

    let entity = parser.entitiesByName["AllTypes"]!
    let result = try! template.render(parser.stencilContextForEntity(entity))

    let expected = self.fixtureString("CoreData-Human-Mogenerator-\(entity.className!).swift.out")
    XCTDiffStrings(result, expected)
  }
}
