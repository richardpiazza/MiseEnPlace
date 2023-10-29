import Foundation
@testable import MiseEnPlace

struct TestMeasuredIngredient: FormulaElement {
    var uuid: UUID = UUID()
    var creationDate: Date = Date()
    var modificationDate: Date = Date()
    var sequence: Int = 0
    var amount: Double = 1.0
    var unit: MeasurementUnit = .ounce
    var inverseRecipe: Recipe?
    var measured: Measured = .ingredient(TestIngredient())
    
    init() {
    }
    
    init(ratio: Ratio) {
        var ingredient = TestIngredient()
        ingredient.volume = ratio.volume
        ingredient.weight = ratio.weight
        measured = .ingredient(ingredient)
    }
    
    init(inverseRecipe: Recipe, ingredient: Ingredient? = nil) {
        self.inverseRecipe = inverseRecipe
        if let ingredient = ingredient {
            measured = .ingredient(ingredient)
        }
    }
}
