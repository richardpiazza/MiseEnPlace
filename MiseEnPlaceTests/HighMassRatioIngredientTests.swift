//
//  highMassRatioIngredientTests.swift
//  miseenplace
//
//  Created by Richard Piazza on 8/4/15.
//  Copyright (c) 2015 Richard Piazza. All rights reserved.
//

import UIKit
import XCTest
import MiseEnPlace

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
        XCTAssertTrue(ounce.twoDecimalValue == 181.76)
        
        let pound = Converter.measurementAmountFor(ingredient, measurementUnit: .Pound)
        XCTAssertTrue(pound.twoDecimalValue == 11.36)
        
        let milliliter = Converter.measurementAmountFor(ingredient, measurementUnit: .Milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 3785.41)
        
        let liter = Converter.measurementAmountFor(ingredient, measurementUnit: .Liter)
        XCTAssertTrue(liter.twoDecimalValue == 3.79)
        
        let gram = Converter.measurementAmountFor(ingredient, measurementUnit: .Gram)
        XCTAssertTrue(gram.twoDecimalValue == 5152.81)
        
        let kilogram = Converter.measurementAmountFor(ingredient, measurementUnit: .Kilogram)
        XCTAssertTrue(kilogram.twoDecimalValue == 5.15)
    }
    
    func testMeasurementAmountForUSMass() {
        ingredient.measurementAmount = 5
        ingredient.measurementUnit = .Pound
        
        let gallon = Converter.measurementAmountFor(ingredient, measurementUnit: .Gallon)
        XCTAssertTrue(gallon.twoDecimalValue == 0.44)
        
        let quart = Converter.measurementAmountFor(ingredient, measurementUnit: .Quart)
        XCTAssertTrue(quart.twoDecimalValue == 1.76)
        
        let pint = Converter.measurementAmountFor(ingredient, measurementUnit: .Pint)
        XCTAssertTrue(pint.twoDecimalValue == 3.52)
        
        let cup = Converter.measurementAmountFor(ingredient, measurementUnit: .Cup)
        XCTAssertTrue(cup.twoDecimalValue == 7.04)
        
        let fluidOunce = Converter.measurementAmountFor(ingredient, measurementUnit: .FluidOunce)
        XCTAssertTrue(fluidOunce.twoDecimalValue == 56.34)
        
        let tableSpoon = Converter.measurementAmountFor(ingredient, measurementUnit: .Tablespoon)
        XCTAssertTrue(tableSpoon.twoDecimalValue == 112.68)
        
        let teaspoon = Converter.measurementAmountFor(ingredient, measurementUnit: .Teaspoon)
        XCTAssertTrue(teaspoon.twoDecimalValue == 338.03)
        
        let dash = Converter.measurementAmountFor(ingredient, measurementUnit: .Dash)
        XCTAssertTrue(dash.twoDecimalValue == 2704.23)
        
        let pinch = Converter.measurementAmountFor(ingredient, measurementUnit: .Pinch)
        XCTAssertTrue(pinch.twoDecimalValue == 5408.45)
        
        let ounce = Converter.measurementAmountFor(ingredient, measurementUnit: .Ounce)
        XCTAssertTrue(ounce.twoDecimalValue == 80)
        
        let pound = Converter.measurementAmountFor(ingredient, measurementUnit: .Pound)
        XCTAssertTrue(pound.twoDecimalValue == 5)
        
        let milliliter = Converter.measurementAmountFor(ingredient, measurementUnit: .Milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 1666.11)
        
        let liter = Converter.measurementAmountFor(ingredient, measurementUnit: .Liter)
        XCTAssertTrue(liter.twoDecimalValue == 1.67)
        
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
        XCTAssertTrue(ounce.twoDecimalValue == 37.57)
        
        let pound = Converter.measurementAmountFor(ingredient, measurementUnit: .Pound)
        XCTAssertTrue(pound.twoDecimalValue == 2.35)
        
        let milliliter = Converter.measurementAmountFor(ingredient, measurementUnit: .Milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 750)
        
        let liter = Converter.measurementAmountFor(ingredient, measurementUnit: .Liter)
        XCTAssertTrue(liter.twoDecimalValue == 0.75)
        
        let gram = Converter.measurementAmountFor(ingredient, measurementUnit: .Gram)
        XCTAssertTrue(gram.twoDecimalValue == 1065)
        
        let kilogram = Converter.measurementAmountFor(ingredient, measurementUnit: .Kilogram)
        XCTAssertTrue(kilogram.twoDecimalValue == 1.07)
    }
    
    func testMeasurementAmountForMetricMass() {
        ingredient.measurementAmount = 2.5
        ingredient.measurementUnit = .Kilogram
        
        let gallon = Converter.measurementAmountFor(ingredient, measurementUnit: .Gallon)
        XCTAssertTrue(gallon.twoDecimalValue == 0.47)
        
        let quart = Converter.measurementAmountFor(ingredient, measurementUnit: .Quart)
        XCTAssertTrue(quart.twoDecimalValue == 1.86)
        
        let pint = Converter.measurementAmountFor(ingredient, measurementUnit: .Pint)
        XCTAssertTrue(pint.twoDecimalValue == 3.72)
        
        let cup = Converter.measurementAmountFor(ingredient, measurementUnit: .Cup)
        XCTAssertTrue(cup.twoDecimalValue == 7.44)
        
        let fluidOunce = Converter.measurementAmountFor(ingredient, measurementUnit: .FluidOunce)
        XCTAssertTrue(fluidOunce.twoDecimalValue == 59.53)
        
        let tableSpoon = Converter.measurementAmountFor(ingredient, measurementUnit: .Tablespoon)
        XCTAssertTrue(tableSpoon.twoDecimalValue == 119.06)
        
        let teaspoon = Converter.measurementAmountFor(ingredient, measurementUnit: .Teaspoon)
        XCTAssertTrue(teaspoon.twoDecimalValue == 357.19)
        
        let dash = Converter.measurementAmountFor(ingredient, measurementUnit: .Dash)
        XCTAssertTrue(dash.twoDecimalValue == 2857.52)
        
        let pinch = Converter.measurementAmountFor(ingredient, measurementUnit: .Pinch)
        XCTAssertTrue(pinch.twoDecimalValue == 5715.05)
        
        let ounce = Converter.measurementAmountFor(ingredient, measurementUnit: .Ounce)
        XCTAssertTrue(ounce.twoDecimalValue == 88.18)
        
        let pound = Converter.measurementAmountFor(ingredient, measurementUnit: .Pound)
        XCTAssertTrue(pound.twoDecimalValue == 5.51)
        
        let milliliter = Converter.measurementAmountFor(ingredient, measurementUnit: .Milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 1760.56)
        
        let liter = Converter.measurementAmountFor(ingredient, measurementUnit: .Liter)
        XCTAssertTrue(liter.twoDecimalValue == 1.76)
        
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
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 7.04)
        XCTAssertTrue(scaleMeasure.unit == .FluidOunce)
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
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 166.61)
        XCTAssertTrue(scaleMeasure.unit == .Milliliter)
    }
    
    func testScaleUSVolumeToUSMass() {
        ingredient.measurementAmount = 4
        ingredient.measurementUnit = .Tablespoon
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 3.5, measurementSystemMethod: .USMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 9.94)
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
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 9.02)
        XCTAssertTrue(scaleMeasure.unit == .Kilogram)
    }
    
    func testScaleUSVolumeToMetricVolume() {
        ingredient.measurementAmount = 1.3
        ingredient.measurementUnit = .Ounce
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 3.0, measurementSystemMethod: .MetricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 81.22)
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
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.25)
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
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 417.32)
        XCTAssertTrue(scaleMeasure.unit == .Milliliter)
    }
    
    func testScaleMetricVolumeToUSMass() {
        ingredient.measurementAmount = 130
        ingredient.measurementUnit = .Milliliter
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 1.01, measurementSystemMethod: .USMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 6.58)
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
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 63.90)
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
