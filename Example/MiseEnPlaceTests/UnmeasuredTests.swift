//
//  AsNeededEachTests.swift
//  miseenplace
//
//  Created by Richard Piazza on 8/6/15.
//  Copyright (c) 2015 Richard Piazza. All rights reserved.
//

import Foundation
import XCTest
import MiseEnPlace

class UnmeasuredTests: XCTestCase {
    var ingredient: ConvertableIngredient = ConvertableIngredient()

    override func setUp() {
        super.setUp()
        
        ingredient.ratio.mass = 1
        ingredient.ratio.volume = 1
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAsNeededConvertAndInterpret() {
        ingredient.measurementUnit = .AsNeeded
        
        let scale = Converter.scale(ingredient, multiplier: 1.0, measurementSystemMethod: .USVolume)
        XCTAssertTrue(scale.amount == 0)
        XCTAssertTrue(scale.unit == .AsNeeded)
        
        let interpret = Interpreter.interpret(scale)
        XCTAssertTrue(interpret == "As Needed")
    }
    
    func testEachConvertAndInterpret() {
        ingredient.measurementUnit = .Each
        ingredient.measurementAmount = 3
        
        let scale = Converter.scale(ingredient, multiplier: OneThird, measurementSystemMethod: .MetricMass)
        XCTAssertTrue(scale.amount == 3.0 * OneThird)
        XCTAssertTrue(scale.unit == .Each)
        
        let interpret = Interpreter.interpret(scale)
        XCTAssertTrue(interpret == "1 Each")
    }
    
    func testEachFractional() {
        ingredient.measurementUnit = .Each
        ingredient.measurementAmount = 1
        
        let scale = Converter.scale(ingredient, multiplier: 1.35, measurementSystemMethod: .MetricMass)
        XCTAssertTrue(scale.amount == 1.35)
        XCTAssertTrue(scale.unit == .Each)
        
        let interpret = Interpreter.interpret(scale)
        XCTAssertTrue(interpret == "1" + OneThirdSymbol + " Each")
    }
}
