//
//  LooseConversionTests.swift
//  miseenplace
//
//  Created by Richard Piazza on 8/5/15.
//  Copyright (c) 2015 Richard Piazza. All rights reserved.
//

import Foundation
import XCTest
@testable import MiseEnPlace

class LooseConversionTests: XCTestCase {
    var ingredient: ConvertableIngredient = ConvertableIngredient()

    override func setUp() {
        super.setUp()
        
        ingredient.ratio.weight = 1
        ingredient.ratio.volume = 1
        
        MiseEnPlace.Configuration.useLooseConversions = true
    }
    
    override func tearDown() {
        MiseEnPlace.Configuration.useLooseConversions = false
        
        super.tearDown()
    }

    func testEqualRatioMeasurementAmountFor() {
        ingredient.measurement.amount = 1
        ingredient.measurement.unit = .gallon
        
        let gallon = try! ingredient.amount(for: .gallon)
        XCTAssertTrue(gallon == 1)
        
        let quart = try! ingredient.amount(for: .quart)
        XCTAssertTrue(quart == 4)
        
        let pint = try! ingredient.amount(for: .pint)
        XCTAssertTrue(pint == 8)
        
        let cup = try! ingredient.amount(for: .cup)
        XCTAssertTrue(cup == 16)
        
        let fluidOunce = try! ingredient.amount(for: .fluidOunce)
        XCTAssertTrue(fluidOunce == 128)
        
        let tableSpoon = try! ingredient.amount(for: .tablespoon)
        XCTAssertTrue(tableSpoon == 256)
        
        let teaspoon = try! ingredient.amount(for: .teaspoon)
        XCTAssertTrue(teaspoon.equals(768, precision: 0))
        
        let dash = try! ingredient.amount(for: .dash)
        XCTAssertTrue(dash.equals(6144, precision: 0))
        
        let pinch = try! ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.equals(12288, precision: 0))
        
        let ounce = try! ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce == 128)
        
        let pound = try! ingredient.amount(for: .pound)
        XCTAssertTrue(pound == 8)
        
        let milliliter = try! ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.equals(3840, precision: 0))
        
        let liter = try! ingredient.amount(for: .liter)
        XCTAssertTrue(liter.equals(3.84, precision: 2))
        
        let gram = try! ingredient.amount(for: .gram)
        XCTAssertTrue(gram.equals(3840, precision: 0))
        
        let kilogram = try! ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.equals(3.84, precision: 2))
    }
    
    func testEqualRatioScaleUSMassToUSMass() {
        ingredient.measurement.amount = 2
        ingredient.measurement.unit = .pound
        
        let scaleMeasure = try! ingredient.scale(by: 0.25, measurementSystemMethod: .usWeight)
        XCTAssertTrue(scaleMeasure.amount == 8)
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testEqualRatioScaleUSMassToUSVolume() {
        ingredient.measurement.amount = 0.5
        ingredient.measurement.unit = .pound
        
        let scaleMeasure = try! ingredient.scale(by: 1.25, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(1.25, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .cup)
    }
    
    func testEqualRatioScaleUSMassToMetricMass() {
        ingredient.measurement.amount = 10
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = try! ingredient.scale(by: 1.0, measurementSystemMethod: .metricWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(300, precision: 0))
        XCTAssertTrue(scaleMeasure.unit == .gram)
    }
    
    func testEqualRatioScaleUSMassToMetricVolume() {
        ingredient.measurement.amount = 4
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = try! ingredient.scale(by: 2.0, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(240, precision: 0))
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testEqualRatioScaleUSVolumeToUSMass() {
        ingredient.measurement.amount = 4
        ingredient.measurement.unit = .tablespoon
        
        let scaleMeasure = try! ingredient.scale(by: 3.5, measurementSystemMethod: .usWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(7, precision: 0))
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testEqualRatioScaleUSVolumeToUSVolume() {
        ingredient.measurement.amount = 28
        ingredient.measurement.unit = .quart
        
        let scaleMeasure = try! ingredient.scale(by: Fraction.oneSixteenth.rawValue, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(1.75, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .quart)
    }
    
    func testEqualRatioScaleUSVolumeToMetricMass() {
        ingredient.measurement.amount = 1
        ingredient.measurement.unit = .gallon
        
        let scaleMeasure = try! ingredient.scale(by: 1.75, measurementSystemMethod: .metricWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(6.72, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testEqualRatioScaleUSVolumeToMetricVolume() {
        ingredient.measurement.amount = 1.3
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = try! ingredient.scale(by: 3.0, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(117, precision: 0))
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testEqualRatioScaleMetricMassToUSMass() {
        ingredient.measurement.amount = 250
        ingredient.measurement.unit = .gram
        
        let scaleMeasure = try! ingredient.scale(by: Fraction.oneHalf.rawValue, measurementSystemMethod: .usWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(4.17, precision: 0))
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testEqualRatioScaleMetricMassToUSVolume() {
        ingredient.measurement.amount = 1.68
        ingredient.measurement.unit = .kilogram
        
        let scaleMeasure = try! ingredient.scale(by: 1.0, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(1.75, precision: 0))
        XCTAssertTrue(scaleMeasure.unit == .quart)
    }
    
    func testEqualRatioScaleMetricMassToMetricMass() {
        ingredient.measurement.amount = 22
        ingredient.measurement.unit = .kilogram
        
        let scaleMeasure = try! ingredient.scale(by: Fraction.oneThird.rawValue, measurementSystemMethod: .metricWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(7.33, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testEqualRatioScaleMetricMassToMetricVolume() {
        ingredient.measurement.amount = 888.888
        ingredient.measurement.unit = .gram
        
        let scaleMeasure = try! ingredient.scale(by: Fraction.twoThirds.rawValue, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(592.59, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testEqualRatioScaleMetricVolumeToUSMass() {
        ingredient.measurement.amount = 130
        ingredient.measurement.unit = .milliliter
        
        let scaleMeasure = try! ingredient.scale(by: 1.01, measurementSystemMethod: .usWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(4.38, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testEqualRatioScaleMetricVolumeToUSVolume() {
        ingredient.measurement.amount = 2.99
        ingredient.measurement.unit = .liter
        
        let scaleMeasure = try! ingredient.scale(by: Fraction.oneSixth.rawValue, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(1.04, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .pint)
    }
    
    func testEqualRatioScaleMetricVolumeToMetricMass() {
        ingredient.measurement.amount = 45
        ingredient.measurement.unit = .liter
        
        let scaleMeasure = try! ingredient.scale(by: 1.0, measurementSystemMethod: .metricWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(45, precision: 0))
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testEqualRatioScaleMetricVolumeToMetricVolume() {
        ingredient.measurement.amount = 45000
        ingredient.measurement.unit = .milliliter
        
        let scaleMeasure = try! ingredient.scale(by: Fraction.oneThousandth.rawValue, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(45, precision: 0))
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
}
