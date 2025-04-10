import Foundation
@testable import MiseEnPlace
import XCTest

/// Tests created in response to conditions during implementations
class EdgeConditionTests: XCTestCase {

    func testHighVolumeRatioConversion() throws {
        var ingredient = AnyIngredient()
        ingredient.volume = 2.143
        ingredient.weight = 1.0

        var measuredIngredient = AnyFormulaElement(measured: .ingredient(ingredient))
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

        XCTAssertEqual(Quantification(amount: pinch, unit: .pinch).description, "1536⅙ Pinch")
        XCTAssertEqual(Quantification(amount: dash, unit: .dash).description, "768 Dash")
        XCTAssertEqual(Quantification(amount: teaspoon, unit: .teaspoon).description, "96 Teaspoon")
        XCTAssertEqual(Quantification(amount: tablespoon, unit: .tablespoon).description, "32 Tablespoon")
        XCTAssertEqual(Quantification(amount: fluidOunce, unit: .fluidOunce).description, "16 Fluid Ounce")
        XCTAssertEqual(Quantification(amount: cup, unit: .cup).description, "2 Cup")
        XCTAssertEqual(Quantification(amount: pint, unit: .pint).description, "1 Pint")
        XCTAssertEqual(Quantification(amount: quart, unit: .quart).description, "½ Quart")
        XCTAssertEqual(Quantification(amount: gallon, unit: .gallon).description, "⅛ Gallon")
        XCTAssertEqual(Quantification(amount: ounce, unit: .ounce).description, "7½ Ounce")
        XCTAssertEqual(Quantification(amount: pound, unit: .pound).description, "½ Pound")
        XCTAssertEqual(Quantification(amount: milliliter, unit: .milliliter).description, "475 Milliliter")
        XCTAssertEqual(Quantification(amount: liter, unit: .liter).description, "0.5 Liter")
        XCTAssertEqual(Quantification(amount: gram, unit: .gram).description, "210 Gram")
        XCTAssertEqual(Quantification(amount: kilogram, unit: .kilogram).description, "0.2 Kilogram")
    }
}
