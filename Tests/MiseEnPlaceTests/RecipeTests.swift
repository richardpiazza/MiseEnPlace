import Foundation
import XCTest
@testable import MiseEnPlace

class RecipeTests: XCTestCase {
    
    private let italianBread = AnyRecipe.italianBread
    private let poolishBaguette = AnyRecipe.poolishBaguette
    
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
        let formula = poolishBaguette.formula
        
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
    }
    
    @available(*, deprecated)
    func testMoveFormulaElement() {
        var recipe = poolishBaguette
        var formula = recipe.formula
        
        let indices = recipe.moveFormulaElement(formula[2], fromIndex: 2, toIndex: 4)
        XCTAssertEqual(indices.sorted(), [2, 3, 4])
        
        formula = recipe.formula
        
        let water = formula[3]
        
        recipe.removeFormulaElement(water)
        formula = recipe.formula
        
        XCTAssertEqual(formula.count, 4)
        XCTAssertFalse(formula.contains(where: { $0.name == "Water" }))
    }
    
    func testInsertFormulaElement() {
        var recipe = poolishBaguette
        var formulaElement: FormulaElement = AnyFormulaElement(
            measured: .ingredient(AnyIngredient())
        )
        XCTAssertEqual(formulaElement.sequence, 0)
        formulaElement = recipe.appendFormulaElement(formulaElement)
        XCTAssertEqual(formulaElement.sequence, 5)
    }
    
    func testMoveFormulaElements() {
        var recipe = poolishBaguette
        var modifiedElements = recipe.moveFormulaElements(from: IndexSet([2]), to: 4)
        XCTAssertEqual(Set(modifiedElements.map(\.name)), ["Water", "Yeast"])
        XCTAssertEqual(recipe.formula.map(\.name), ["Poolish", "Flour", "Water", "Yeast", "Salt"])
        
        recipe = poolishBaguette
        modifiedElements = recipe.moveFormulaElements(from: IndexSet([2]), to: 5)
        XCTAssertEqual(Set(modifiedElements.map(\.name)), ["Water", "Yeast", "Salt"])
        XCTAssertEqual(recipe.formula.map(\.name), ["Poolish", "Flour", "Water", "Salt", "Yeast"])
        
        recipe = poolishBaguette
        modifiedElements = recipe.moveFormulaElements(from: IndexSet([1, 2]), to: 4)
        XCTAssertEqual(Set(modifiedElements.map(\.name)), ["Flour", "Water", "Yeast"])
        XCTAssertEqual(recipe.formula.map(\.name), ["Poolish", "Water", "Flour", "Yeast", "Salt"])
        
        recipe = poolishBaguette
        modifiedElements = recipe.moveFormulaElements(from: IndexSet([0, 2]), to: 5)
        XCTAssertEqual(Set(modifiedElements.map(\.name)), ["Poolish", "Flour", "Water", "Yeast", "Salt"])
        XCTAssertEqual(recipe.formula.map(\.name), ["Flour", "Water", "Salt", "Poolish", "Yeast"])
        
        recipe = poolishBaguette
        modifiedElements = recipe.moveFormulaElements(from: IndexSet([4]), to: 3)
        XCTAssertEqual(Set(modifiedElements.map(\.name)), ["Water", "Salt"])
        XCTAssertEqual(recipe.formula.map(\.name), ["Poolish", "Flour", "Yeast", "Salt", "Water"])
        
        recipe = poolishBaguette
        modifiedElements = recipe.moveFormulaElements(from: IndexSet([3]), to: 0)
        XCTAssertEqual(Set(modifiedElements.map(\.name)), ["Poolish", "Flour", "Yeast", "Water"])
        XCTAssertEqual(recipe.formula.map(\.name), ["Water", "Poolish", "Flour", "Yeast", "Salt"])
        
        recipe = poolishBaguette
        modifiedElements = recipe.moveFormulaElements(from: IndexSet([2, 3]), to: 1)
        XCTAssertEqual(Set(modifiedElements.map(\.name)), ["Flour", "Yeast", "Water"])
        XCTAssertEqual(recipe.formula.map(\.name), ["Poolish", "Yeast", "Water", "Flour", "Salt"])
        
        recipe = poolishBaguette
        modifiedElements = recipe.moveFormulaElements(from: IndexSet([1, 4]), to: 0)
        XCTAssertEqual(Set(modifiedElements.map(\.name)), ["Poolish", "Yeast", "Water", "Flour", "Salt"])
        XCTAssertEqual(recipe.formula.map(\.name), ["Flour", "Salt", "Poolish", "Yeast", "Water"])
    }
    
    func testDeleteFormulaElements() {
        var recipe = poolishBaguette
        var operation = recipe.deleteFormulaElements(at: IndexSet([4]))
        XCTAssertEqual(Set(operation.modified.map(\.name)), [])
        XCTAssertEqual(Set(operation.removed.map(\.name)), ["Salt"])
        
        recipe = poolishBaguette
        operation = recipe.deleteFormulaElements(at: IndexSet([2]))
        XCTAssertEqual(Set(operation.modified.map(\.name)), ["Water", "Salt"])
        XCTAssertEqual(Set(operation.removed.map(\.name)), ["Yeast"])
        
        recipe = poolishBaguette
        operation = recipe.deleteFormulaElements(at: IndexSet([0]))
        XCTAssertEqual(Set(operation.modified.map(\.name)), ["Flour", "Yeast", "Water", "Salt"])
        XCTAssertEqual(Set(operation.removed.map(\.name)), ["Poolish"])
        
        recipe = poolishBaguette
        operation = recipe.deleteFormulaElements(at: IndexSet([1, 2]))
        XCTAssertEqual(Set(operation.modified.map(\.name)), ["Water", "Salt"])
        XCTAssertEqual(Set(operation.removed.map(\.name)), ["Flour", "Yeast"])
        
        recipe = poolishBaguette
        operation = recipe.deleteFormulaElements(at: IndexSet([1, 4]))
        XCTAssertEqual(Set(operation.modified.map(\.name)), ["Yeast", "Water"])
        XCTAssertEqual(Set(operation.removed.map(\.name)), ["Flour", "Salt"])
    }
    
    func testProcedure() {
        let recipe = poolishBaguette
        
        let summary = recipe.procedureSummary
        XCTAssertEqual(summary, """
        Bring all ingredients together in a mixer.
        Ferment until doubled, approximately 1-2 hours.
        Bake at 450℉ apx 20-22 minutes.
        Enjoy
        """)
        
        let procedure = recipe.procedure
        XCTAssertEqual(procedure.count, 4)
        XCTAssertEqual(procedure[0].sequence, 0)
        XCTAssertTrue((procedure[0].commentary).lowercased().contains("mix"))
        XCTAssertEqual(procedure[1].sequence, 1)
        XCTAssertTrue((procedure[1].commentary).lowercased().contains("ferment"))
        XCTAssertEqual(procedure[2].sequence, 2)
        XCTAssertTrue((procedure[2].commentary).lowercased().contains("bake"))
        XCTAssertEqual(procedure[3].sequence, 3)
        XCTAssertTrue((procedure[3].commentary).lowercased().contains("enjoy"))
    }
    
    @available(*, deprecated)
    func testMoveProcedureElement() {
        var recipe = poolishBaguette
        var procedure = recipe.procedure
        
        recipe.moveProcedureElement(procedure[2], fromIndex: 2, toIndex: 1)
        
        procedure = recipe.procedure
        XCTAssertEqual(procedure.count, 4)
        XCTAssertEqual(procedure[0].sequence, 0)
        XCTAssertTrue((procedure[0].commentary).lowercased().contains("mix"))
        XCTAssertEqual(procedure[1].sequence, 1)
        XCTAssertTrue((procedure[1].commentary).lowercased().contains("bake"))
        XCTAssertEqual(procedure[2].sequence, 2)
        XCTAssertTrue((procedure[2].commentary).lowercased().contains("ferment"))
        XCTAssertEqual(procedure[3].sequence, 3)
        XCTAssertTrue((procedure[3].commentary).lowercased().contains("enjoy"))
    }
    
    func testAppendProcedureElement() {
        var recipe = poolishBaguette
        var procedureElement: ProcedureElement = AnyProcedureElement()
        XCTAssertEqual(procedureElement.sequence, 0)
        procedureElement = recipe.appendProcedureElement(procedureElement)
        XCTAssertEqual(procedureElement.sequence, 4)
    }
    
    func testMoveProcedureElements() {
        var recipe = poolishBaguette
        var modifiedElements = recipe.moveProcedureElements(from: IndexSet([1]), to: 3)
        XCTAssertEqual(Set(modifiedElements.map(\.name)), ["two", "three"])
        XCTAssertEqual(recipe.procedure.map(\.name), ["one", "three", "two", "four"])
        
        recipe = poolishBaguette
        modifiedElements = recipe.moveProcedureElements(from: IndexSet([1]), to: 0)
        XCTAssertEqual(Set(modifiedElements.map(\.name)), ["one", "two"])
        XCTAssertEqual(recipe.procedure.map(\.name), ["two", "one", "three", "four"])
        
        recipe = poolishBaguette
        modifiedElements = recipe.moveProcedureElements(from: IndexSet([0, 1]), to: 4)
        XCTAssertEqual(Set(modifiedElements.map(\.name)), ["one", "two", "three", "four"])
        XCTAssertEqual(recipe.procedure.map(\.name), ["three", "four", "one", "two"])
        
        recipe = poolishBaguette
        modifiedElements = recipe.moveProcedureElements(from: IndexSet([0, 2]), to: 4)
        XCTAssertEqual(Set(modifiedElements.map(\.name)), ["one", "two", "three", "four"])
        XCTAssertEqual(recipe.procedure.map(\.name), ["two", "four", "one", "three"])
        
        recipe = poolishBaguette
        modifiedElements = recipe.moveProcedureElements(from: IndexSet([2, 3]), to: 1)
        XCTAssertEqual(Set(modifiedElements.map(\.name)), ["two", "three", "four"])
        XCTAssertEqual(recipe.procedure.map(\.name), ["one", "three", "four", "two"])
        
        recipe = poolishBaguette
        modifiedElements = recipe.moveProcedureElements(from: IndexSet([1, 3]), to: 0)
        XCTAssertEqual(Set(modifiedElements.map(\.name)), ["one", "two", "three", "four"])
        XCTAssertEqual(recipe.procedure.map(\.name), ["two", "four", "one", "three"])
    }
    
    func testScaling() throws {
        let recipe = poolishBaguette
        
        let formula = try recipe.scale(by: 1.875, measurementSystem: .metric, measurementMethod: .weight)
        XCTAssertEqual(formula.count, 5)
        
        let poolish = formula[0]
        XCTAssertEqual(poolish.measured.recipe?.uuid, AnyRecipe.poolish.uuid)
        XCTAssertEqual(poolish.quantification.amount, 370.0, accuracy: 5)
        XCTAssertEqual(poolish.quantification.unit, .gram)
        
        let flour = formula[1]
        XCTAssertEqual(flour.measured.ingredient?.uuid, AnyIngredient.flour.uuid)
        XCTAssertEqual(flour.quantification.amount, 895.0, accuracy: 10)
        XCTAssertEqual(flour.quantification.unit, .gram)
        
        let yeast = formula[2]
        XCTAssertEqual(yeast.measured.ingredient?.uuid, AnyIngredient.yeast.uuid)
        XCTAssertEqual(yeast.quantification.amount, 42.0, accuracy: 1)
        XCTAssertEqual(yeast.quantification.unit, .gram)
        
        let water = formula[3]
        XCTAssertEqual(water.measured.ingredient?.uuid, AnyIngredient.water.uuid)
        XCTAssertEqual(water.quantification.amount, 525.0, accuracy: 10)
        XCTAssertEqual(water.quantification.unit, .gram)
        
        let salt = formula[4]
        XCTAssertEqual(salt.measured.ingredient?.uuid, AnyIngredient.salt.uuid)
        XCTAssertEqual(salt.quantification.amount, 18.0, accuracy: 1)
        XCTAssertEqual(salt.quantification.unit, .gram)
    }
}
