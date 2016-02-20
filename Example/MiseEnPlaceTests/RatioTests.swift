//
//  RatioTests.swift
//  MiseEnPlace
//
//  Created by Richard Piazza on 11/4/15.
//  Copyright © 2015 Richard Piazza. All rights reserved.
//

import XCTest
import MiseEnPlace

class RatioTests: XCTestCase {
    
    private class MeasurementConvertable: NSObject, Convertable {
        var amount: Float = 1
        var unit: MeasurementUnit = .Gram
        
        var measurementAmount: Float {
            return self.amount
        }
        
        var measurementUnit: MeasurementUnit {
            return self.unit
        }
        
        var ratio: Ratio {
            return Ratio(volume: 1, mass: 1)
        }
    }
    
    private var volumeConvertable: MeasurementConvertable = MeasurementConvertable()
    private var massConvertable: MeasurementConvertable = MeasurementConvertable()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOneToOneRatio() {
        volumeConvertable.amount = 2
        volumeConvertable.unit = .FluidOunce
        massConvertable.amount = 2
        massConvertable.unit = .Ounce
        
        let ratio = Converter.volumeToMassRatioFor(volumeConvertable, massConvertable: massConvertable)
        XCTAssertTrue(ratio.volume == 1)
        XCTAssertTrue(ratio.mass == 1)
    }
    
    func testOneToTwoRatio() {
        volumeConvertable.amount = 2
        volumeConvertable.unit = .FluidOunce
        massConvertable.amount = 4
        massConvertable.unit = .Ounce
        
        let ratio = Converter.volumeToMassRatioFor(volumeConvertable, massConvertable: massConvertable)
        XCTAssertTrue(ratio.volume == 1)
        XCTAssertTrue(ratio.mass == 2)
    }
    
    func testTwoToOneRatio() {
        volumeConvertable.amount = 4
        volumeConvertable.unit = .FluidOunce
        massConvertable.amount = 2
        massConvertable.unit = .Ounce
        
        let ratio = Converter.volumeToMassRatioFor(volumeConvertable, massConvertable: massConvertable)
        XCTAssertTrue(ratio.volume == 2)
        XCTAssertTrue(ratio.mass == 1)
    }
}
