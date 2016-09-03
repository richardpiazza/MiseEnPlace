//
//  LooseConversionTests.swift
//  miseenplace
//
//  Created by Richard Piazza on 8/5/15.
//  Copyright (c) 2015 Richard Piazza. All rights reserved.
//

import Foundation
import XCTest
import MiseEnPlace

class LooseConversionTests: XCTestCase {
    var ingredient: ConvertableIngredient = ConvertableIngredient()

    override func setUp() {
        super.setUp()
        
        ingredient.ratio.mass = 1
        ingredient.ratio.volume = 1
        
        Converter.allowLooseConversion = true
    }
    
    override func tearDown() {
        Converter.allowLooseConversion = false
        
        super.tearDown()
    }

    func testEqualRatioMeasurementAmountFor() {
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
        XCTAssertTrue(ounce == 128)
        
        let pound = Converter.measurementAmountFor(ingredient, measurementUnit: .Pound)
        XCTAssertTrue(pound == 8)
        
        let milliliter = Converter.measurementAmountFor(ingredient, measurementUnit: .Milliliter)
        XCTAssertTrue(milliliter.twoDecimalValue == 3840)
        
        let liter = Converter.measurementAmountFor(ingredient, measurementUnit: .Liter)
        XCTAssertTrue(liter.twoDecimalValue == 3.84)
        
        let gram = Converter.measurementAmountFor(ingredient, measurementUnit: .Gram)
        XCTAssertTrue(gram.twoDecimalValue == 3840)
        
        let kilogram = Converter.measurementAmountFor(ingredient, measurementUnit: .Kilogram)
        XCTAssertTrue(kilogram.twoDecimalValue == 3.84)
    }
    
    func testEqualRatioScaleUSMassToUSMass() {
        ingredient.measurementAmount = 2
        ingredient.measurementUnit = .Pound
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 0.25, measurementSystemMethod: .USMass)
        XCTAssertTrue(scaleMeasure.amount == 8)
        XCTAssertTrue(scaleMeasure.unit == .Ounce)
    }
    
    func testEqualRatioScaleUSMassToUSVolume() {
        ingredient.measurementAmount = 0.5
        ingredient.measurementUnit = .Pound
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 1.25, measurementSystemMethod: .USVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.25)
        XCTAssertTrue(scaleMeasure.unit == .Cup)
    }
    
    func testEqualRatioScaleUSMassToMetricMass() {
        ingredient.measurementAmount = 10
        ingredient.measurementUnit = .Ounce
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 1.0, measurementSystemMethod: .MetricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 300)
        XCTAssertTrue(scaleMeasure.unit == .Gram)
    }
    
    func testEqualRatioScaleUSMassToMetricVolume() {
        ingredient.measurementAmount = 4
        ingredient.measurementUnit = .Ounce
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 2.0, measurementSystemMethod: .MetricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 240)
        XCTAssertTrue(scaleMeasure.unit == .Milliliter)
    }
    
    func testEqualRatioScaleUSVolumeToUSMass() {
        ingredient.measurementAmount = 4
        ingredient.measurementUnit = .Tablespoon
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 3.5, measurementSystemMethod: .USMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 7)
        XCTAssertTrue(scaleMeasure.unit == .Ounce)
    }
    
    func testEqualRatioScaleUSVolumeToUSVolume() {
        ingredient.measurementAmount = 28
        ingredient.measurementUnit = .Quart
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: Constants.OneSixteenth, measurementSystemMethod: .USVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.75)
        XCTAssertTrue(scaleMeasure.unit == .Quart)
    }
    
    func testEqualRatioScaleUSVolumeToMetricMass() {
        ingredient.measurementAmount = 1
        ingredient.measurementUnit = .Gallon
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 1.75, measurementSystemMethod: .MetricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 6.72)
        XCTAssertTrue(scaleMeasure.unit == .Kilogram)
    }
    
    func testEqualRatioScaleUSVolumeToMetricVolume() {
        ingredient.measurementAmount = 1.3
        ingredient.measurementUnit = .Ounce
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 3.0, measurementSystemMethod: .MetricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 117)
        XCTAssertTrue(scaleMeasure.unit == .Milliliter)
    }
    
    func testEqualRatioScaleMetricMassToUSMass() {
        ingredient.measurementAmount = 250
        ingredient.measurementUnit = .Gram
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: Constants.OneHalf, measurementSystemMethod: .USMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 4.17)
        XCTAssertTrue(scaleMeasure.unit == .Ounce)
    }
    
    func testEqualRatioScaleMetricMassToUSVolume() {
        ingredient.measurementAmount = 1.68
        ingredient.measurementUnit = .Kilogram
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 1.0, measurementSystemMethod: .USVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.75)
        XCTAssertTrue(scaleMeasure.unit == .Quart)
    }
    
    func testEqualRatioScaleMetricMassToMetricMass() {
        ingredient.measurementAmount = 22
        ingredient.measurementUnit = .Kilogram
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: Constants.OneThird, measurementSystemMethod: .MetricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 7.33)
        XCTAssertTrue(scaleMeasure.unit == .Kilogram)
    }
    
    func testEqualRatioScaleMetricMassToMetricVolume() {
        ingredient.measurementAmount = 888.888
        ingredient.measurementUnit = .Gram
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: Constants.TwoThirds, measurementSystemMethod: .MetricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 592.59)
        XCTAssertTrue(scaleMeasure.unit == .Milliliter)
    }
    
    func testEqualRatioScaleMetricVolumeToUSMass() {
        ingredient.measurementAmount = 130
        ingredient.measurementUnit = .Milliliter
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 1.01, measurementSystemMethod: .USMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 4.38)
        XCTAssertTrue(scaleMeasure.unit == .Ounce)
    }
    
    func testEqualRatioScaleMetricVolumeToUSVolume() {
        ingredient.measurementAmount = 2.99
        ingredient.measurementUnit = .Liter
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: Constants.OneSixth, measurementSystemMethod: .USVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 1.04)
        XCTAssertTrue(scaleMeasure.unit == .Pint)
    }
    
    func testEqualRatioScaleMetricVolumeToMetricMass() {
        ingredient.measurementAmount = 45
        ingredient.measurementUnit = .Liter
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: 1.0, measurementSystemMethod: .MetricMass)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 45)
        XCTAssertTrue(scaleMeasure.unit == .Kilogram)
    }
    
    func testEqualRatioScaleMetricVolumeToMetricVolume() {
        ingredient.measurementAmount = 45000
        ingredient.measurementUnit = .Milliliter
        
        let scaleMeasure = Converter.scale(ingredient, multiplier: Constants.OneThousandth, measurementSystemMethod: .MetricVolume)
        XCTAssertTrue(scaleMeasure.amount.twoDecimalValue == 45)
        XCTAssertTrue(scaleMeasure.unit == .Milliliter)
    }
}
