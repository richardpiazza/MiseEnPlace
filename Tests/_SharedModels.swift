import XCTest
@testable import MiseEnPlace

internal class TestIngredient: Ingredient {
    var uuid: String = UUID().uuidString
    var creationDate: Date = Date()
    var modificationDate: Date = Date()
    var name: String?
    var commentary: String?
    var classification: String?
    var imagePath: String?
    var volume: Double = 1.0
    var weight: Double = 1.0
    var amount: Double = 0.0
    var unit: MeasurementUnit = .asNeeded
    
    init() {
    }
}

internal class TestRecipe: Recipe {
    var uuid: String = UUID().uuidString
    var creationDate: Date = Date()
    var modificationDate: Date = Date()
    var name: String?
    var commentary: String?
    var classification: String?
    var imagePath: String?
    var amount: Double = 0.0
    var unit: MeasurementUnit = .asNeeded
    var formulaElements: [FormulaElement] = [FormulaElement]()
    var procedureElements: [ProcedureElement] = [ProcedureElement]()
    
    init() {
    }
}

internal class TestFormulaElement: FormulaElement {
    var uuid: String = UUID().uuidString
    var creationDate: Date = Date()
    var modificationDate: Date = Date()
    var sequence: Int = 0
    var amount: Double = 0.0
    var unit: MeasurementUnit = .asNeeded
    var inverseRecipe: Recipe?
    var ingredient: Ingredient?
    var recipe: Recipe?
    
    init() {
    }
}

internal class MeasuredIngredient: FormulaElement {
    var uuid: String = UUID().uuidString
    var creationDate: Date = Date()
    var modificationDate: Date = Date()
    var sequence: Int = 0
    var amount: Double = 0.0
    var unit: MeasurementUnit = .asNeeded
    var inverseRecipe: Recipe?
    var ingredient: Ingredient?
    var recipe: Recipe?
    
    init() {
    }
    
    init(ingredient: Ingredient, amount: Double, unit: MeasurementUnit) {
        self.ingredient = ingredient
        self.amount = amount
        self.unit = unit
    }
}

internal class MeasuredRecipe: FormulaElement {
    var uuid: String = UUID().uuidString
    var creationDate: Date = Date()
    var modificationDate: Date = Date()
    var sequence: Int = 0
    var amount: Double = 0.0
    var unit: MeasurementUnit = .asNeeded
    var inverseRecipe: Recipe?
    var ingredient: Ingredient?
    var recipe: Recipe?
    
    init() {
    }
    
    init(recipe: Recipe, amount: Double, unit: MeasurementUnit) {
        self.recipe = recipe
        self.amount = amount
        self.unit = unit
    }
}

internal struct _SharedModels {
    internal static var water: Ingredient = {
        let ingredient = TestIngredient()
        ingredient.name = "Water"
        return ingredient
    }()
    
    internal static var flour: Ingredient = {
        let ingredient = TestIngredient()
        ingredient.name = "Bread Flour"
        ingredient.volume = 1.88
        ingredient.weight = 1.0
        return ingredient
    }()
    
    internal static var salt: Ingredient = {
        let ingredient = TestIngredient()
        ingredient.name = "Salt"
        ingredient.volume = 1.0
        ingredient.weight = 1.2
        return ingredient
    }()
    
    internal static var yeast: Ingredient = {
        let ingredient = TestIngredient()
        ingredient.name = "Active Dry Yeast"
        ingredient.volume = 1.25
        ingredient.weight = 1.0
        ingredient.amount = 7.0
        ingredient.unit = .gram
        return ingredient
    }()
    
    internal static var poolish: Recipe = {
        var recipe = TestRecipe()
        recipe.name = "Poolish"
        
        recipe.amount = 709.0
        recipe.unit = .gram
        
        let measuredWater = MeasuredIngredient(ingredient: water, amount: 340.0, unit: .milliliter)
        recipe.insertFormulaElement(measuredWater)
        
        let measuredFlour = MeasuredIngredient(ingredient: flour, amount: 360.0, unit: .gram)
        recipe.insertFormulaElement(measuredFlour)
        
        let measuredYeast = MeasuredIngredient(ingredient: yeast, amount: 9.0, unit: .gram)
        recipe.insertFormulaElement(measuredYeast)
        
        return recipe
    }()
    
    internal static var baguette: Recipe = {
        var recipe = TestRecipe()
        recipe.name = "Poolish Baguette"
        
        recipe.amount = 16.0
        recipe.unit = .ounce
        
        let measuredPoolish = MeasuredRecipe(recipe: poolish, amount: 7.0, unit: .ounce)
        recipe.insertFormulaElement(measuredPoolish)
        
        let measuredFlour = MeasuredIngredient(ingredient: flour, amount: 17.0, unit: .ounce)
        recipe.insertFormulaElement(measuredFlour)
        
        let measuredYeast = MeasuredIngredient(ingredient: yeast, amount: 0.8, unit: .ounce)
        recipe.insertFormulaElement(measuredYeast)
        
        let measuredWater = MeasuredIngredient(ingredient: water, amount: 10.0, unit: .fluidOunce)
        recipe.insertFormulaElement(measuredWater)
        
        let measuredSalt = MeasuredIngredient(ingredient: salt, amount: 0.333, unit: .ounce)
        recipe.insertFormulaElement(measuredSalt)
        
        return recipe
    }()
}
