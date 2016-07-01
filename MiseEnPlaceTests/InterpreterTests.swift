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
        let smallGramMass: ScaleMeasure = (7.542, .Gram)
        let smallGramMassInterpretation = Interpreter.interpret(smallGramMass)
        XCTAssertTrue(smallGramMassInterpretation == "7.5 Gram")
        
        let mediumGramMass: ScaleMeasure = (68.843, .Gram)
        let mediumGramMassInterpretation = Interpreter.interpret(mediumGramMass)
        XCTAssertTrue(mediumGramMassInterpretation == "69 Gram")
        
        let largeGramMass: ScaleMeasure = (212.43, .Gram)
        let largeGramMassInterpretation = Interpreter.interpret(largeGramMass)
        XCTAssertTrue(largeGramMassInterpretation == "210 Gram")
        
        let smallKilogramMass: ScaleMeasure = (1.24, .Kilogram)
        let smallKilogramMassInterpretation = Interpreter.interpret(smallKilogramMass)
        XCTAssertTrue(smallKilogramMassInterpretation == "1 Kilogram 240 Gram")
        
        let mediumKilogramMass: ScaleMeasure = (60.685, .Kilogram)
        let mediumKilogramMassInterpretation = Interpreter.interpret(mediumKilogramMass)
        XCTAssertTrue(mediumKilogramMassInterpretation == "60 Kilogram 685 Gram")
        
        let largeKilogramMass: ScaleMeasure = (252, .Kilogram)
        let largeKilogramMassInterpretation = Interpreter.interpret(largeKilogramMass)
        XCTAssertTrue(largeKilogramMassInterpretation == "252 Kilogram")
    }
    
    func testMetricVolume() {
        let smLVolume = Interpreter.interpret((1.25, .Milliliter))
        XCTAssertTrue(smLVolume == "1.2 Milliliter")
        
        let mmLVolume = Interpreter.interpret((76.666, .Milliliter))
        XCTAssertTrue(mmLVolume == "77 Milliliter")
        
        let lmLVolume = Interpreter.interpret((901.01, .Milliliter))
        XCTAssertTrue(lmLVolume == "900 Milliliter")
        
        let sLVolume = Interpreter.interpret((3.75, .Liter))
        XCTAssertTrue(sLVolume == "3 Liter 750 Milliliter")
        
        let mLVolume = Interpreter.interpret((99.999, .Liter))
        XCTAssertTrue(mLVolume == "99 Liter 1000 Milliliter")
        
        let lLVolume = Interpreter.interpret((624.83, .Liter))
        XCTAssertTrue(lLVolume == "624 Liter 830 Milliliter")
    }
    
    func testUSMass() {
        let sOzMass = Interpreter.interpret((2.675, .Ounce))
        XCTAssertTrue(sOzMass == "2" + TwoThirdsSymbol + " Ounce")
        
        let mOzMass = Interpreter.interpret((6.90, .Ounce))
        XCTAssertTrue(mOzMass == "7 Ounce")
        
        let lOzMass = Interpreter.interpret((8.5, .Ounce))
        XCTAssertTrue(lOzMass == "8" + OneHalfSymbol + " Ounce")
        
        let lb1 = Interpreter.interpret((1.32, .Pound))
        XCTAssertTrue(lb1 == "1 Pound 5 Ounce")
        
        let lb2 = Interpreter.interpret((2.55, .Pound))
        XCTAssertTrue(lb2 == "2 Pound 8" + ThreeFourthsSymbol + " Ounce")
        
        let lb3 = Interpreter.interpret((250.0, .Pound))
        XCTAssertTrue(lb3 == "250 Pound")
    }
    
    func testUSVolume() {
        let pinchTest = Interpreter.interpret((1.5, .Pinch))
        XCTAssertTrue(pinchTest == "1" + OneHalfSymbol + " Pinch")
        
        let dashTest = Interpreter.interpret((0.75, .Dash))
        XCTAssertTrue(dashTest == ThreeFourthsSymbol + " Dash")
        
        let teaspoonTest = Interpreter.interpret((2.66, .Teaspoon))
        XCTAssertTrue(teaspoonTest == "2" + TwoThirdsSymbol + " Teaspoon")
        
        let tableSpoonTest = Interpreter.interpret((3.5, .Tablespoon))
        XCTAssertTrue(tableSpoonTest == "3 Tablespoon 1" + OneHalfSymbol + " Teaspoon")
        
        let fluidOunceTest = Interpreter.interpret((8.111, .FluidOunce))
        XCTAssertTrue(fluidOunceTest == "8 Fluid Ounce " + OneFourthSymbol + " Tablespoon")
        
        let cupTest = Interpreter.interpret((4.625, .Cup))
        XCTAssertTrue(cupTest == "4 Cup 5 Fluid Ounce")
        
        let pintTest = Interpreter.interpret((2.778, .Pint))
        XCTAssertTrue(pintTest == "2 Pint 1" + OneHalfSymbol + " Cup")
        
        let quartTest = Interpreter.interpret((3.333, .Quart))
        XCTAssertTrue(quartTest == "3 Quart " + TwoThirdsSymbol + " Pint")
        
        let gallonTest = Interpreter.interpret((1.789, .Gallon))
        XCTAssertTrue(gallonTest == "1 Gallon 3 Quart")
    }
}
