import Foundation
@testable import MiseEnPlace

class TestIngredient: Ingredient {
    var uuid: String = UUID().uuidString
    var creationDate: Date = Date()
    var modificationDate: Date = Date()
    var name: String?
    var commentary: String?
    var classification: String?
    var imagePath: String?
    var volume: Double = 1.0
    var weight: Double = 1.0
    var amount: Double = 1.0
    var unit: MeasurementUnit = .ounce
}

class TestRecipe: Recipe {
    var uuid: String = UUID().uuidString
    var creationDate: Date = Date()
    var modificationDate: Date = Date()
    var name: String?
    var commentary: String?
    var classification: String?
    var imagePath: String?
    var amount: Double = 1.0
    var unit: MeasurementUnit = .ounce
    var formulaElements: [FormulaElement] = []
    var procedureElements: [ProcedureElement] = []
}

class TestMeasuredIngredient: FormulaElement {
    var uuid: String = UUID().uuidString
    var creationDate: Date = Date()
    var modificationDate: Date = Date()
    var sequence: Int = 0
    var amount: Double = 1.0
    var unit: MeasurementUnit = .ounce
    var ingredient: Ingredient?
    var recipe: Recipe?
    var inverseRecipe: Recipe?
    
    convenience init(ratio: Ratio) {
        self.init()
        ingredient = TestIngredient()
        ingredient?.volume = ratio.volume
        ingredient?.weight = ratio.weight
    }
}

class TestMeasuredRecipe: FormulaElement {
    var uuid: String = UUID().uuidString
    var creationDate: Date = Date()
    var modificationDate: Date = Date()
    var sequence: Int = 0
    var amount: Double = 1.0
    var unit: MeasurementUnit = .ounce
    var ingredient: Ingredient?
    var recipe: Recipe?
    var inverseRecipe: Recipe?
}
