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
        let smallGramMass = ScaleMeasure(amount: 7.542, unit: .gram)
        let smallGramMassInterpretation = Interpreter.interpret(smallGramMass)
        XCTAssertTrue(smallGramMassInterpretation == "7.5 Gram")
        
        let mediumGramMass = ScaleMeasure(amount: 68.843, unit: .gram)
        let mediumGramMassInterpretation = Interpreter.interpret(mediumGramMass)
        XCTAssertTrue(mediumGramMassInterpretation == "69 Gram")
        
        let largeGramMass = ScaleMeasure(amount: 212.43, unit: .gram)
        let largeGramMassInterpretation = Interpreter.interpret(largeGramMass)
        XCTAssertTrue(largeGramMassInterpretation == "210 Gram")
        
        let smallKilogramMass = ScaleMeasure(amount: 1.24, unit: .kilogram)
        let smallKilogramMassInterpretation = Interpreter.interpret(smallKilogramMass)
        XCTAssertTrue(smallKilogramMassInterpretation == "1 Kilogram 240 Gram")
        
        let mediumKilogramMass = ScaleMeasure(amount: 60.685, unit: .kilogram)
        let mediumKilogramMassInterpretation = Interpreter.interpret(mediumKilogramMass)
        XCTAssertTrue(mediumKilogramMassInterpretation == "60 Kilogram 685 Gram")
        
        let largeKilogramMass = ScaleMeasure(amount: 252, unit: .kilogram)
        let largeKilogramMassInterpretation = Interpreter.interpret(largeKilogramMass)
        XCTAssertTrue(largeKilogramMassInterpretation == "252 Kilogram")
    }
    
    func testMetricVolume() {
        let smLVolume = Interpreter.interpret(ScaleMeasure(amount: 1.25, unit: .milliliter))
        XCTAssertTrue(smLVolume == "1.2 Milliliter")
        
        let mmLVolume = Interpreter.interpret(ScaleMeasure(amount: 76.666, unit: .milliliter))
        XCTAssertTrue(mmLVolume == "77 Milliliter")
        
        let lmLVolume = Interpreter.interpret(ScaleMeasure(amount: 901.01, unit: .milliliter))
        XCTAssertTrue(lmLVolume == "900 Milliliter")
        
        let sLVolume = Interpreter.interpret(ScaleMeasure(amount: 3.75, unit: .liter))
        XCTAssertTrue(sLVolume == "3 Liter 750 Milliliter")
        
        let mLVolume = Interpreter.interpret(ScaleMeasure(amount: 99.999, unit: .liter))
        XCTAssertTrue(mLVolume == "99 Liter 1000 Milliliter")
        
        let lLVolume = Interpreter.interpret(ScaleMeasure(amount: 624.83, unit: .liter))
        XCTAssertTrue(lLVolume == "624 Liter 830 Milliliter")
    }
    
    func testUSMass() {
        let sOzMass = Interpreter.interpret(ScaleMeasure(amount: 2.675, unit: .ounce))
        XCTAssertTrue(sOzMass == "2" + Constants.TwoThirdsSymbol + " Ounce")
        
        let mOzMass = Interpreter.interpret(ScaleMeasure(amount: 6.90, unit: .ounce))
        XCTAssertTrue(mOzMass == "7 Ounce")
        
        let lOzMass = Interpreter.interpret(ScaleMeasure(amount: 8.5, unit: .ounce))
        XCTAssertTrue(lOzMass == "8" + Constants.OneHalfSymbol + " Ounce")
        
        let lb1 = Interpreter.interpret(ScaleMeasure(amount: 1.32, unit: .pound))
        XCTAssertTrue(lb1 == "1 Pound 5 Ounce")
        
        let lb2 = Interpreter.interpret(ScaleMeasure(amount: 2.55, unit: .pound))
        XCTAssertTrue(lb2 == "2 Pound 8" + Constants.ThreeFourthsSymbol + " Ounce")
        
        let lb3 = Interpreter.interpret(ScaleMeasure(amount: 250.0, unit: .pound))
        XCTAssertTrue(lb3 == "250 Pound")
    }
    
    func testUSVolume() {
        let pinchTest = Interpreter.interpret(ScaleMeasure(amount: 1.5, unit: .pinch))
        XCTAssertTrue(pinchTest == "1" + Constants.OneHalfSymbol + " Pinch")
        
        let dashTest = Interpreter.interpret(ScaleMeasure(amount: 0.75, unit: .dash))
        XCTAssertTrue(dashTest == Constants.ThreeFourthsSymbol + " Dash")
        
        let teaspoonTest = Interpreter.interpret(ScaleMeasure(amount: 2.66, unit: .teaspoon))
        XCTAssertTrue(teaspoonTest == "2 " + Constants.TwoThirdsSymbol + " Teaspoon")
        
        let tableSpoonTest = Interpreter.interpret(ScaleMeasure(amount: 3.5, unit: .tablespoon))
        XCTAssertTrue(tableSpoonTest == "3 Tablespoon 1" + Constants.OneHalfSymbol + " Teaspoon")
        
        let fluidOunceTest = Interpreter.interpret(ScaleMeasure(amount: 8.111, unit: .fluidOunce))
        XCTAssertTrue(fluidOunceTest == "8 Fluid Ounce " + Constants.OneFourthSymbol + " Tablespoon")
        
        let cupTest = Interpreter.interpret(ScaleMeasure(amount: 4.625, unit: .cup))
        XCTAssertTrue(cupTest == "4 " + Constants.FiveEighthsSymbol + " Cup")
        
        let pintTest = Interpreter.interpret(ScaleMeasure(amount: 2.778, unit: .pint))
        XCTAssertTrue(pintTest == "2 Pint 1" + Constants.OneHalfSymbol + " Cup")
        
        let quartTest = Interpreter.interpret(ScaleMeasure(amount: 3.333, unit: .quart))
        XCTAssertTrue(quartTest == "3 Quart " + Constants.TwoThirdsSymbol + " Pint")
        
        let gallonTest = Interpreter.interpret(ScaleMeasure(amount: 1.789, unit: .gallon))
        XCTAssertTrue(gallonTest == "1 Gallon 3 Quart")
    }
    
    func testEdgeConditions() {
        let cupTest = Interpreter.interpret(ScaleMeasure(amount: 2.5, unit: .cup))
        XCTAssertTrue(cupTest == "2 " + Constants.OneHalfSymbol + " Cup")
    }
}
