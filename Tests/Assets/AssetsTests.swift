//
//  StoryboardTests.swift
//  SwiftGen
//
//  Created by Olivier Halligon on 01/08/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import XCTest

/**
 * Important: In order for the "*.xcassets" files in fixtures/ to be copied as-is in the test bundle
 * (as opposed to being compiled when the test bundle is compiled), a custom "Build Rule" has been added to the target.
 * See Project -> Target "swiftgen-assets-tests" -> Build Rules -> « Files "*.xccassets" using PBXCp »
 */

class AssetsTests: XCTestCase {

    func testFileDefaults() {
        let enumBuilder = SwiftGenAssetsEnumBuilder()
        enumBuilder.parseDirectory(fixturePath("Images.xcassets"))
        let result = enumBuilder.build()
        
        let expected = self.fixtureString("FileDefaults.swift.out")
        XCTAssertEqual(result, expected)
    }

}
