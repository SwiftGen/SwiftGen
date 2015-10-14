//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
import GenumKit

/**
 * Important: In order for the "*.xcassets" files in fixtures/ to be copied as-is in the test bundle
 * (as opposed to being compiled when the test bundle is compiled), a custom "Build Rule" has been added to the target.
 * See Project -> Target "UnitTests" -> Build Rules -> « Files "*.xccassets" using PBXCp »
 */

class ImagesTests: XCTestCase {

    func testEntriesWithDefaults() {
        let enumBuilder = ImageEnumBuilder()
        enumBuilder.addImageName("Green-Apple")
        enumBuilder.addImageName("Red Apple")
        enumBuilder.addImageName("2-pears")
        let result = enumBuilder.build()
        
        let expected = self.fixtureString("Images-Entries-Defaults.swift.out")
        XCTDiffStrings(result, expected)
    }

    func testFileWithDefaults() {
        let enumBuilder = ImageEnumBuilder()
        enumBuilder.parseDirectory(fixturePath("Images.xcassets"))
        let result = enumBuilder.build()
        
        let expected = self.fixtureString("Images-File-Defaults.swift.out")
        XCTDiffStrings(result, expected)
    }

}
