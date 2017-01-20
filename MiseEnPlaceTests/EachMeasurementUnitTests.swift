//
//  EachMeasurementUnitTests.swift
//  MiseEnPlace
//
//  Created by Richard Piazza on 1/20/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import Foundation
import XCTest
import MiseEnPlace

class EachMeasurementUnitTests: XCTestCase {
    var egg: ConvertableIngredient = ConvertableIngredient()
    var eggWhite: ConvertableIngredient = ConvertableIngredient()
    var eggYolk: ConvertableIngredient = ConvertableIngredient()
    
    override func setUp() {
        super.setUp()
        
        egg.eachMeasurement = CookingMeasurement(amount: 50, unit: .gram)
        eggWhite.eachMeasurement = CookingMeasurement(amount: 25, unit: .gram)
        eggYolk.eachMeasurement = CookingMeasurement(amount: 25, unit: .gram)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEgg() {
        egg.measurement.amount = 4
        egg.measurement.unit = .each
        
        var interpretation = egg.measurement.componentsTranslation
        XCTAssertEqual(interpretation, "4 Each")
        
        var scaleMeasure = egg.scale(by: 2.0, measurementSystemMethod: .numericQuantity)
        XCTAssertEqual(scaleMeasure.amount, 8)
        XCTAssertEqual(scaleMeasure.unit, .each)
        
        interpretation = scaleMeasure.componentsTranslation
        XCTAssertEqual(interpretation, "8 Each")
        
        scaleMeasure = egg.scale(by: 1.0, measurementSystemMethod: .metricWeight)
        XCTAssertEqual(scaleMeasure.amount, 200)
        XCTAssertEqual(scaleMeasure.unit, .gram)
        
        interpretation = scaleMeasure.componentsTranslation
        XCTAssertEqual(interpretation, "200 Gram")
        
        egg.measurement.amount = 200
        egg.measurement.unit = .gram
        
        scaleMeasure = egg.scale(by: 1.0, measurementSystemMethod: .numericQuantity)
        XCTAssertEqual(scaleMeasure.amount, 4)
        XCTAssertEqual(scaleMeasure.unit, .each)
    }
    
    func testEggWhite() {
        eggWhite.measurement.amount = 8
        eggWhite.measurement.unit = .fluidOunce
        
        let interpretation = eggWhite.measurement.componentsTranslation
        XCTAssertEqual(interpretation, "8 Fluid Ounce")
        
        let scaleMeasure = eggWhite.scale(by: 1.0, measurementSystem: .numeric, measurementMethod: .quantity)
        XCTAssertTrue(scaleMeasure.amount.equals(9.07, precision: 2))
        XCTAssertEqual(scaleMeasure.unit, .each)
    }
}
