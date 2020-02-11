import Foundation
import XCTest
@testable import MiseEnPlace

class RecipeTests: XCTestCase {
    
    static var allTests = [
        ("testTotalAmount", testTotalAmount),
        ("testYield", testYield),
        ("testPortion", testPortion),
        ("testFormula", testFormula),
        ("testProcedure", testProcedure),
        ("testScaling", testScaling),
    ]
    
    private let italianBread = TestRecipe.italianBread
    private let poolishBaguette = TestRecipe.poolishBaguette
    
    func testTotalAmount() {
        XCTAssertEqual(italianBread.totalAmount(for: .gram), 2811.0, accuracy: 0.1)
        XCTAssertEqual(italianBread.totalAmount(for: .ounce), 99.2, accuracy: 0.1)
        
        XCTAssertEqual(poolishBaguette.totalAmount(for: .gram), 996.49, accuracy: 0.01)
        XCTAssertEqual(poolishBaguette.totalAmount(for: .ounce), 35.15, accuracy: 0.01)
    }
    
    func testYield() throws {
        XCTAssertEqual(italianBread.yield, 4.0, accuracy: 0.1)
        XCTAssertEqual(italianBread.yieldString, "4 portions")
        XCTAssertEqual(italianBread.yieldTranslation, "2810 Gram, 4 portions")
        XCTAssertEqual(italianBread.yieldTranslationNormalized, "2 Kilogram 810 Gram, 4 portions")
        
        XCTAssertEqual(poolishBaguette.yield, 2, accuracy: 0.1)
        XCTAssertEqual(poolishBaguette.yieldString, "2 portions")
        XCTAssertEqual(poolishBaguette.yieldTranslation, "35⅙ Ounce, 2 portions")
        XCTAssertEqual(poolishBaguette.yieldTranslationNormalized, "2 Pound 3⅙ Ounce, 2 portions")
    }
    
    func testPortion() {
        XCTAssertEqual(italianBread.portion.amount, 702.5)
        XCTAssertEqual(italianBread.portion.unit, .gram)
        
        XCTAssertEqual(poolishBaguette.portion.amount, 17.5)
        XCTAssertEqual(poolishBaguette.portion.unit, .ounce)
    }
    
    func testFormula() {
        var recipe = poolishBaguette
        
        var formula = recipe.formula
        
        XCTAssertEqual(formula.count, 5)
        XCTAssertEqual(formula[0].sequence, 0)
        XCTAssertEqual(formula[0].isMeasuredRecipe, true)
        XCTAssertEqual(formula[0].name, "Poolish")
        XCTAssertEqual(formula[1].sequence, 1)
        XCTAssertEqual(formula[1].isMeasuredIngredient, true)
        XCTAssertEqual(formula[1].name, "Flour")
        XCTAssertEqual(formula[2].sequence, 2)
        XCTAssertEqual(formula[2].isMeasuredIngredient, true)
        XCTAssertEqual(formula[2].name, "Yeast")
        XCTAssertEqual(formula[3].sequence, 3)
        XCTAssertEqual(formula[3].isMeasuredIngredient, true)
        XCTAssertEqual(formula[3].name, "Water")
        XCTAssertEqual(formula[4].sequence, 4)
        XCTAssertEqual(formula[4].isMeasuredIngredient, true)
        XCTAssertEqual(formula[4].name, "Salt")
        
        let indices = recipe.moveFormulaElement(formula[2], fromIndex: 2, toIndex: 4)
        XCTAssertEqual(indices.sorted(), [2, 3, 4])
        
        formula = recipe.formula
        
        let water = formula[3]
        
        recipe.removeFormulaElement(water)
        formula = recipe.formula
        
        XCTAssertEqual(formula.count, 4)
        XCTAssertFalse(formula.contains(where: { $0.name == "Water" }))
    }
    
    func testProcedure() {
        var recipe = poolishBaguette
        
        var procedure = recipe.procedure
        XCTAssertEqual(procedure.count, 3)
        XCTAssertEqual(procedure[0].sequence, 0)
        XCTAssertTrue((procedure[0].commentary ?? "").lowercased().contains("mix"))
        XCTAssertEqual(procedure[1].sequence, 1)
        XCTAssertTrue((procedure[1].commentary ?? "").lowercased().contains("ferment"))
        XCTAssertEqual(procedure[2].sequence, 2)
        XCTAssertTrue((procedure[2].commentary ?? "").lowercased().contains("bake"))
        
        recipe.moveProcedureElement(procedure[2], fromIndex: 2, toIndex: 1)
        
        procedure = recipe.procedure
        XCTAssertEqual(procedure.count, 3)
        XCTAssertEqual(procedure[0].sequence, 0)
        XCTAssertTrue((procedure[0].commentary ?? "").lowercased().contains("mix"))
        XCTAssertEqual(procedure[1].sequence, 1)
        XCTAssertTrue((procedure[1].commentary ?? "").lowercased().contains("bake"))
        XCTAssertEqual(procedure[2].sequence, 2)
        XCTAssertTrue((procedure[2].commentary ?? "").lowercased().contains("ferment"))
    }
    
    func testScaling() throws {
        let recipe = poolishBaguette
        
        let formula = try recipe.scale(by: 1.875, measurementSystem: .metric, measurementMethod: .weight)
        XCTAssertEqual(formula.count, 5)
        
        let poolish = formula[0]
        XCTAssertEqual(poolish.recipe?.id, TestRecipe.poolish.id)
        XCTAssertEqual(poolish.quantification.amount, 370.0, accuracy: 5)
        XCTAssertEqual(poolish.quantification.unit, .gram)
        
        let flour = formula[1]
        XCTAssertEqual(flour.ingredient?.id, TestIngredient.flour.id)
        XCTAssertEqual(flour.quantification.amount, 895.0, accuracy: 10)
        XCTAssertEqual(flour.quantification.unit, .gram)
        
        let yeast = formula[2]
        XCTAssertEqual(yeast.ingredient?.id, TestIngredient.yeast.id)
        XCTAssertEqual(yeast.quantification.amount, 42.0, accuracy: 1)
        XCTAssertEqual(yeast.quantification.unit, .gram)
        
        let water = formula[3]
        XCTAssertEqual(water.ingredient?.id, TestIngredient.water.id)
        XCTAssertEqual(water.quantification.amount, 525.0, accuracy: 10)
        XCTAssertEqual(water.quantification.unit, .gram)
        
        let salt = formula[4]
        XCTAssertEqual(salt.ingredient?.id, TestIngredient.salt.id)
        XCTAssertEqual(salt.quantification.amount, 18.0, accuracy: 1)
        XCTAssertEqual(salt.quantification.unit, .gram)
    }
}
