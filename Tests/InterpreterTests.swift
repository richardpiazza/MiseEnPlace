//
//  InterpreterTests.swift
//  miseenplace
//
//  Created by Richard Piazza on 8/4/15.
//  Copyright (c) 2015 Richard Piazza. All rights reserved.
//

import Foundation
import XCTest
import MiseEnPlace

class InterpreterTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMetricMass() {
        let smallGramMass = MiseEnPlace.Measurement(amount: 7.542, unit: .gram)
        let smallGramMassInterpretation = smallGramMass.componentsTranslation
        XCTAssertTrue(smallGramMassInterpretation == "7.5 Gram")
        
        let mediumGramMass = MiseEnPlace.Measurement(amount: 68.843, unit: .gram)
        let mediumGramMassInterpretation = mediumGramMass.componentsTranslation
        XCTAssertTrue(mediumGramMassInterpretation == "69 Gram")
        
        let largeGramMass = MiseEnPlace.Measurement(amount: 212.43, unit: .gram)
        let largeGramMassInterpretation = largeGramMass.componentsTranslation
        XCTAssertTrue(largeGramMassInterpretation == "210 Gram")
        
        let smallKilogramMass = MiseEnPlace.Measurement(amount: 1.24, unit: .kilogram)
        let smallKilogramMassInterpretation = smallKilogramMass.componentsTranslation
        XCTAssertTrue(smallKilogramMassInterpretation == "1 Kilogram 240 Gram")
        
        let mediumKilogramMass = MiseEnPlace.Measurement(amount: 60.685, unit: .kilogram)
        let mediumKilogramMassInterpretation = mediumKilogramMass.componentsTranslation
        XCTAssertTrue(mediumKilogramMassInterpretation == "60 Kilogram 685 Gram")
        
        let largeKilogramMass = MiseEnPlace.Measurement(amount: 252, unit: .kilogram)
        let largeKilogramMassInterpretation = largeKilogramMass.componentsTranslation
        XCTAssertTrue(largeKilogramMassInterpretation == "252 Kilogram")
    }
    
    func testMetricVolume() {
        let smLVolume = MiseEnPlace.Measurement(amount: 1.25, unit: .milliliter).componentsTranslation
        XCTAssertTrue(smLVolume == "1.2 Milliliter")
        
        let mmLVolume = MiseEnPlace.Measurement(amount: 76.666, unit: .milliliter).componentsTranslation
        XCTAssertTrue(mmLVolume == "77 Milliliter")
        
        let lmLVolume = MiseEnPlace.Measurement(amount: 901.01, unit: .milliliter).componentsTranslation
        XCTAssertTrue(lmLVolume == "900 Milliliter")
        
        let sLVolume = MiseEnPlace.Measurement(amount: 3.75, unit: .liter).componentsTranslation
        XCTAssertTrue(sLVolume == "3 Liter 750 Milliliter")
        
        let mLVolume = MiseEnPlace.Measurement(amount: 99.999, unit: .liter).componentsTranslation
        XCTAssertTrue(mLVolume == "99 Liter 1000 Milliliter")
        
        let lLVolume = MiseEnPlace.Measurement(amount: 624.83, unit: .liter).componentsTranslation
        XCTAssertTrue(lLVolume == "624 Liter 830 Milliliter")
    }
    
    func testUSMass() {
        let sOzMass = MiseEnPlace.Measurement(amount: 2.675, unit: .ounce).componentsTranslation
        XCTAssertTrue(sOzMass == "2" + Fraction.twoThirds.stringValue + " Ounce")
        
        let mOzMass = MiseEnPlace.Measurement(amount: 6.90, unit: .ounce).componentsTranslation
        XCTAssertTrue(mOzMass == "7 Ounce")
        
        let lOzMass = MiseEnPlace.Measurement(amount: 8.5, unit: .ounce).componentsTranslation
        XCTAssertTrue(lOzMass == "8" + Fraction.oneHalf.stringValue + " Ounce")
        
        let lb1 = MiseEnPlace.Measurement(amount: 1.32, unit: .pound).componentsTranslation
        XCTAssertTrue(lb1 == "1 Pound 5 Ounce")
        
        let lb2 = MiseEnPlace.Measurement(amount: 2.55, unit: .pound).componentsTranslation
        XCTAssertTrue(lb2 == "2 Pound 8" + Fraction.threeFourths.stringValue + " Ounce")
        
        let lb3 = MiseEnPlace.Measurement(amount: 250.0, unit: .pound).componentsTranslation
        XCTAssertTrue(lb3 == "250 Pound")
    }
    
    func testUSVolume() {
        let pinchTest = MiseEnPlace.Measurement(amount: 1.5, unit: .pinch).componentsTranslation
        XCTAssertTrue(pinchTest == "1" + Fraction.oneHalf.stringValue + " Pinch")
        
        let dashTest = MiseEnPlace.Measurement(amount: 0.75, unit: .dash).componentsTranslation
        XCTAssertTrue(dashTest == Fraction.threeFourths.stringValue + " Dash")
        
        let teaspoonTest = MiseEnPlace.Measurement(amount: 2.66, unit: .teaspoon).componentsTranslation
        XCTAssertTrue(teaspoonTest == "2 " + Fraction.twoThirds.stringValue + " Teaspoon")
        
        let tableSpoonTest = MiseEnPlace.Measurement(amount: 3.5, unit: .tablespoon).componentsTranslation
        XCTAssertTrue(tableSpoonTest == "3 Tablespoon 1" + Fraction.oneHalf.stringValue + " Teaspoon")
        
        let fluidOunceTest = MiseEnPlace.Measurement(amount: 8.111, unit: .fluidOunce).componentsTranslation
        XCTAssertTrue(fluidOunceTest == "8 Fluid Ounce " + Fraction.oneFourth.stringValue + " Tablespoon")
        
        let cupTest = MiseEnPlace.Measurement(amount: 4.625, unit: .cup).componentsTranslation
        XCTAssertTrue(cupTest == "4 " + Fraction.fiveEighths.stringValue + " Cup")
        
        let pintTest = MiseEnPlace.Measurement(amount: 2.778, unit: .pint).componentsTranslation
        XCTAssertTrue(pintTest == "2 Pint 1" + Fraction.oneHalf.stringValue + " Cup")
        
        let quartTest = MiseEnPlace.Measurement(amount: 3.333, unit: .quart).componentsTranslation
        XCTAssertTrue(quartTest == "3 Quart " + Fraction.twoThirds.stringValue + " Pint")
        
        let gallonTest = MiseEnPlace.Measurement(amount: 1.789, unit: .gallon).componentsTranslation
        XCTAssertTrue(gallonTest == "1 Gallon 3" + Fraction.oneEighth.stringValue + " Quart")
    }
    
    func testEdgeConditions() {
        let cupTest = MiseEnPlace.Measurement(amount: 2.5, unit: .cup).componentsTranslation
        XCTAssertTrue(cupTest == "2 " + Fraction.oneHalf.stringValue + " Cup")
    }
}
