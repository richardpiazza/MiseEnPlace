//
//  SignificantDigitTests.swift
//  MiseEnPlace
//
//  Created by Richard Piazza on 11/8/16.
//  Copyright © 2016 Richard Piazza. All rights reserved.
//

import Foundation
import XCTest
import MiseEnPlace

class SignificantDigitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCup() {
        let measurement = CookingMeasurement(amount: 0.0951019406578092, unit: .cup)
        XCTAssertEqual(measurement.translation, "0.095 Cup")
    }
    
    func testPint() {
        let measurement = CookingMeasurement(amount: 0.0475509703289046, unit: .pint)
        XCTAssertEqual(measurement.translation, "0.048 Pint")
    }
    
    func testQuart() {
        let measurement = CookingMeasurement(amount: 0.0237754851644523, unit: .quart)
        XCTAssertEqual(measurement.translation, "0.024 Quart")
    }
    
    func testGallon() {
        let measurement = CookingMeasurement(amount: 0.00594387129111308, unit: .gallon)
        XCTAssertEqual(measurement.translation, "0.0059 Gallon")
    }
    
    func testPound() {
        let measurement = CookingMeasurement(amount: 0.022046226315695, unit: .pound)
        XCTAssertEqual(measurement.translation, "0.022 Pound")
    }
}
