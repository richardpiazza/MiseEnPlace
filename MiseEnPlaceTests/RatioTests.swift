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
    
    fileprivate class MeasurementConvertable: NSObject, Convertable {
        var measurement: ScaleMeasure = ScaleMeasure(amount: 1.0, unit: .gram)
        
        var ratio: Ratio {
            return Ratio(volume: 1, mass: 1)
        }
    }
    
    fileprivate var volumeConvertable: MeasurementConvertable = MeasurementConvertable()
    fileprivate var massConvertable: MeasurementConvertable = MeasurementConvertable()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOneToOneRatio() {
        volumeConvertable.measurement.amount = 2
        volumeConvertable.measurement.unit = .fluidOunce
        massConvertable.measurement.amount = 2
        massConvertable.measurement.unit = .ounce
        
        let ratio = Converter.volumeToMassRatioFor(volumeConvertable, massConvertable: massConvertable)
        XCTAssertTrue(ratio.volume == 1)
        XCTAssertTrue(ratio.mass == 1)
    }
    
    func testOneToTwoRatio() {
        volumeConvertable.measurement.amount = 2
        volumeConvertable.measurement.unit = .fluidOunce
        massConvertable.measurement.amount = 4
        massConvertable.measurement.unit = .ounce
        
        let ratio = Converter.volumeToMassRatioFor(volumeConvertable, massConvertable: massConvertable)
        XCTAssertTrue(ratio.volume == 1)
        XCTAssertTrue(ratio.mass == 2)
    }
    
    func testTwoToOneRatio() {
        volumeConvertable.measurement.amount = 4
        volumeConvertable.measurement.unit = .fluidOunce
        massConvertable.measurement.amount = 2
        massConvertable.measurement.unit = .ounce
        
        let ratio = Converter.volumeToMassRatioFor(volumeConvertable, massConvertable: massConvertable)
        XCTAssertTrue(ratio.volume == 2)
        XCTAssertTrue(ratio.mass == 1)
    }
}
