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
        ingredient.ratio.weight = 1
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
        XCTAssertTrue(teaspoon.equals(768, precision: 2))
        
        let dash = ingredient.amount(for: .dash)
        XCTAssertTrue(dash.equals(6144, precision: 0))
        
        let pinch = ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.equals(12288, precision: 0))
        
        let ounce = ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce == 128)
        
        let pound = ingredient.amount(for: .pound)
        XCTAssertTrue(pound == 8)
        
        let milliliter = ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.equals(3785.41, precision: 2))
        
        let liter = ingredient.amount(for: .liter)
        XCTAssertTrue(liter.equals(3.79, precision: 2))
        
        let gram = ingredient.amount(for: .gram)
        XCTAssertTrue(gram.equals(3628.74, precision: 2))
        
        let kilogram = ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.equals(3.63, precision: 2))
    }
    
    func testMeasurementAmountForUSMass() {
        ingredient.measurement.amount = 5
        ingredient.measurement.unit = .pound
        
        let gallon = ingredient.amount(for: .gallon)
        XCTAssertTrue(gallon.equals(0.62, precision: 2))
        
        let quart = ingredient.amount(for: .quart)
        XCTAssertTrue(quart.equals(2.5, precision: 1))
        
        let pint = ingredient.amount(for: .pint)
        XCTAssertTrue(pint.equals(5, precision: 0))
        
        let cup = ingredient.amount(for: .cup)
        XCTAssertTrue(cup.equals(10, precision: 0))
        
        let fluidOunce = ingredient.amount(for: .fluidOunce)
        XCTAssertTrue(fluidOunce.equals(80, precision: 0))
        
        let tableSpoon = ingredient.amount(for: .tablespoon)
        XCTAssertTrue(tableSpoon.equals(160, precision: 0))
        
        let teaspoon = ingredient.amount(for: .teaspoon)
        XCTAssertTrue(teaspoon.equals(480, precision: 0))
        
        let dash = ingredient.amount(for: .dash)
        XCTAssertTrue(dash.equals(3840, precision: 0))
        
        let pinch = ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.equals(7680, precision: 0))
        
        let ounce = ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce.equals(80, precision: 0))
        
        let pound = ingredient.amount(for: .pound)
        XCTAssertTrue(pound.equals(5, precision: 0))
        
        let milliliter = ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.equals(2365.88, precision: 2))
        
        let liter = ingredient.amount(for: .liter)
        XCTAssertTrue(liter.equals(2.37, precision: 2))
        
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
        XCTAssertTrue(ounce.equals(26.46, precision: 2))
        
        let pound = ingredient.amount(for: .pound)
        XCTAssertTrue(pound.equals(1.65, precision: 2))
        
        let milliliter = ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.equals(750, precision: 0))
        
        let liter = ingredient.amount(for: .liter)
        XCTAssertTrue(liter.equals(0.75, precision: 2))
        
        let gram = ingredient.amount(for: .gram)
        XCTAssertTrue(gram.equals(750, precision: 0))
        
        let kilogram = ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.equals(0.75, precision: 2))
    }
    
    func testMeasurementAmountForMetricMass() {
        ingredient.measurement.amount = 2.5
        ingredient.measurement.unit = .kilogram
        
        let gallon = ingredient.amount(for: .gallon)
        XCTAssertTrue(gallon.equals(0.66, precision: 2))
        
        let quart = ingredient.amount(for: .quart)
        XCTAssertTrue(quart.equals(2.64, precision: 2))
        
        let pint = ingredient.amount(for: .pint)
        XCTAssertTrue(pint.equals(5.28, precision: 2))
        
        let cup = ingredient.amount(for: .cup)
        XCTAssertTrue(cup.equals(10.57, precision: 2))
        
        let fluidOunce = ingredient.amount(for: .fluidOunce)
        XCTAssertTrue(fluidOunce.equals(84.54, precision: 2))
        
        let tableSpoon = ingredient.amount(for: .tablespoon)
        XCTAssertTrue(tableSpoon.equals(169.07, precision: 2))
        
        let teaspoon = ingredient.amount(for: .teaspoon)
        XCTAssertTrue(teaspoon.equals(507.21, precision: 2))
        
        let dash = ingredient.amount(for: .dash)
        XCTAssertTrue(dash.equals(4057.68, precision: 2))
        
        let pinch = ingredient.amount(for: .pinch)
        XCTAssertTrue(pinch.equals(8115.37, precision: 2))
        
        let ounce = ingredient.amount(for: .ounce)
        XCTAssertTrue(ounce.equals(88.18, precision: 2))
        
        let pound = ingredient.amount(for: .pound)
        XCTAssertTrue(pound.equals(5.51, precision: 2))
        
        let milliliter = ingredient.amount(for: .milliliter)
        XCTAssertTrue(milliliter.equals(2500, precision: 0))
        
        let liter = ingredient.amount(for: .liter)
        XCTAssertTrue(liter.equals(2.5, precision: 1))
        
        let gram = ingredient.amount(for: .gram)
        XCTAssertTrue(gram.equals(2500, precision: 0))
        
        let kilogram = ingredient.amount(for: .kilogram)
        XCTAssertTrue(kilogram.equals(2.5, precision: 1))
    }
    
    func testScaleUSMassToUSMass() {
        ingredient.measurement.amount = 2
        ingredient.measurement.unit = .pound
        
        let scaleMeasure = ingredient.scale(by: 0.25, measurementSystemMethod: .usWeight)
        XCTAssertTrue(scaleMeasure.amount == 8)
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleUSMassToUSVolume() {
        ingredient.measurement.amount = 0.5
        ingredient.measurement.unit = .pound
        
        let scaleMeasure = ingredient.scale(by: 1.25, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(1.25, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .cup)
    }
    
    func testScaleUSMassToMetricMass() {
        ingredient.measurement.amount = 10
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = ingredient.scale(by: 1.0, measurementSystemMethod: .metricWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(283.50, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .gram)
    }
    
    func testScaleUSMassToMetricVolume() {
        ingredient.measurement.amount = 4
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = ingredient.scale(by: 2.0, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(236.59, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testScaleUSVolumeToUSMass() {
        ingredient.measurement.amount = 4
        ingredient.measurement.unit = .tablespoon
        
        let scaleMeasure = ingredient.scale(by: 3.5, measurementSystemMethod: .usWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(7, precision: 0))
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleUSVolumeToUSVolume() {
        ingredient.measurement.amount = 28
        ingredient.measurement.unit = .quart
        
        let scaleMeasure = ingredient.scale(by: Fraction.oneSixteenth.rawValue, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(1.75, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .quart)
    }
    
    func testScaleUSVolumeToMetricMass() {
        ingredient.measurement.amount = 1
        ingredient.measurement.unit = .gallon
        
        let scaleMeasure = ingredient.scale(by: 1.75, measurementSystemMethod: .metricWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(6.35, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testScaleUSVolumeToMetricVolume() {
        ingredient.measurement.amount = 1.3
        ingredient.measurement.unit = .ounce
        
        let scaleMeasure = ingredient.scale(by: 3.0, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(115.34, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testScaleMetricMassToUSMass() {
        ingredient.measurement.amount = 250
        ingredient.measurement.unit = .gram
        
        let scaleMeasure = ingredient.scale(by: Fraction.oneHalf.rawValue, measurementSystemMethod: .usWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(4.41, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleMetricMassToUSVolume() {
        ingredient.measurement.amount = 1.68
        ingredient.measurement.unit = .kilogram
        
        let scaleMeasure = ingredient.scale(by: 1.0, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(1.78, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .quart)
    }
    
    func testScaleMetricMassToMetricMass() {
        ingredient.measurement.amount = 22
        ingredient.measurement.unit = .kilogram
        
        let scaleMeasure = ingredient.scale(by: Fraction.oneThird.rawValue, measurementSystemMethod: .metricWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(7.33, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testScaleMetricMassToMetricVolume() {
        ingredient.measurement.amount = 888.888
        ingredient.measurement.unit = .gram
        
        let scaleMeasure = ingredient.scale(by: Fraction.twoThirds.rawValue, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(592.59, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
    
    func testScaleMetricVolumeToUSMass() {
        ingredient.measurement.amount = 130
        ingredient.measurement.unit = .milliliter
        
        let scaleMeasure = ingredient.scale(by: 1.01, measurementSystemMethod: .usWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(4.63, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .ounce)
    }
    
    func testScaleMetricVolumeToUSVolume() {
        ingredient.measurement.amount = 2.99
        ingredient.measurement.unit = .liter
        
        let scaleMeasure = ingredient.scale(by: Fraction.oneSixth.rawValue, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(1.05, precision: 2))
        XCTAssertTrue(scaleMeasure.unit == .pint)
    }
    
    func testScaleMetricVolumeToMetricMass() {
        ingredient.measurement.amount = 45
        ingredient.measurement.unit = .liter
        
        let scaleMeasure = ingredient.scale(by: 1.0, measurementSystemMethod: .metricWeight)
        XCTAssertTrue(scaleMeasure.amount.equals(45, precision: 0))
        XCTAssertTrue(scaleMeasure.unit == .kilogram)
    }
    
    func testScaleMetricVolumeToMetricVolume() {
        ingredient.measurement.amount = 45000
        ingredient.measurement.unit = .milliliter
        
        let scaleMeasure = ingredient.scale(by: Fraction.oneThousandth.rawValue, measurementSystemMethod: .metricVolume)
        XCTAssertTrue(scaleMeasure.amount.equals(45, precision: 0))
        XCTAssertTrue(scaleMeasure.unit == .milliliter)
    }
}
