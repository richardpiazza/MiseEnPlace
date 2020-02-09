import Foundation
import XCTest
@testable import MiseEnPlace

class EachMeasurementUnitTests: XCTestCase {
    
    static var allTests = [
        ("testEgg", testEgg),
        ("testEggWhite", testEggWhite),
        ("testEggYolk", testEggYolk),
    ]
    
    private lazy var egg: TestIngredient = {
        var ingredient = TestIngredient()
        ingredient.eachQuantification = Quantification(amount: 50, unit: .gram)
        return ingredient
    }()
    
    private lazy var eggWhite: TestIngredient = {
        var ingredient = TestIngredient()
        ingredient.eachQuantification = Quantification(amount: 25, unit: .gram)
        return ingredient
    }()
    
    private lazy var eggYolk: TestIngredient = {
        var ingredient = TestIngredient()
        ingredient.eachQuantification = Quantification(amount: 25, unit: .gram)
        return ingredient
    }()
    
    private lazy var measuredEgg: TestMeasuredIngredient = {
        var measuredIngredient = TestMeasuredIngredient()
        measuredIngredient.ingredient = egg
        return measuredIngredient
    }()
    
    private lazy var measuredEggWhite: TestMeasuredIngredient = {
        var measuredIngredient = TestMeasuredIngredient()
        measuredIngredient.ingredient = eggWhite
        return measuredIngredient
    }()
    
    private lazy var measuredEggYolk: TestMeasuredIngredient = {
        var measuredIngredient = TestMeasuredIngredient()
        measuredIngredient.ingredient = eggYolk
        return measuredIngredient
    }()
    
    func testEgg() throws {
        measuredEgg.amount = 4
        measuredEgg.unit = .each
        
        var interpretation = measuredEgg.quantification.componentsTranslation
        XCTAssertEqual(interpretation, "4 Each")
        
        var scaleMeasure = try measuredEgg.scale(by: 2.0, measurementSystem: .numeric, measurementMethod: .quantity)
        XCTAssertEqual(scaleMeasure.amount, 8)
        XCTAssertEqual(scaleMeasure.unit, .each)
        
        interpretation = scaleMeasure.componentsTranslation
        XCTAssertEqual(interpretation, "8 Each")
        
        scaleMeasure = try measuredEgg.scale(by: 1.0, measurementSystem: .metric, measurementMethod: .weight)
        XCTAssertEqual(scaleMeasure.amount, 200)
        XCTAssertEqual(scaleMeasure.unit, .gram)
        
        interpretation = scaleMeasure.componentsTranslation
        XCTAssertEqual(interpretation, "200 Gram")
        
        measuredEgg.amount = 200
        measuredEgg.unit = .gram
        
        scaleMeasure = try measuredEgg.scale(by: 1.0, measurementSystem: .numeric, measurementMethod: .quantity)
        XCTAssertEqual(scaleMeasure.amount, 4)
        XCTAssertEqual(scaleMeasure.unit, .each)
    }
    
    func testEggWhite() throws {
        measuredEggWhite.amount = 8
        measuredEggWhite.unit = .fluidOunce
        
        let interpretation = measuredEggWhite.quantification.componentsTranslation
        XCTAssertEqual(interpretation, "8 Fluid Ounce")
        
        let scaleMeasure = try measuredEggWhite.scale(by: 1.0, measurementSystem: .numeric, measurementMethod: .quantity)
        XCTAssertEqual(scaleMeasure.amount, 9.07, accuracy: 0.01)
        XCTAssertEqual(scaleMeasure.unit, .each)
    }
    
    func testEggYolk() throws {
        measuredEggYolk.amount = 4.0
        measuredEggYolk.unit = .each
        
        let interpretation = measuredEggYolk.quantification.componentsTranslation
        XCTAssertEqual(interpretation, "4 Each")
        
        var scaleMeasure = try measuredEggYolk.scale(by: 3.0, measurementSystem: nil, measurementMethod: nil)
        XCTAssertEqual(scaleMeasure.amount, 12)
        XCTAssertEqual(scaleMeasure.unit, .each)
        
        scaleMeasure = try measuredEggYolk.scale(by: 3.0, measurementSystem: .metric, measurementMethod: .weight)
        XCTAssertEqual(scaleMeasure.amount, 100)
        XCTAssertEqual(scaleMeasure.unit, .gram)
    }
}
