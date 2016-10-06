//
//  highVolumeRatioIngredientTests.swift
//  miseenplace
//
//  Created by Richard Piazza on 8/4/15.
//  Copyright (c) 2015 Richard Piazza. All rights reserved.
//

import UIKit
import XCTest
@testable import MiseEnPlace

class HighVolumeRatioIngredientTests: XCTestCase {
    var ingredient: ConvertableIngredient = ConvertableIngredient()

    override func setUp() {
        super.setUp()
        
        ingredient.ratio.volume = 1.14
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
        XCTAssertTrue(teaspoon.equals(768, precision: 0))
        
        let dash = ingredient.amount(for: .dash)
        XCTAssertTrue(dash.equals(6144, precision: 0))
        
        let pinch = ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.equals(12288, precision: 0))
        
        let ounce = ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce.equals(112.28, precision: 2))
        
        let pound = ingredient.amount(for: .pound)
        XCTAssertTrue(pound.equals(7.02, precision: 2))
        
        let milliliter = ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.equals(3785.41, precision: 2))
        
        let liter = ingredient.amount(for: .liter)
        XCTAssertTrue(liter.equals(3.79, precision: 2))
        
        let gram = ingredient.amount(for: .gram)
        XCTAssertTrue(gram.equals(3183.10, precision: 2))
        
        let kilogram = ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.equals(3.18, precision: 2))
    }
    
    func testMeasurementAmountForUSMass() {
        ingredient.measurement.amount = 5
        ingredient.measurement.unit = .pound
        
        let gallon = ingredient.amount(for: .gallon)
        XCTAssertTrue(gallon.equals(0.71, precision: 2))
        
        let quart = ingredient.amount(for: .quart)
        XCTAssertTrue(quart.equals(2.85, precision: 2))
        
        let pint = ingredient.amount(for: .pint)
        XCTAssertTrue(pint.equals(5.70, precision: 2))
        
        let cup = ingredient.amount(for: .cup)
        XCTAssertTrue(cup.equals(11.40, precision: 2))
        
        let fluidOunce = ingredient.amount(for: .fluidOunce)
        XCTAssertTrue(fluidOunce.equals(91.20, precision: 2))
        
        let tableSpoon = ingredient.amount(for: .tablespoon)
        XCTAssertTrue(tableSpoon.equals(182.40, precision: 2))
        
        let teaspoon = ingredient.amount(for: .teaspoon)
        XCTAssertTrue(teaspoon.equals(547.20, precision: 2))
        
        let dash = ingredient.amount(for: .dash)
        XCTAssertTrue(dash.equals(4377.60, precision: 2))
        
        let pinch = ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.equals(8755.20, precision: 2))
        
        let ounce = ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce.equals(80, precision: 0))
        
        let pound = ingredient.amount(for: .pound)
        XCTAssertTrue(pound.equals(5, precision: 0))
        
        let milliliter = ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.equals(2697.11, precision: 2))
        
        let liter = ingredient.amount(for: .liter)
        XCTAssertTrue(liter.equals(2.70, precision: 2))
        
        let gram = ingredient.amount(for: .gram)
        XCTAssertTrue(gram.equals(2267.96, precision: 2))
        
        let kilogram = ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.equals(2.27, precision: 2))
    }
    
    func testMeasurementAmountForMetricVolume() {
        ingredient.measurement.amount = 750
        ingredient.measurement.unit = .milliliter
        
        let gallon = ingredient.amount(for: .gallon)
        XCTAssertTrue(gallon.equals(0.20, precision: 2))
        
        let quart = ingredient.amount(for: .quart)
        XCTAssertTrue(quart.equals(0.79, precision: 2))
        
        let pint = ingredient.amount(for: .pint)
        XCTAssertTrue(pint.equals(1.59, precision: 2))
        
        let cup = ingredient.amount(for: .cup)
        XCTAssertTrue(cup.equals(3.17, precision: 2))
        
        let fluidOunce = ingredient.amount(for: .fluidOunce)
        XCTAssertTrue(fluidOunce.equals(25.36, precision: 2))
        
        let tableSpoon = ingredient.amount(for: .tablespoon)
        XCTAssertTrue(tableSpoon.equals(50.72, precision: 2))
        
        let teaspoon = ingredient.amount(for: .teaspoon)
        XCTAssertTrue(teaspoon.equals(152.16, precision: 2))
        
        let dash = ingredient.amount(for: .dash)
        XCTAssertTrue(dash.equals(1217.30, precision: 2))
        
        let pinch = ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.equals(2434.61, precision: 2))
        
        let ounce = ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce.equals(23.21, precision: 2))
        
        let pound = ingredient.amount(for: .pound)
        XCTAssertTrue(pound.equals(1.45, precision: 2))
        
        let milliliter = ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.equals(750, precision: 0))
        
        let liter = ingredient.amount(for: .liter)
        XCTAssertTrue(liter.equals(0.75, precision: 2))
        
        let gram = ingredient.amount(for: .gram)
        XCTAssertTrue(gram.equals(657.89, precision: 2))
        
        let kilogram = ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.equals(0.66, precision: 2))
    }
    
    func testMeasurementAmountForMetricMass() {
        ingredient.measurement.amount = 2.5
        ingredient.measurement.unit = .kilogram
        
        let gallon = ingredient.amount(for: .gallon)
        XCTAssertTrue(gallon.equals(0.75, precision: 2))
        
        let quart = ingredient.amount(for: .quart)
        XCTAssertTrue(quart.equals(3.01, precision: 2))
        
        let pint = ingredient.amount(for: .pint)
        XCTAssertTrue(pint.equals(6.02, precision: 2))
        
        let cup = ingredient.amount(for: .cup)
        XCTAssertTrue(cup.equals(12.05, precision: 2))
        
        let fluidOunce = ingredient.amount(for: .fluidOunce)
        XCTAssertTrue(fluidOunce.equals(96.37, precision: 2))
        
        let tableSpoon = ingredient.amount(for: .tablespoon)
        XCTAssertTrue(tableSpoon.equals(192.74, precision: 2))
        
        let teaspoon = ingredient.amount(for: .teaspoon)
        XCTAssertTrue(teaspoon.equals(578.22, precision: 2))
        
        let dash = ingredient.amount(for: .dash)
        XCTAssertTrue(dash.equals(4625.76, precision: 2))
        
        let pinch = ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.equals(9251.52, precision: 2))
        
        let ounce = ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce.equals(88.18, precision: 2))
        
        let pound = ingredient.amount(for: .pound)
        XCTAssertTrue(pound.equals(5.51, precision: 2))
        
        let milliliter = ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.equals(2850, precision: 2))
        
        let liter = ingredient.amount(for: .liter)
        XCTAssertTrue(liter.equals(2.85, precision: 2))
        
        let gram = ingredient.amount(for: .gram)
        XCTAssertTrue(gram.equals(2500, precision: 0))
        
        let kilogram = ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.equals(2.5, precision: 1))
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
        XCTAssertTrue(scaleMeasure.amount.equals(1.42, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .cup)
    }
    
    func testScaleUSMassToMetricMass() {
        ingredient.measurement.amount = 10
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = ingredient.scale(by: 1.0, measurementSystemMethod: .metricMass)
        XCTAssertTrue(scaleMeasure.amount.equals(283.50, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .gram)
    }
    
    func testScaleUSMassToMetricVolume() {
        ingredient.measurement.amount = 4
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = ingredient.scale(by: 2.0, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(269.71, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }

    func testScaleUSVolumeToUSMass() {
        ingredient.measurement.amount = 4
        ingredient.measurement.unit = .tablespoon
        
        let scaleMeasure = ingredient.scale(by: 3.5, measurementSystemMethod: .usMass)
        XCTAssertTrue(scaleMeasure.amount.equals(6.14, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleUSVolumeToUSVolume() {
        ingredient.measurement.amount = 28
        ingredient.measurement.unit = .quart
        
        let scaleMeasure = ingredient.scale(by: Fractions.oneSixteenth, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(1.75, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .quart)
    }
    
    func testScaleUSVolumeToMetricMass() {
        ingredient.measurement.amount = 1
        ingredient.measurement.unit = .gallon
        
        let scaleMeasure = ingredient.scale(by: 1.75, measurementSystemMethod: .metricMass)
        XCTAssertTrue(scaleMeasure.amount.equals(5.57, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testScaleUSVolumeToMetricVolume() {
        ingredient.measurement.amount = 1.3
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = ingredient.scale(by: 3.0, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(131.48, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testScaleMetricMassToUSMass() {
        ingredient.measurement.amount = 250
        ingredient.measurement.unit = .gram
        
        let scaleMeasure = ingredient.scale(by: Fractions.oneHalf, measurementSystemMethod: .usMass)
        XCTAssertTrue(scaleMeasure.amount.equals(4.41, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleMetricMassToUSVolume() {
        ingredient.measurement.amount = 1.68
        ingredient.measurement.unit = .kilogram
        
        let scaleMeasure = ingredient.scale(by: 1.0, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(2.02, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .quart)
    }
    
    func testScaleMetricMassToMetricMass() {
        ingredient.measurement.amount = 22
        ingredient.measurement.unit = .kilogram
        
        let scaleMeasure = ingredient.scale(by: Fractions.oneThird, measurementSystemMethod: .metricMass)
        XCTAssertTrue(scaleMeasure.amount.equals(7.33, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testScaleMetricMassToMetricVolume() {
        ingredient.measurement.amount = 888.888
        ingredient.measurement.unit = .gram
        
        let scaleMeasure = ingredient.scale(by: Fractions.twoThirds, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(675.55, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testScaleMetricVolumeToUSMass() {
        ingredient.measurement.amount = 130
        ingredient.measurement.unit = .milliliter
        
        let scaleMeasure = ingredient.scale(by: 1.01, measurementSystemMethod: .usMass)
        XCTAssertTrue(scaleMeasure.amount.equals(4.06, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleMetricVolumeToUSVolume() {
        ingredient.measurement.amount = 2.99
        ingredient.measurement.unit = .liter
        
        let scaleMeasure = ingredient.scale(by: Fractions.oneSixth, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(1.05, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .pint)
    }
    
    func testScaleMetricVolumeToMetricMass() {
        ingredient.measurement.amount = 45
        ingredient.measurement.unit = .liter
        
        let scaleMeasure = ingredient.scale(by: 1.0, measurementSystemMethod: .metricMass)
        XCTAssertTrue(scaleMeasure.amount.equals(39.47, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testScaleMetricVolumeToMetricVolume() {
        ingredient.measurement.amount = 45000
        ingredient.measurement.unit = .milliliter
        
        let scaleMeasure = ingredient.scale(by: Fractions.oneThousandth, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(45, precision: 0))
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
}
