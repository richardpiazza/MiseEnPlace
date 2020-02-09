import Foundation
@testable import MiseEnPlace

struct TestMeasuredIngredient: FormulaElement {
    var uuid: UUID = UUID()
    var creationDate: Date = Date()
    var modificationDate: Date = Date()
    var sequence: Int = 0
    var amount: Double = 1.0
    var unit: MeasurementUnit = .ounce
    var ingredient: Ingredient? = TestIngredient()
    var recipe: Recipe?
    var inverseRecipe: Recipe?
    
    init() {
    }
    
    init(ratio: Ratio) {
        ingredient?.volume = ratio.volume
        ingredient?.weight = ratio.weight
    }
    
    init(inverseRecipe: Recipe, ingredient: Ingredient? = nil) {
        self.inverseRecipe = inverseRecipe
        self.ingredient = ingredient ?? TestIngredient()
    }
}
