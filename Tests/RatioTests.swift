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
        var measurement = MiseEnPlace.Measurement(amount: 1.0, unit: .gram)
        var ratio = Ratio(volume: 1.0, weight: 1.0)
        var eachMeasurement: MiseEnPlace.Measurement?
    }
    
    fileprivate var volumeConvertable: MeasurementConvertable = MeasurementConvertable()
    fileprivate var weightConvertable: MeasurementConvertable = MeasurementConvertable()
    
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
        weightConvertable.measurement.amount = 2
        weightConvertable.measurement.unit = .ounce
        
        let ratio = try! Ratio.makeRatio(volume: volumeConvertable.measurement, weight: weightConvertable.measurement)
        XCTAssertTrue(ratio.volume == 1)
        XCTAssertTrue(ratio.weight == 1)
    }
    
    func testOneToTwoRatio() {
        volumeConvertable.measurement.amount = 2
        volumeConvertable.measurement.unit = .fluidOunce
        weightConvertable.measurement.amount = 4
        weightConvertable.measurement.unit = .ounce
        
        let ratio = try! Ratio.makeRatio(volume: volumeConvertable.measurement, weight: weightConvertable.measurement)
        XCTAssertTrue(ratio.volume == 1)
        XCTAssertTrue(ratio.weight == 2)
    }
    
    func testTwoToOneRatio() {
        volumeConvertable.measurement.amount = 4
        volumeConvertable.measurement.unit = .fluidOunce
        weightConvertable.measurement.amount = 2
        weightConvertable.measurement.unit = .ounce
        
        let ratio = try! Ratio.makeRatio(volume: volumeConvertable.measurement, weight: weightConvertable.measurement)
        XCTAssertTrue(ratio.volume == 2)
        XCTAssertTrue(ratio.weight == 1)
    }
}
