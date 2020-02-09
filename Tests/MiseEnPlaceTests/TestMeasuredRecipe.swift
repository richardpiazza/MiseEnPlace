import Foundation
@testable import MiseEnPlace

struct TestMeasuredRecipe: FormulaElement {
    var uuid: UUID = UUID()
    var creationDate: Date = Date()
    var modificationDate: Date = Date()
    var sequence: Int = 0
    var amount: Double = 1.0
    var unit: MeasurementUnit = .ounce
    var ingredient: Ingredient?
    var recipe: Recipe? = TestRecipe()
    var inverseRecipe: Recipe?
    
    init() {
    }
    
    init(inverseRecipe: Recipe, recipe: Recipe?) {
        self.inverseRecipe = inverseRecipe
        self.recipe = recipe ?? TestRecipe()
    }
}
