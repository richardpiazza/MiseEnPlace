//
//  AsNeededEachTests.swift
//  miseenplace
//
//  Created by Richard Piazza on 8/6/15.
//  Copyright (c) 2015 Richard Piazza. All rights reserved.
//

import Foundation
import XCTest
import MiseEnPlace

class AsNeededTests: XCTestCase {
    var ingredient: ConvertableIngredient = ConvertableIngredient()

    override func setUp() {
        super.setUp()
        
        ingredient.ratio.weight = 1
        ingredient.ratio.volume = 1
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAsNeededConvertAndInterpret() {
        ingredient.measurement.unit = .asNeeded
        
        let scaleMeasure = ingredient.scale(by: 1.0, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount == 0)
        XCTAssertTrue(scaleMeasure.unit == .asNeeded)
        
        let interpret = scaleMeasure.componentsTranslation
        XCTAssertTrue(interpret == "As Needed")
    }
}
