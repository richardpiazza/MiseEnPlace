//
//  equalRatioIngredientTests.swift
//  miseenplace
//
//  Created by Richard Piazza on 8/3/15.
//  Copyright (c) 2015 Richard Piazza. All rights reserved.
//

import Foundation
import XCTest
@testable import MiseEnPlace

class EqualRatioIngredientTests: XCTestCase {
    let ingredient: ConvertableIngredient = ConvertableIngredient()

    override func setUp() {
        super.setUp()
        
        ingredient.ratio.volume = 1
        ingredient.ratio.mass = 1
    }
    
    override func tearDown() {
        
        super.tearDown()
    }

    func testMeasurementAmountForUSVolume() {
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
        XCTAssertTrue(teaspoon.equals(value: 768, precision: 2))
        
        let dash = ingredient.amount(for: .dash)
        XCTAssertTrue(dash.integerValue == 6144)
        
        let pinch = ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.integerValue == 12288)
        
        let ounce = ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce == 128)
        
        let pound = ingredient.amount(for: .pound)
        XCTAssertTrue(pound == 8)
        
        let milliliter = ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 3785.41)
        
        let liter = ingredient.amount(for: .liter)
        XCTAssertTrue(liter.twoDecimalValue == 3.79)
        
        let gram = ingredient.amount(for: .gram)
        XCTAssertTrue(gram.twoDecimalValue == 3628.74)
        
        let kilogram = ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.twoDecimalValue == 3.63)
    }
    
    func testMeasurementAmountForUSMass() {
        ingredient.measurement.amount = 5
        ingredient.measurement.unit = .pound
        
        let gallon = ingredient.amount(for: .gallon)
        XCTAssertTrue(gallon.twoDecimalValue == 0.62)
        
        let quart = ingredient.amount(for: .quart)
        XCTAssertTrue(quart.twoDecimalValue == 2.5)
        
        let pint = ingredient.amount(for: .pint)
        XCTAssertTrue(pint.twoDecimalValue == 5)
        
        let cup = ingredient.amount(for: .cup)
        XCTAssertTrue(cup.twoDecimalValue == 10)
        
        let fluidOunce = ingredient.amount(for: .fluidOunce)
        XCTAssertTrue(fluidOunce.twoDecimalValue == 80)
        
        let tableSpoon = ingredient.amount(for: .tablespoon)
        XCTAssertTrue(tableSpoon.twoDecimalValue == 160)
        
        let teaspoon = ingredient.amount(for: .teaspoon)
        XCTAssertTrue(teaspoon.twoDecimalValue == 480)
        
        let dash = ingredient.amount(for: .dash)
        XCTAssertTrue(dash.twoDecimalValue == 3840)
        
        let pinch = ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.twoDecimalValue == 7680)
        
        let ounce = ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce.twoDecimalValue == 80)
        
        let pound = ingredient.amount(for: .pound)
        XCTAssertTrue(pound.twoDecimalValue == 5)
        
        let milliliter = ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 2365.88)
        
        let liter = ingredient.amount(for: .liter)
        XCTAssertTrue(liter.twoDecimalValue == 2.37)
        
        let gram = ingredient.amount(for: .gram)
        XCTAssertTrue(gram.twoDecimalValue == 2267.96)
        
        let kilogram = ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.twoDecimalValue == 2.27)
    }
    
    func testMeasurementAmountForMetricVolume() {
        ingredient.measurement.amount = 750
        ingredient.measurement.unit = .milliliter
        
        let gallon = ingredient.amount(for: .gallon)
        XCTAssertTrue(gallon.twoDecimalValue == 0.20)
        
        let quart = ingredient.amount(for: .quart)
        XCTAssertTrue(quart.twoDecimalValue == 0.79)
        
        let pint = ingredient.amount(for: .pint)
        XCTAssertTrue(pint.twoDecimalValue == 1.59)
        
        let cup = ingredient.amount(for: .cup)
        XCTAssertTrue(cup.twoDecimalValue == 3.17)
        
        let fluidOunce = ingredient.amount(for: .fluidOunce)
        XCTAssertTrue(fluidOunce.twoDecimalValue == 25.36)
        
        let tableSpoon = ingredient.amount(for: .tablespoon)
        XCTAssertTrue(tableSpoon.twoDecimalValue == 50.72)
        
        let teaspoon = ingredient.amount(for: .teaspoon)
        XCTAssertTrue(teaspoon.twoDecimalValue == 152.16)
        
        let dash = ingredient.amount(for: .dash)
        XCTAssertTrue(dash.twoDecimalValue == 1217.30)
        
        let pinch = ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.twoDecimalValue == 2434.61)
        
        let ounce = ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce.twoDecimalValue == 26.46)
        
        let pound = ingredient.amount(for: .pound)
        XCTAssertTrue(pound.twoDecimalValue == 1.65)
        
        let milliliter = ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 750)
        
        let liter = ingredient.amount(for: .liter)
        XCTAssertTrue(liter.twoDecimalValue == 0.75)
        
        let gram = ingredient.amount(for: .gram)
        XCTAssertTrue(gram.twoDecimalValue == 750)
        
        let kilogram = ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.twoDecimalValue == 0.75)
    }
    
    func testMeasurementAmountForMetricMass() {
        ingredient.measurement.amount = 2.5
        ingredient.measurement.unit = .kilogram
        
        let gallon = ingredient.amount(for: .gallon)
        XCTAssertTrue(gallon.twoDecimalValue == 0.66)
        
        let quart = ingredient.amount(for: .quart)
        XCTAssertTrue(quart.twoDecimalValue == 2.64)
        
        let pint = ingredient.amount(for: .pint)
        XCTAssertTrue(pint.twoDecimalValue == 5.28)
        
        let cup = ingredient.amount(for: .cup)
        XCTAssertTrue(cup.twoDecimalValue == 10.57)
        
        let fluidOunce = ingredient.amount(for: .fluidOunce)
        XCTAssertTrue(fluidOunce.twoDecimalValue == 84.54)
        
        let tableSpoon = ingredient.amount(for: .tablespoon)
        XCTAssertTrue(tableSpoon.twoDecimalValue == 169.07)
        
        let teaspoon = ingredient.amount(for: .teaspoon)
        XCTAssertTrue(teaspoon.twoDecimalValue == 507.21)
        
        let dash = ingredient.amount(for: .dash)
        XCTAssertTrue(dash.twoDecimalValue == 4057.68)
        
        let pinch = ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.twoDecimalValue == 8115.37)
        
        let ounce = ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce.twoDecimalValue == 88.18)
        
        let pound = ingredient.amount(for: .pound)
        XCTAssertTrue(pound.twoDecimalValue == 5.51)
        
        let milliliter = ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 2500)
        
        let liter = ingredient.amount(for: .liter)
        XCTAssertTrue(liter.twoDecimalValue == 2.5)
        
        let gram = ingredient.amount(for: .gram)
        XCTAssertTrue(gram.twoDecimalValue == 2500)
        
        let kilogram = ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.twoDecimalValue == 2.5)
    }
    
    func testScaleUSMassToUSMass() {
        ingredient.measurement.amount = 2
        ingredient.measurement.unit = .pound
        
        let scaleMeasure = ingredient.scale(by: 0.25, measurementSystemMethod: .usMass)
        XCTAssertTrue(scaleMeasure.amount == 8)
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleUSMassToUSVolume() {
        ingredient.measurement.amount = 0.5
        ingredient.measurement.unit = .pound
        
        let scaleMeasure = ingredient.scale(by: 1.25, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.25)
        XCTAssertTrue(scaleMeasure.unit == .cup)
    }
    
    func testScaleUSMassToMetricMass() {
        ingredient.measurement.amount = 10
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = ingredient.scale(by: 1.0, measurementSystemMethod: .metricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 283.50)
        XCTAssertTrue(scaleMeasure.unit == .gram)
    }
    
    func testScaleUSMassToMetricVolume() {
        ingredient.measurement.amount = 4
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = ingredient.scale(by: 2.0, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 236.59)
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testScaleUSVolumeToUSMass() {
        ingredient.measurement.amount = 4
        ingredient.measurement.unit = .tablespoon
        
        let scaleMeasure = ingredient.scale(by: 3.5, measurementSystemMethod: .usMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 7)
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleUSVolumeToUSVolume() {
        ingredient.measurement.amount = 28
        ingredient.measurement.unit = .quart
        
        let scaleMeasure = ingredient.scale(by: Constants.OneSixteenth, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.75)
        XCTAssertTrue(scaleMeasure.unit == .quart)
    }
    
    func testScaleUSVolumeToMetricMass() {
        ingredient.measurement.amount = 1
        ingredient.measurement.unit = .gallon
        
        let scaleMeasure = ingredient.scale(by: 1.75, measurementSystemMethod: .metricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 6.35)
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testScaleUSVolumeToMetricVolume() {
        ingredient.measurement.amount = 1.3
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = ingredient.scale(by: 3.0, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 115.34)
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testScaleMetricMassToUSMass() {
        ingredient.measurement.amount = 250
        ingredient.measurement.unit = .gram
        
        let scaleMeasure = ingredient.scale(by: Constants.OneHalf, measurementSystemMethod: .usMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 4.41)
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleMetricMassToUSVolume() {
        ingredient.measurement.amount = 1.68
        ingredient.measurement.unit = .kilogram
        
        let scaleMeasure = ingredient.scale(by: 1.0, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.78)
        XCTAssertTrue(scaleMeasure.unit == .quart)
    }
    
    func testScaleMetricMassToMetricMass() {
        ingredient.measurement.amount = 22
        ingredient.measurement.unit = .kilogram
        
        let scaleMeasure = ingredient.scale(by: Constants.OneThird, measurementSystemMethod: .metricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 7.33)
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testScaleMetricMassToMetricVolume() {
        ingredient.measurement.amount = 888.888
        ingredient.measurement.unit = .gram
        
        let scaleMeasure = ingredient.scale(by: Constants.TwoThirds, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 592.59)
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testScaleMetricVolumeToUSMass() {
        ingredient.measurement.amount = 130
        ingredient.measurement.unit = .milliliter
        
        let scaleMeasure = ingredient.scale(by: 1.01, measurementSystemMethod: .usMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 4.63)
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleMetricVolumeToUSVolume() {
        ingredient.measurement.amount = 2.99
        ingredient.measurement.unit = .liter
        
        let scaleMeasure = ingredient.scale(by: Constants.OneSixth, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.05)
        XCTAssertTrue(scaleMeasure.unit == .pint)
    }
    
    func testScaleMetricVolumeToMetricMass() {
        ingredient.measurement.amount = 45
        ingredient.measurement.unit = .liter
        
        let scaleMeasure = ingredient.scale(by: 1.0, measurementSystemMethod: .metricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 45)
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testScaleMetricVolumeToMetricVolume() {
        ingredient.measurement.amount = 45000
        ingredient.measurement.unit = .milliliter
        
        let scaleMeasure = ingredient.scale(by: Constants.OneThousandth, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 45)
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
}
