import Foundation
import XCTest
@testable import MiseEnPlace

/// Tests created in response to conditions during implementations
class EdgeConditionTests: XCTestCase {
    
    static var allTests = [
        ("testHighVolumeRatioConversion", testHighVolumeRatioConversion),
    ]
    
    func testHighVolumeRatioConversion() throws {
        var ingredient = TestIngredient()
        ingredient.volume = 2.143
        ingredient.weight = 1.0
        
        var measuredIngredient = TestMeasuredIngredient()
        measuredIngredient.ingredient = ingredient
        measuredIngredient.amount = 1.0
        measuredIngredient.unit = .pint
        
        let pinch = try measuredIngredient.amount(for: .pinch)
        let dash = try measuredIngredient.amount(for: .dash)
        let teaspoon = try measuredIngredient.amount(for: .teaspoon)
        let tablespoon = try measuredIngredient.amount(for: .tablespoon)
        let fluidOunce = try measuredIngredient.amount(for: .fluidOunce)
        let cup = try measuredIngredient.amount(for: .cup)
        let pint = try measuredIngredient.amount(for: .pint)
        let quart = try measuredIngredient.amount(for: .quart)
        let gallon = try measuredIngredient.amount(for: .gallon)
        let ounce = try measuredIngredient.amount(for: .ounce)
        let pound = try measuredIngredient.amount(for: .pound)
        let milliliter = try measuredIngredient.amount(for: .milliliter)
        let liter = try measuredIngredient.amount(for: .liter)
        let gram = try measuredIngredient.amount(for: .gram)
        let kilogram = try measuredIngredient.amount(for: .kilogram)
        
        XCTAssertEqual(pinch, 1536.154, accuracy: 0.01)
        XCTAssertEqual(dash, 768.077, accuracy: 0.01)
        XCTAssertEqual(teaspoon, 96, accuracy: 0.01)
        XCTAssertEqual(tablespoon, 32, accuracy: 0.01)
        XCTAssertEqual(fluidOunce, 16, accuracy: 0.01)
        XCTAssertEqual(cup, 2, accuracy: 0.01)
        XCTAssertEqual(pint, 1, accuracy: 0.01)
        XCTAssertEqual(quart, 0.5, accuracy: 0.01)
        XCTAssertEqual(gallon, 0.125, accuracy: 0.01)
        XCTAssertEqual(ounce, 7.466, accuracy: 0.01)
        XCTAssertEqual(pound, 0.466, accuracy: 0.01)
        XCTAssertEqual(milliliter, 473.176, accuracy: 0.01)
        XCTAssertEqual(liter, 0.473, accuracy: 0.01)
        XCTAssertEqual(gram, 211.662, accuracy: 0.01)
        XCTAssertEqual(kilogram, 0.212, accuracy: 0.01)
        
        XCTAssertEqual(Quantification(amount: pinch, unit: .pinch).translation, "1536⅙ Pinch")
        XCTAssertEqual(Quantification(amount: dash, unit: .dash).translation, "768 Dash")
        XCTAssertEqual(Quantification(amount: teaspoon, unit: .teaspoon).translation, "96 Teaspoon")
        XCTAssertEqual(Quantification(amount: tablespoon, unit: .tablespoon).translation, "32 Tablespoon")
        XCTAssertEqual(Quantification(amount: fluidOunce, unit: .fluidOunce).translation, "16 Fluid Ounce")
        XCTAssertEqual(Quantification(amount: cup, unit: .cup).translation, "2 Cup")
        XCTAssertEqual(Quantification(amount: pint, unit: .pint).translation, "1 Pint")
        XCTAssertEqual(Quantification(amount: quart, unit: .quart).translation, "½ Quart")
        XCTAssertEqual(Quantification(amount: gallon, unit: .gallon).translation, "⅛ Gallon")
        XCTAssertEqual(Quantification(amount: ounce, unit: .ounce).translation, "7½ Ounce")
        XCTAssertEqual(Quantification(amount: pound, unit: .pound).translation, "½ Pound")
        XCTAssertEqual(Quantification(amount: milliliter, unit: .milliliter).translation, "475 Milliliter")
        XCTAssertEqual(Quantification(amount: liter, unit: .liter).translation, "0.5 Liter")
        XCTAssertEqual(Quantification(amount: gram, unit: .gram).translation, "210 Gram")
        XCTAssertEqual(Quantification(amount: kilogram, unit: .kilogram).translation, "0.2 Kilogram")
    }
}
