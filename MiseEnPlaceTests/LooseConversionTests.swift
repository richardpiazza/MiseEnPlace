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
        
        ingredient.ratio.mass = 1
        ingredient.ratio.volume = 1
        
        Multipliers.useLooseConversions = true
    }
    
    override func tearDown() {
        Multipliers.useLooseConversions = false
        
        super.tearDown()
    }

    func testEqualRatioMeasurementAmountFor() {
        ingredient.measurement.amount = 1
        ingredient.measurement.unit = .gallon
        
        let gallon = ingredient.amount(for: .gallon)
        XCTAssertTrue(gallon == 1)
        
        let quart = ingredient.amount(for: .quart)
        XCTAssertTrue(quart == 4)
        
        let pint = ingredient.amount(for: .pint)
        XCTAssertTrue(pint == 8)
        
        let cup = ingredient.amount(for: .cup)
        XCTAssertTrue(cup == 16)
        
        let fluidOunce = ingredient.amount(for: .fluidOunce)
        XCTAssertTrue(fluidOunce == 128)
        
        let tableSpoon = ingredient.amount(for: .tablespoon)
        XCTAssertTrue(tableSpoon == 256)
        
        let teaspoon = ingredient.amount(for: .teaspoon)
        XCTAssertTrue(teaspoon.integerValue == 768)
        
        let dash = ingredient.amount(for: .dash)
        XCTAssertTrue(dash.integerValue == 6144)
        
        let pinch = ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.integerValue == 12288)
        
        let ounce = ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce == 128)
        
        let pound = ingredient.amount(for: .pound)
        XCTAssertTrue(pound == 8)
        
        let milliliter = ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 3840)
        
        let liter = ingredient.amount(for: .liter)
        XCTAssertTrue(liter.twoDecimalValue == 3.84)
        
        let gram = ingredient.amount(for: .gram)
        XCTAssertTrue(gram.twoDecimalValue == 3840)
        
        let kilogram = ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.twoDecimalValue == 3.84)
    }
    
    func testEqualRatioScaleUSMassToUSMass() {
        ingredient.measurement.amount = 2
        ingredient.measurement.unit = .pound
        
        let scaleMeasure = ingredient.scale(by: 0.25, measurementSystemMethod: .usMass)
        XCTAssertTrue(scaleMeasure.amount == 8)
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testEqualRatioScaleUSMassToUSVolume() {
        ingredient.measurement.amount = 0.5
        ingredient.measurement.unit = .pound
        
        let scaleMeasure = ingredient.scale(by: 1.25, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.25)
        XCTAssertTrue(scaleMeasure.unit == .cup)
    }
    
    func testEqualRatioScaleUSMassToMetricMass() {
        ingredient.measurement.amount = 10
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = ingredient.scale(by: 1.0, measurementSystemMethod: .metricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 300)
        XCTAssertTrue(scaleMeasure.unit == .gram)
    }
    
    func testEqualRatioScaleUSMassToMetricVolume() {
        ingredient.measurement.amount = 4
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = ingredient.scale(by: 2.0, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 240)
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testEqualRatioScaleUSVolumeToUSMass() {
        ingredient.measurement.amount = 4
        ingredient.measurement.unit = .tablespoon
        
        let scaleMeasure = ingredient.scale(by: 3.5, measurementSystemMethod: .usMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 7)
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testEqualRatioScaleUSVolumeToUSVolume() {
        ingredient.measurement.amount = 28
        ingredient.measurement.unit = .quart
        
        let scaleMeasure = ingredient.scale(by: MiseEnPlace.Fractions.oneSixteenth, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.75)
        XCTAssertTrue(scaleMeasure.unit == .quart)
    }
    
    func testEqualRatioScaleUSVolumeToMetricMass() {
        ingredient.measurement.amount = 1
        ingredient.measurement.unit = .gallon
        
        let scaleMeasure = ingredient.scale(by: 1.75, measurementSystemMethod: .metricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 6.72)
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testEqualRatioScaleUSVolumeToMetricVolume() {
        ingredient.measurement.amount = 1.3
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = ingredient.scale(by: 3.0, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 117)
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testEqualRatioScaleMetricMassToUSMass() {
        ingredient.measurement.amount = 250
        ingredient.measurement.unit = .gram
        
        let scaleMeasure = ingredient.scale(by: MiseEnPlace.Fractions.oneHalf, measurementSystemMethod: .usMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 4.17)
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testEqualRatioScaleMetricMassToUSVolume() {
        ingredient.measurement.amount = 1.68
        ingredient.measurement.unit = .kilogram
        
        let scaleMeasure = ingredient.scale(by: 1.0, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.75)
        XCTAssertTrue(scaleMeasure.unit == .quart)
    }
    
    func testEqualRatioScaleMetricMassToMetricMass() {
        ingredient.measurement.amount = 22
        ingredient.measurement.unit = .kilogram
        
        let scaleMeasure = ingredient.scale(by: MiseEnPlace.Fractions.oneThird, measurementSystemMethod: .metricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 7.33)
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testEqualRatioScaleMetricMassToMetricVolume() {
        ingredient.measurement.amount = 888.888
        ingredient.measurement.unit = .gram
        
        let scaleMeasure = ingredient.scale(by: MiseEnPlace.Fractions.twoThirds, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 592.59)
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testEqualRatioScaleMetricVolumeToUSMass() {
        ingredient.measurement.amount = 130
        ingredient.measurement.unit = .milliliter
        
        let scaleMeasure = ingredient.scale(by: 1.01, measurementSystemMethod: .usMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 4.38)
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testEqualRatioScaleMetricVolumeToUSVolume() {
        ingredient.measurement.amount = 2.99
        ingredient.measurement.unit = .liter
        
        let scaleMeasure = ingredient.scale(by: MiseEnPlace.Fractions.oneSixth, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.04)
        XCTAssertTrue(scaleMeasure.unit == .pint)
    }
    
    func testEqualRatioScaleMetricVolumeToMetricMass() {
        ingredient.measurement.amount = 45
        ingredient.measurement.unit = .liter
        
        let scaleMeasure = ingredient.scale(by: 1.0, measurementSystemMethod: .metricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 45)
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testEqualRatioScaleMetricVolumeToMetricVolume() {
        ingredient.measurement.amount = 45000
        ingredient.measurement.unit = .milliliter
        
        let scaleMeasure = ingredient.scale(by: MiseEnPlace.Fractions.oneThousandth, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 45)
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
}
