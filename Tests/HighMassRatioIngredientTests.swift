//
//  highMassRatioIngredientTests.swift
//  miseenplace
//
//  Created by Richard Piazza on 8/4/15.
//  Copyright (c) 2015 Richard Piazza. All rights reserved.
//

import XCTest
@testable import MiseEnPlace

class HighMassRatioIngredientTests: XCTestCase {
    var ingredient: ConvertableIngredient = ConvertableIngredient()

    override func setUp() {
        super.setUp()
        
        ingredient.ratio.weight = 1.42
        ingredient.ratio.volume = 1
    }
    
    override func tearDown() {
        
        super.tearDown()
    }

    func testMeasurementAmountForUSVolume() {
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
        XCTAssertTrue(teaspoon.equals(768, precision: 2))
        
        let dash = try! ingredient.amount(for: .dash)
        XCTAssertTrue(dash.equals(6144, precision: 2))
        
        let pinch = try! ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.equals(12288, precision: 2))
        
        let ounce = try! ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce.equals(181.76, precision: 2))
        
        let pound = try! ingredient.amount(for: .pound)
        XCTAssertTrue(pound.equals(11.36, precision: 2))
        
        let milliliter = try! ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.equals(3785.41, precision: 2))
        
        let liter = try! ingredient.amount(for: .liter)
        XCTAssertTrue(liter.equals(3.79, precision: 2))
        
        let gram = try! ingredient.amount(for: .gram)
        XCTAssertTrue(gram.equals(5152.81, precision: 2))
        
        let kilogram = try! ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.equals(5.15, precision: 2))
    }
    
    func testMeasurementAmountForUSMass() {
        ingredient.measurement.amount = 5
        ingredient.measurement.unit = .pound
        
        let gallon = try! ingredient.amount(for: .gallon)
        XCTAssertTrue(gallon.equals(0.44, precision: 2))
        
        let quart = try! ingredient.amount(for: .quart)
        XCTAssertTrue(quart.equals(1.76, precision: 2))
        
        let pint = try! ingredient.amount(for: .pint)
        XCTAssertTrue(pint.equals(3.52, precision: 2))
        
        let cup = try! ingredient.amount(for: .cup)
        XCTAssertTrue(cup.equals(7.04, precision: 2))
        
        let fluidOunce = try! ingredient.amount(for: .fluidOunce)
        XCTAssertTrue(fluidOunce.equals(56.34, precision: 2))
        
        let tableSpoon = try! ingredient.amount(for: .tablespoon)
        XCTAssertTrue(tableSpoon.equals(112.68, precision: 2))
        
        let teaspoon = try! ingredient.amount(for: .teaspoon)
        XCTAssertTrue(teaspoon.equals(338.03, precision: 2))
        
        let dash = try! ingredient.amount(for: .dash)
        XCTAssertTrue(dash.equals(2704.23, precision: 2))
        
        let pinch = try! ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.equals(5408.45, precision: 2))
        
        let ounce = try! ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce.equals(80, precision: 2))
        
        let pound = try! ingredient.amount(for: .pound)
        XCTAssertTrue(pound.equals(5, precision: 2))
        
        let milliliter = try! ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.equals(1666.11, precision: 2))
        
        let liter = try! ingredient.amount(for: .liter)
        XCTAssertTrue(liter.equals(1.67, precision: 2))
        
        let gram = try! ingredient.amount(for: .gram)
        XCTAssertTrue(gram.equals(2267.96, precision: 2))
        
        let kilogram = try! ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.equals(2.27, precision: 2))
    }
    
    func testMeasurementAmountForMetricVolume() {
        ingredient.measurement.amount = 750
        ingredient.measurement.unit = .milliliter
        
        let gallon = try! ingredient.amount(for: .gallon)
        XCTAssertTrue(gallon.equals(0.20, precision: 2))
        
        let quart = try! ingredient.amount(for: .quart)
        XCTAssertTrue(quart.equals(0.79, precision: 2))
        
        let pint = try! ingredient.amount(for: .pint)
        XCTAssertTrue(pint.equals(1.59, precision: 2))
        
        let cup = try! ingredient.amount(for: .cup)
        XCTAssertTrue(cup.equals(3.17, precision: 2))
        
        let fluidOunce = try! ingredient.amount(for: .fluidOunce)
        XCTAssertTrue(fluidOunce.equals(25.36, precision: 2))
        
        let tableSpoon = try! ingredient.amount(for: .tablespoon)
        XCTAssertTrue(tableSpoon.equals(50.72, precision: 2))
        
        let teaspoon = try! ingredient.amount(for: .teaspoon)
        XCTAssertTrue(teaspoon.equals(152.16, precision: 2))
        
        let dash = try! ingredient.amount(for: .dash)
        XCTAssertTrue(dash.equals(1217.30, precision: 2))
        
        let pinch = try! ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.equals(2434.61, precision: 2))
        
        let ounce = try! ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce.equals(37.57, precision: 2))
        
        let pound = try! ingredient.amount(for: .pound)
        XCTAssertTrue(pound.equals(2.35, precision: 2))
        
        let milliliter = try! ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.equals(750, precision: 2))
        
        let liter = try! ingredient.amount(for: .liter)
        XCTAssertTrue(liter.equals(0.75, precision: 2))
        
        let gram = try! ingredient.amount(for: .gram)
        XCTAssertTrue(gram.equals(1065, precision: 2))
        
        let kilogram = try! ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.equals(1.07, precision: 2))
    }
    
    func testMeasurementAmountForMetricMass() {
        ingredient.measurement.amount = 2.5
        ingredient.measurement.unit = .kilogram
        
        let gallon = try! ingredient.amount(for: .gallon)
        XCTAssertTrue(gallon.equals(0.47, precision: 2))
        
        let quart = try! ingredient.amount(for: .quart)
        XCTAssertTrue(quart.equals(1.86, precision: 2))
        
        let pint = try! ingredient.amount(for: .pint)
        XCTAssertTrue(pint.equals(3.72, precision: 2))
        
        let cup = try! ingredient.amount(for: .cup)
        XCTAssertTrue(cup.equals(7.44, precision: 2))
        
        let fluidOunce = try! ingredient.amount(for: .fluidOunce)
        XCTAssertTrue(fluidOunce.equals(59.53, precision: 2))
        
        let tableSpoon = try! ingredient.amount(for: .tablespoon)
        XCTAssertTrue(tableSpoon.equals(119.06, precision: 2))
        
        let teaspoon = try! ingredient.amount(for: .teaspoon)
        XCTAssertTrue(teaspoon.equals(357.19, precision: 2))
        
        let dash = try! ingredient.amount(for: .dash)
        XCTAssertTrue(dash.equals(2857.52, precision: 2))
        
        let pinch = try! ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.equals(5715.05, precision: 2))
        
        let ounce = try! ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce.equals(88.18, precision: 2))
        
        let pound = try! ingredient.amount(for: .pound)
        XCTAssertTrue(pound.equals(5.51, precision: 2))
        
        let milliliter = try! ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.equals(1760.56, precision: 2))
        
        let liter = try! ingredient.amount(for: .liter)
        XCTAssertTrue(liter.equals(1.76, precision: 2))
        
        let gram = try! ingredient.amount(for: .gram)
        XCTAssertTrue(gram.equals(2500, precision: 2))
        
        let kilogram = try! ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.equals(2.5, precision: 2))
    }
    
    func testScaleUSMassToUSMass() {
        ingredient.measurement.amount = 2
        ingredient.measurement.unit = .pound
        
        let scaleMeasure = try! ingredient.scale(by: 0.25, measurementSystemMethod: .usWeight)
        XCTAssertTrue(scaleMeasure.amount == 8)
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleUSMassToUSVolume() {
        ingredient.measurement.amount = 0.5
        ingredient.measurement.unit = .pound
        
        let scaleMeasure = try! ingredient.scale(by: 1.25, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(0.88, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .cup)
    }
    
    func testScaleUSMassToMetricMass() {
        ingredient.measurement.amount = 10
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = try! ingredient.scale(by: 1.0, measurementSystemMethod: .metricWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(283.50, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .gram)
    }
    
    func testScaleUSMassToMetricVolume() {
        ingredient.measurement.amount = 4
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = try! ingredient.scale(by: 2.0, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(166.61, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testScaleUSVolumeToUSMass() {
        ingredient.measurement.amount = 4
        ingredient.measurement.unit = .tablespoon
        
        let scaleMeasure = try! ingredient.scale(by: 3.5, measurementSystemMethod: .usWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(9.94, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleUSVolumeToUSVolume() {
        ingredient.measurement.amount = 28
        ingredient.measurement.unit = .quart
        
        let scaleMeasure = try! ingredient.scale(by: Fraction.oneSixteenth.rawValue, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(1.75, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .quart)
    }
    
    func testScaleUSVolumeToMetricMass() {
        ingredient.measurement.amount = 1
        ingredient.measurement.unit = .gallon
        
        let scaleMeasure = try! ingredient.scale(by: 1.75, measurementSystemMethod: .metricWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(9.02, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testScaleUSVolumeToMetricVolume() {
        ingredient.measurement.amount = 1.3
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = try! ingredient.scale(by: 3.0, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(81.22, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testScaleMetricMassToUSMass() {
        ingredient.measurement.amount = 250
        ingredient.measurement.unit = .gram
        
        let scaleMeasure = try! ingredient.scale(by: Fraction.oneHalf.rawValue, measurementSystemMethod: .usWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(4.41, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleMetricMassToUSVolume() {
        ingredient.measurement.amount = 1.68
        ingredient.measurement.unit = .kilogram
        
        let scaleMeasure = try! ingredient.scale(by: 1.0, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(1.25, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .quart)
    }
    
    func testScaleMetricMassToMetricMass() {
        ingredient.measurement.amount = 22
        ingredient.measurement.unit = .kilogram
        
        let scaleMeasure = try! ingredient.scale(by: Fraction.oneThird.rawValue, measurementSystemMethod: .metricWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(7.33, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testScaleMetricMassToMetricVolume() {
        ingredient.measurement.amount = 888.888
        ingredient.measurement.unit = .gram
        
        let scaleMeasure = try! ingredient.scale(by: Fraction.twoThirds.rawValue, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(417.32, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testScaleMetricVolumeToUSMass() {
        ingredient.measurement.amount = 130
        ingredient.measurement.unit = .milliliter
        
        let scaleMeasure = try! ingredient.scale(by: 1.01, measurementSystemMethod: .usWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(6.58, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleMetricVolumeToUSVolume() {
        ingredient.measurement.amount = 2.99
        ingredient.measurement.unit = .liter
        
        let scaleMeasure = try! ingredient.scale(by: Fraction.oneSixth.rawValue, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(1.05, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .pint)
    }
    
    func testScaleMetricVolumeToMetricMass() {
        ingredient.measurement.amount = 45
        ingredient.measurement.unit = .liter
        
        let scaleMeasure = try! ingredient.scale(by: 1.0, measurementSystemMethod: .metricWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(63.90, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testScaleMetricVolumeToMetricVolume() {
        ingredient.measurement.amount = 45000
        ingredient.measurement.unit = .milliliter
        
        let scaleMeasure = try! ingredient.scale(by: Fraction.oneThousandth.rawValue, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(45, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
}
