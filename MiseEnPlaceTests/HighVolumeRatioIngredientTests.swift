//
//  highVolumeRatioIngredientTests.swift
//  miseenplace
//
//  Created by Richard Piazza on 8/4/15.
//  Copyright (c) 2015 Richard Piazza. All rights reserved.
//

import UIKit
import XCTest
import MiseEnPlace

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
        ingredient.measurementAmount = 1
        ingredient.measurementUnit = .Gallon
        
        let gallon = Converter.measurementAmountFor(ingredient, measurementUnit: .Gallon)
        XCTAssertTrue(gallon == 1)
        
        let quart = Converter.measurementAmountFor(ingredient, measurementUnit: .Quart)
        XCTAssertTrue(quart == 4)
        
        let pint = Converter.measurementAmountFor(ingredient, measurementUnit: .Pint)
        XCTAssertTrue(pint == 8)
        
        let cup = Converter.measurementAmountFor(ingredient, measurementUnit: .Cup)
        XCTAssertTrue(cup == 16)
        
        let fluidOunce = Converter.measurementAmountFor(ingredient, measurementUnit: .FluidOunce)
        XCTAssertTrue(fluidOunce == 128)
        
        let tableSpoon = Converter.measurementAmountFor(ingredient, measurementUnit: .Tablespoon)
        XCTAssertTrue(tableSpoon == 256)
        
        let teaspoon = Converter.measurementAmountFor(ingredient, measurementUnit: .Teaspoon)
        XCTAssertTrue(teaspoon.integerValue == 768)
        
        let dash = Converter.measurementAmountFor(ingredient, measurementUnit: .Dash)
        XCTAssertTrue(dash.integerValue == 6144)
        
        let pinch = Converter.measurementAmountFor(ingredient, measurementUnit: .Pinch)
        XCTAssertTrue(pinch.integerValue == 12288)
        
        let ounce = Converter.measurementAmountFor(ingredient, measurementUnit: .Ounce)
        XCTAssertTrue(ounce.twoDecimalValue == 112.28)
        
        let pound = Converter.measurementAmountFor(ingredient, measurementUnit: .Pound)
        XCTAssertTrue(pound.twoDecimalValue == 7.02)
        
        let milliliter = Converter.measurementAmountFor(ingredient, measurementUnit: .Milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 3785.41)
        
        let liter = Converter.measurementAmountFor(ingredient, measurementUnit: .Liter)
        XCTAssertTrue(liter.twoDecimalValue == 3.79)
        
        let gram = Converter.measurementAmountFor(ingredient, measurementUnit: .Gram)
        XCTAssertTrue(gram.twoDecimalValue == 3183.10)
        
        let kilogram = Converter.measurementAmountFor(ingredient, measurementUnit: .Kilogram)
        XCTAssertTrue(kilogram.twoDecimalValue == 3.18)
    }
    
    func testMeasurementAmountForUSMass() {
        ingredient.measurementAmount = 5
        ingredient.measurementUnit = .Pound
        
        let gallon = Converter.measurementAmountFor(ingredient, measurementUnit: .Gallon)
        XCTAssertTrue(gallon.twoDecimalValue == 0.71)
        
        let quart = Converter.measurementAmountFor(ingredient, measurementUnit: .Quart)
        XCTAssertTrue(quart.twoDecimalValue == 2.85)
        
        let pint = Converter.measurementAmountFor(ingredient, measurementUnit: .Pint)
        XCTAssertTrue(pint.twoDecimalValue == 5.70)
        
        let cup = Converter.measurementAmountFor(ingredient, measurementUnit: .Cup)
        XCTAssertTrue(cup.twoDecimalValue == 11.40)
        
        let fluidOunce = Converter.measurementAmountFor(ingredient, measurementUnit: .FluidOunce)
        XCTAssertTrue(fluidOunce.twoDecimalValue == 91.20)
        
        let tableSpoon = Converter.measurementAmountFor(ingredient, measurementUnit: .Tablespoon)
        XCTAssertTrue(tableSpoon.twoDecimalValue == 182.40)
        
        let teaspoon = Converter.measurementAmountFor(ingredient, measurementUnit: .Teaspoon)
        XCTAssertTrue(teaspoon.twoDecimalValue == 547.20)
        
        let dash = Converter.measurementAmountFor(ingredient, measurementUnit: .Dash)
        XCTAssertTrue(dash.twoDecimalValue == 4377.60)
        
        let pinch = Converter.measurementAmountFor(ingredient, measurementUnit: .Pinch)
        XCTAssertTrue(pinch.twoDecimalValue == 8755.20)
        
        let ounce = Converter.measurementAmountFor(ingredient, measurementUnit: .Ounce)
        XCTAssertTrue(ounce.twoDecimalValue == 80)
        
        let pound = Converter.measurementAmountFor(ingredient, measurementUnit: .Pound)
        XCTAssertTrue(pound.twoDecimalValue == 5)
        
        let milliliter = Converter.measurementAmountFor(ingredient, measurementUnit: .Milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 2697.11)
        
        let liter = Converter.measurementAmountFor(ingredient, measurementUnit: .Liter)
        XCTAssertTrue(liter.twoDecimalValue == 2.70)
        
        let gram = Converter.measurementAmountFor(ingredient, measurementUnit: .Gram)
        XCTAssertTrue(gram.twoDecimalValue == 2267.96)
        
        let kilogram = Converter.measurementAmountFor(ingredient, measurementUnit: .Kilogram)
        XCTAssertTrue(kilogram.twoDecimalValue == 2.27)
    }
    
    func testMeasurementAmountForMetricVolume() {
        ingredient.measurementAmount = 750
        ingredient.measurementUnit = .Milliliter
        
        let gallon = Converter.measurementAmountFor(ingredient, measurementUnit: .Gallon)
        XCTAssertTrue(gallon.twoDecimalValue == 0.20)
        
        let quart = Converter.measurementAmountFor(ingredient, measurementUnit: .Quart)
        XCTAssertTrue(quart.twoDecimalValue == 0.79)
        
        let pint = Converter.measurementAmountFor(ingredient, measurementUnit: .Pint)
        XCTAssertTrue(pint.twoDecimalValue == 1.59)
        
        let cup = Converter.measurementAmountFor(ingredient, measurementUnit: .Cup)
        XCTAssertTrue(cup.twoDecimalValue == 3.17)
        
        let fluidOunce = Converter.measurementAmountFor(ingredient, measurementUnit: .FluidOunce)
        XCTAssertTrue(fluidOunce.twoDecimalValue == 25.36)
        
        let tableSpoon = Converter.measurementAmountFor(ingredient, measurementUnit: .Tablespoon)
        XCTAssertTrue(tableSpoon.twoDecimalValue == 50.72)
        
        let teaspoon = Converter.measurementAmountFor(ingredient, measurementUnit: .Teaspoon)
        XCTAssertTrue(teaspoon.twoDecimalValue == 152.16)
        
        let dash = Converter.measurementAmountFor(ingredient, measurementUnit: .Dash)
        XCTAssertTrue(dash.twoDecimalValue == 1217.30)
        
        let pinch = Converter.measurementAmountFor(ingredient, measurementUnit: .Pinch)
        XCTAssertTrue(pinch.twoDecimalValue == 2434.61)
        
        let ounce = Converter.measurementAmountFor(ingredient, measurementUnit: .Ounce)
        XCTAssertTrue(ounce.twoDecimalValue == 23.21)
        
        let pound = Converter.measurementAmountFor(ingredient, measurementUnit: .Pound)
        XCTAssertTrue(pound.twoDecimalValue == 1.45)
        
        let milliliter = Converter.measurementAmountFor(ingredient, measurementUnit: .Milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 750)
        
        let liter = Converter.measurementAmountFor(ingredient, measurementUnit: .Liter)
        XCTAssertTrue(liter.twoDecimalValue == 0.75)
        
        let gram = Converter.measurementAmountFor(ingredient, measurementUnit: .Gram)
        XCTAssertTrue(gram.twoDecimalValue == 657.89)
        
        let kilogram = Converter.measurementAmountFor(ingredient, measurementUnit: .Kilogram)
        XCTAssertTrue(kilogram.twoDecimalValue == 0.66)
    }
    
    func testMeasurementAmountForMetricMass() {
        ingredient.measurementAmount = 2.5
        ingredient.measurementUnit = .Kilogram
        
        let gallon = Converter.measurementAmountFor(ingredient, measurementUnit: .Gallon)
        XCTAssertTrue(gallon.twoDecimalValue == 0.75)
        
        let quart = Converter.measurementAmountFor(ingredient, measurementUnit: .Quart)
        XCTAssertTrue(quart.twoDecimalValue == 3.01)
        
        let pint = Converter.measurementAmountFor(ingredient, measurementUnit: .Pint)
        XCTAssertTrue(pint.twoDecimalValue == 6.02)
        
        let cup = Converter.measurementAmountFor(ingredient, measurementUnit: .Cup)
        XCTAssertTrue(cup.twoDecimalValue == 12.05)
        
        let fluidOunce = Converter.measurementAmountFor(ingredient, measurementUnit: .FluidOunce)
        XCTAssertTrue(fluidOunce.twoDecimalValue == 96.37)
        
        let tableSpoon = Converter.measurementAmountFor(ingredient, measurementUnit: .Tablespoon)
        XCTAssertTrue(tableSpoon.twoDecimalValue == 192.74)
        
        let teaspoon = Converter.measurementAmountFor(ingredient, measurementUnit: .Teaspoon)
        XCTAssertTrue(teaspoon.twoDecimalValue == 578.22)
        
        let dash = Converter.measurementAmountFor(ingredient, measurementUnit: .Dash)
        XCTAssertTrue(dash.twoDecimalValue == 4625.76)
        
        let pinch = Converter.measurementAmountFor(ingredient, measurementUnit: .Pinch)
        XCTAssertTrue(pinch.twoDecimalValue == 9251.52)
        
        let ounce = Converter.measurementAmountFor(ingredient, measurementUnit: .Ounce)
        XCTAssertTrue(ounce.twoDecimalValue == 88.18)
        
        let pound = Converter.measurementAmountFor(ingredient, measurementUnit: .Pound)
        XCTAssertTrue(pound.twoDecimalValue == 5.51)
        
        let milliliter = Converter.measurementAmountFor(ingredient, measurementUnit: .Milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 2850)
        
        let liter = Converter.measurementAmountFor(ingredient, measurementUnit: .Liter)
        XCTAssertTrue(liter.twoDecimalValue == 2.85)
        
        let gram = Converter.measurementAmountFor(ingredient, measurementUnit: .Gram)
        XCTAssertTrue(gram.twoDecimalValue == 2500)
        
        let kilogram = Converter.measurementAmountFor(ingredient, measurementUnit: .Kilogram)
        XCTAssertTrue(kilogram.twoDecimalValue == 2.5)
    }

    func testScaleUSMassToUSMass() {
        ingredient.measurementAmount = 2
        ingredient.measurementUnit = .Pound
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 0.25, measurementSystemMethod: .USMass)
        XCTAssertTrue(scaleMeasure.amount == 8)
        XCTAssertTrue(scaleMeasure.unit == .Ounce)
    }
    
    func testScaleUSMassToUSVolume() {
        ingredient.measurementAmount = 0.5
        ingredient.measurementUnit = .Pound
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 1.25, measurementSystemMethod: .USVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.42)
        XCTAssertTrue(scaleMeasure.unit == .Cup)
    }
    
    func testScaleUSMassToMetricMass() {
        ingredient.measurementAmount = 10
        ingredient.measurementUnit = .Ounce
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 1.0, measurementSystemMethod: .MetricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 283.50)
        XCTAssertTrue(scaleMeasure.unit == .Gram)
    }
    
    func testScaleUSMassToMetricVolume() {
        ingredient.measurementAmount = 4
        ingredient.measurementUnit = .Ounce
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 2.0, measurementSystemMethod: .MetricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 269.71)
        XCTAssertTrue(scaleMeasure.unit == .Milliliter)
    }

    func testScaleUSVolumeToUSMass() {
        ingredient.measurementAmount = 4
        ingredient.measurementUnit = .Tablespoon
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 3.5, measurementSystemMethod: .USMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 6.14)
        XCTAssertTrue(scaleMeasure.unit == .Ounce)
    }
    
    func testScaleUSVolumeToUSVolume() {
        ingredient.measurementAmount = 28
        ingredient.measurementUnit = .Quart
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: OneSixteenth, measurementSystemMethod: .USVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.75)
        XCTAssertTrue(scaleMeasure.unit == .Quart)
    }
    
    func testScaleUSVolumeToMetricMass() {
        ingredient.measurementAmount = 1
        ingredient.measurementUnit = .Gallon
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 1.75, measurementSystemMethod: .MetricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 5.57)
        XCTAssertTrue(scaleMeasure.unit == .Kilogram)
    }
    
    func testScaleUSVolumeToMetricVolume() {
        ingredient.measurementAmount = 1.3
        ingredient.measurementUnit = .Ounce
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 3.0, measurementSystemMethod: .MetricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 131.48)
        XCTAssertTrue(scaleMeasure.unit == .Milliliter)
    }
    
    func testScaleMetricMassToUSMass() {
        ingredient.measurementAmount = 250
        ingredient.measurementUnit = .Gram
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: OneHalf, measurementSystemMethod: .USMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 4.41)
        XCTAssertTrue(scaleMeasure.unit == .Ounce)
    }
    
    func testScaleMetricMassToUSVolume() {
        ingredient.measurementAmount = 1.68
        ingredient.measurementUnit = .Kilogram
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 1.0, measurementSystemMethod: .USVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 2.02)
        XCTAssertTrue(scaleMeasure.unit == .Quart)
    }
    
    func testScaleMetricMassToMetricMass() {
        ingredient.measurementAmount = 22
        ingredient.measurementUnit = .Kilogram
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: OneThird, measurementSystemMethod: .MetricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 7.33)
        XCTAssertTrue(scaleMeasure.unit == .Kilogram)
    }
    
    func testScaleMetricMassToMetricVolume() {
        ingredient.measurementAmount = 888.888
        ingredient.measurementUnit = .Gram
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: TwoThirds, measurementSystemMethod: .MetricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 675.55)
        XCTAssertTrue(scaleMeasure.unit == .Milliliter)
    }
    
    func testScaleMetricVolumeToUSMass() {
        ingredient.measurementAmount = 130
        ingredient.measurementUnit = .Milliliter
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 1.01, measurementSystemMethod: .USMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 4.06)
        XCTAssertTrue(scaleMeasure.unit == .Ounce)
    }
    
    func testScaleMetricVolumeToUSVolume() {
        ingredient.measurementAmount = 2.99
        ingredient.measurementUnit = .Liter
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: OneSixth, measurementSystemMethod: .USVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.05)
        XCTAssertTrue(scaleMeasure.unit == .Pint)
    }
    
    func testScaleMetricVolumeToMetricMass() {
        ingredient.measurementAmount = 45
        ingredient.measurementUnit = .Liter
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 1.0, measurementSystemMethod: .MetricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 39.47)
        XCTAssertTrue(scaleMeasure.unit == .Kilogram)
    }
    
    func testScaleMetricVolumeToMetricVolume() {
        ingredient.measurementAmount = 45000
        ingredient.measurementUnit = .Milliliter
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: OneThousandth, measurementSystemMethod: .MetricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 45)
        XCTAssertTrue(scaleMeasure.unit == .Milliliter)
    }
}
