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

class UnmeasuredTests: XCTestCase {
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
    
    func testEachConvertAndInterpret() {
        ingredient.measurement.unit = .each
        ingredient.measurement.amount = 3
        
        let scaleMeasure = ingredient.scale(by: Fraction.oneThird.rawValue, measurementSystemMethod: .metricWeight)
        XCTAssertTrue(scaleMeasure.amount == 3.0 * Fraction.oneThird.rawValue)
        XCTAssertTrue(scaleMeasure.unit == .each)
        
        let interpret = scaleMeasure.componentsTranslation
        XCTAssertTrue(interpret == "1 Each")
    }
    
    func testEachFractional() {
        ingredient.measurement.unit = .each
        ingredient.measurement.amount = 1
        
        let scaleMeasure = ingredient.scale(by: 1.35, measurementSystemMethod: .metricWeight)
        XCTAssertTrue(scaleMeasure.amount == 1.35)
        XCTAssertTrue(scaleMeasure.unit == .each)
        
        let interpret = scaleMeasure.componentsTranslation
        XCTAssertTrue(interpret == "1" + Fraction.oneThird.stringValue + " Each")
    }
}
