import Foundation
import XCTest
@testable import MiseEnPlace

class EachMeasurementUnitTests: XCTestCase {
    
    private lazy var egg: Ingredient = {
        var ingredient = AnyIngredient()
        ingredient.eachQuantification = Quantification(amount: 50, unit: .gram)
        return ingredient
    }()
    
    private lazy var eggWhite: Ingredient = {
        var ingredient = AnyIngredient()
        ingredient.eachQuantification = Quantification(amount: 25, unit: .gram)
        return ingredient
    }()
    
    private lazy var eggYolk: Ingredient = {
        var ingredient = AnyIngredient()
        ingredient.eachQuantification = Quantification(amount: 25, unit: .gram)
        return ingredient
    }()
    
    private lazy var measuredEgg: FormulaElement = {
        var measuredIngredient = AnyFormulaElement(measured: .ingredient(egg))
        return measuredIngredient
    }()
    
    private lazy var measuredEggWhite: FormulaElement = {
        var measuredIngredient = AnyFormulaElement(measured: .ingredient(eggWhite))
        return measuredIngredient
    }()
    
    private lazy var measuredEggYolk: FormulaElement = {
        var measuredIngredient = AnyFormulaElement(measured: .ingredient(eggYolk))
        return measuredIngredient
    }()
    
    func testEgg() throws {
        measuredEgg.amount = 4
        measuredEgg.unit = .noUnit
        
        var interpretation = measuredEgg.quantification.componentsTranslation
        XCTAssertEqual(interpretation, "4")
        
        var scaleMeasure = try measuredEgg.scale(by: 2.0, measurementSystem: .numeric, measurementMethod: .quantity)
        XCTAssertEqual(scaleMeasure.amount, 8)
        XCTAssertEqual(scaleMeasure.unit, .noUnit)
        
        interpretation = scaleMeasure.componentsTranslation
        XCTAssertEqual(interpretation, "8")
        
        scaleMeasure = try measuredEgg.scale(by: 1.0, measurementSystem: .metric, measurementMethod: .weight)
        XCTAssertEqual(scaleMeasure.amount, 200)
        XCTAssertEqual(scaleMeasure.unit, .gram)
        
        interpretation = scaleMeasure.componentsTranslation
        XCTAssertEqual(interpretation, "200 Gram")
        
        measuredEgg.amount = 200
        measuredEgg.unit = .gram
        
        scaleMeasure = try measuredEgg.scale(by: 1.0, measurementSystem: .numeric, measurementMethod: .quantity)
        XCTAssertEqual(scaleMeasure.amount, 4)
        XCTAssertEqual(scaleMeasure.unit, .noUnit)
    }
    
    func testEggWhite() throws {
        measuredEggWhite.amount = 8
        measuredEggWhite.unit = .fluidOunce
        
        let interpretation = measuredEggWhite.quantification.componentsTranslation
        XCTAssertEqual(interpretation, "8 Fluid Ounce")
        
        let scaleMeasure = try measuredEggWhite.scale(by: 1.0, measurementSystem: .numeric, measurementMethod: .quantity)
        XCTAssertEqual(scaleMeasure.amount, 9.07, accuracy: 0.01)
        XCTAssertEqual(scaleMeasure.unit, .noUnit)
    }
    
    func testEggYolk() throws {
        measuredEggYolk.amount = 4.0
        measuredEggYolk.unit = .noUnit
        
        let interpretation = measuredEggYolk.quantification.componentsTranslation
        XCTAssertEqual(interpretation, "4")
        
        var scaleMeasure = try measuredEggYolk.scale(by: 3.0, measurementSystem: nil, measurementMethod: nil)
        XCTAssertEqual(scaleMeasure.amount, 12)
        XCTAssertEqual(scaleMeasure.unit, .noUnit)
        
        scaleMeasure = try measuredEggYolk.scale(by: 3.0, measurementSystem: .metric, measurementMethod: .weight)
        XCTAssertEqual(scaleMeasure.amount, 100)
        XCTAssertEqual(scaleMeasure.unit, .gram)
    }
}
