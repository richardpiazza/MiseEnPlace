//
//  highMassRatioIngredientTests.swift
//  miseenplace
//
//  Created by Richard Piazza on 8/4/15.
//  Copyright (c) 2015 Richard Piazza. All rights reserved.
//

import UIKit
import XCTest
@testable import MiseEnPlace

class HighMassRatioIngredientTests: XCTestCase {
    var ingredient: ConvertableIngredient = ConvertableIngredient()

    override func setUp() {
        super.setUp()
        
        ingredient.ratio.mass = 1.42
        ingredient.ratio.volume = 1
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
        XCTAssertTrue(teaspoon.integerValue == 768)
        
        let dash = ingredient.amount(for: .dash)
        XCTAssertTrue(dash.integerValue == 6144)
        
        let pinch = ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.integerValue == 12288)
        
        let ounce = ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce.twoDecimalValue == 181.76)
        
        let pound = ingredient.amount(for: .pound)
        XCTAssertTrue(pound.twoDecimalValue == 11.36)
        
        let milliliter = ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 3785.41)
        
        let liter = ingredient.amount(for: .liter)
        XCTAssertTrue(liter.twoDecimalValue == 3.79)
        
        let gram = ingredient.amount(for: .gram)
        XCTAssertTrue(gram.twoDecimalValue == 5152.81)
        
        let kilogram = ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.twoDecimalValue == 5.15)
    }
    
    func testMeasurementAmountForUSMass() {
        ingredient.measurement.amount = 5
        ingredient.measurement.unit = .pound
        
        let gallon = ingredient.amount(for: .gallon)
        XCTAssertTrue(gallon.twoDecimalValue == 0.44)
        
        let quart = ingredient.amount(for: .quart)
        XCTAssertTrue(quart.twoDecimalValue == 1.76)
        
        let pint = ingredient.amount(for: .pint)
        XCTAssertTrue(pint.twoDecimalValue == 3.52)
        
        let cup = ingredient.amount(for: .cup)
        XCTAssertTrue(cup.twoDecimalValue == 7.04)
        
        let fluidOunce = ingredient.amount(for: .fluidOunce)
        XCTAssertTrue(fluidOunce.twoDecimalValue == 56.34)
        
        let tableSpoon = ingredient.amount(for: .tablespoon)
        XCTAssertTrue(tableSpoon.twoDecimalValue == 112.68)
        
        let teaspoon = ingredient.amount(for: .teaspoon)
        XCTAssertTrue(teaspoon.twoDecimalValue == 338.03)
        
        let dash = ingredient.amount(for: .dash)
        XCTAssertTrue(dash.twoDecimalValue == 2704.23)
        
        let pinch = ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.twoDecimalValue == 5408.45)
        
        let ounce = ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce.twoDecimalValue == 80)
        
        let pound = ingredient.amount(for: .pound)
        XCTAssertTrue(pound.twoDecimalValue == 5)
        
        let milliliter = ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 1666.11)
        
        let liter = ingredient.amount(for: .liter)
        XCTAssertTrue(liter.twoDecimalValue == 1.67)
        
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
        XCTAssertTrue(ounce.twoDecimalValue == 37.57)
        
        let pound = ingredient.amount(for: .pound)
        XCTAssertTrue(pound.twoDecimalValue == 2.35)
        
        let milliliter = ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 750)
        
        let liter = ingredient.amount(for: .liter)
        XCTAssertTrue(liter.twoDecimalValue == 0.75)
        
        let gram = ingredient.amount(for: .gram)
        XCTAssertTrue(gram.twoDecimalValue == 1065)
        
        let kilogram = ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.twoDecimalValue == 1.07)
    }
    
    func testMeasurementAmountForMetricMass() {
        ingredient.measurement.amount = 2.5
        ingredient.measurement.unit = .kilogram
        
        let gallon = ingredient.amount(for: .gallon)
        XCTAssertTrue(gallon.twoDecimalValue == 0.47)
        
        let quart = ingredient.amount(for: .quart)
        XCTAssertTrue(quart.twoDecimalValue == 1.86)
        
        let pint = ingredient.amount(for: .pint)
        XCTAssertTrue(pint.twoDecimalValue == 3.72)
        
        let cup = ingredient.amount(for: .cup)
        XCTAssertTrue(cup.twoDecimalValue == 7.44)
        
        let fluidOunce = ingredient.amount(for: .fluidOunce)
        XCTAssertTrue(fluidOunce.twoDecimalValue == 59.53)
        
        let tableSpoon = ingredient.amount(for: .tablespoon)
        XCTAssertTrue(tableSpoon.twoDecimalValue == 119.06)
        
        let teaspoon = ingredient.amount(for: .teaspoon)
        XCTAssertTrue(teaspoon.twoDecimalValue == 357.19)
        
        let dash = ingredient.amount(for: .dash)
        XCTAssertTrue(dash.twoDecimalValue == 2857.52)
        
        let pinch = ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.twoDecimalValue == 5715.05)
        
        let ounce = ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce.twoDecimalValue == 88.18)
        
        let pound = ingredient.amount(for: .pound)
        XCTAssertTrue(pound.twoDecimalValue == 5.51)
        
        let milliliter = ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 1760.56)
        
        let liter = ingredient.amount(for: .liter)
        XCTAssertTrue(liter.twoDecimalValue == 1.76)
        
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
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 0.88)
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
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 166.61)
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testScaleUSVolumeToUSMass() {
        ingredient.measurement.amount = 4
        ingredient.measurement.unit = .tablespoon
        
        let scaleMeasure = ingredient.scale(by: 3.5, measurementSystemMethod: .usMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 9.94)
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleUSVolumeToUSVolume() {
        ingredient.measurement.amount = 28
        ingredient.measurement.unit = .quart
        
        let scaleMeasure = ingredient.scale(by: MiseEnPlace.Fractions.oneSixteenth, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.75)
        XCTAssertTrue(scaleMeasure.unit == .quart)
    }
    
    func testScaleUSVolumeToMetricMass() {
        ingredient.measurement.amount = 1
        ingredient.measurement.unit = .gallon
        
        let scaleMeasure = ingredient.scale(by: 1.75, measurementSystemMethod: .metricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 9.02)
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testScaleUSVolumeToMetricVolume() {
        ingredient.measurement.amount = 1.3
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = ingredient.scale(by: 3.0, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 81.22)
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testScaleMetricMassToUSMass() {
        ingredient.measurement.amount = 250
        ingredient.measurement.unit = .gram
        
        let scaleMeasure = ingredient.scale(by: MiseEnPlace.Fractions.oneHalf, measurementSystemMethod: .usMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 4.41)
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleMetricMassToUSVolume() {
        ingredient.measurement.amount = 1.68
        ingredient.measurement.unit = .kilogram
        
        let scaleMeasure = ingredient.scale(by: 1.0, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.25)
        XCTAssertTrue(scaleMeasure.unit == .quart)
    }
    
    func testScaleMetricMassToMetricMass() {
        ingredient.measurement.amount = 22
        ingredient.measurement.unit = .kilogram
        
        let scaleMeasure = ingredient.scale(by: MiseEnPlace.Fractions.oneThird, measurementSystemMethod: .metricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 7.33)
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testScaleMetricMassToMetricVolume() {
        ingredient.measurement.amount = 888.888
        ingredient.measurement.unit = .gram
        
        let scaleMeasure = ingredient.scale(by: MiseEnPlace.Fractions.twoThirds, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 417.32)
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testScaleMetricVolumeToUSMass() {
        ingredient.measurement.amount = 130
        ingredient.measurement.unit = .milliliter
        
        let scaleMeasure = ingredient.scale(by: 1.01, measurementSystemMethod: .usMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 6.58)
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleMetricVolumeToUSVolume() {
        ingredient.measurement.amount = 2.99
        ingredient.measurement.unit = .liter
        
        let scaleMeasure = ingredient.scale(by: MiseEnPlace.Fractions.oneSixth, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.05)
        XCTAssertTrue(scaleMeasure.unit == .pint)
    }
    
    func testScaleMetricVolumeToMetricMass() {
        ingredient.measurement.amount = 45
        ingredient.measurement.unit = .liter
        
        let scaleMeasure = ingredient.scale(by: 1.0, measurementSystemMethod: .metricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 63.90)
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testScaleMetricVolumeToMetricVolume() {
        ingredient.measurement.amount = 45000
        ingredient.measurement.unit = .milliliter
        
        let scaleMeasure = ingredient.scale(by: MiseEnPlace.Fractions.oneThousandth, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 45)
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
}
