import Foundation
@testable import MiseEnPlace

struct TestRecipe: Recipe {
    var uuid: UUID = UUID()
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
    
    init() {
    }
}

extension TestRecipe {
    static var italianBread: Recipe {
        var recipe = TestRecipe()
        recipe.uuid = UUID(uuidString: "05e27e08-337c-402c-9456-b2bcba028517")!
        recipe.name = "Italian Bread"
        recipe.amount = 702.5
        recipe.unit = .gram
        
        var measuredFlour = TestMeasuredIngredient(inverseRecipe: recipe, ingredient: TestIngredient.flour)
        measuredFlour.amount = 1.8
        measuredFlour.unit = .kilogram
        recipe.insertFormulaElement(measuredFlour)
        
        var measuredSalt = TestMeasuredIngredient(inverseRecipe: recipe, ingredient: TestIngredient.salt)
        measuredSalt.amount = 28
        measuredSalt.unit = .gram
        recipe.insertFormulaElement(measuredSalt)
        
        var measuredYeast = TestMeasuredIngredient(inverseRecipe: recipe, ingredient: TestIngredient.yeast)
        measuredYeast.amount = 28
        measuredYeast.unit = .gram
        recipe.insertFormulaElement(measuredYeast)
        
        var measuredWater = TestMeasuredIngredient(inverseRecipe: recipe, ingredient: TestIngredient.water)
        measuredWater.amount = 955
        measuredWater.unit = .milliliter
        recipe.insertFormulaElement(measuredWater)
        
        return recipe
    }
    
    static var poolish: Recipe {
        var recipe = TestRecipe()
        recipe.uuid = UUID(uuidString: "8a3a1075-767e-4f58-95ec-acccfc2489dd")!
        recipe.name = "Poolish"
        recipe.amount = 709
        recipe.unit = .gram
        
        var measuredWater = TestMeasuredIngredient(inverseRecipe: recipe, ingredient: TestIngredient.water)
        measuredWater.amount = 340
        measuredWater.unit = .milliliter
        recipe.insertFormulaElement(measuredWater)
        
        var measuredYeast = TestMeasuredIngredient(inverseRecipe: recipe, ingredient: TestIngredient.yeast)
        measuredYeast.amount = 9
        measuredYeast.unit = .gram
        recipe.insertFormulaElement(measuredYeast)
        
        var measuredFlour = TestMeasuredIngredient(inverseRecipe: recipe, ingredient: TestIngredient.flour)
        measuredFlour.amount = 360
        measuredFlour.unit = .gram
        recipe.insertFormulaElement(measuredFlour)
        
        return recipe
    }
    
    static var poolishBaguette: Recipe {
        var recipe = TestRecipe()
        recipe.uuid = UUID(uuidString: "3cba80c5-d695-4f8b-be53-646c9c053d8b")!
        recipe.name = "Poolish Baguette"
        recipe.amount = 17.5
        recipe.unit = .ounce
        
        var measuredPoolish = TestMeasuredRecipe(inverseRecipe: recipe, recipe: TestRecipe.poolish)
        measuredPoolish.amount = 7
        measuredPoolish.unit = .ounce
        recipe.insertFormulaElement(measuredPoolish)
        
        var measuredFlour = TestMeasuredIngredient(inverseRecipe: recipe, ingredient: TestIngredient.flour)
        measuredFlour.amount = 17
        measuredFlour.unit = .ounce
        recipe.insertFormulaElement(measuredFlour)
        
        var measuredYeast = TestMeasuredIngredient(inverseRecipe: recipe, ingredient: TestIngredient.yeast)
        measuredYeast.amount = 0.8
        measuredYeast.unit = .ounce
        recipe.insertFormulaElement(measuredYeast)
        
        var measuredWater = TestMeasuredIngredient(inverseRecipe: recipe, ingredient: TestIngredient.water)
        measuredWater.amount = 10
        measuredWater.unit = .ounce
        recipe.insertFormulaElement(measuredWater)
        
        var measuredSalt = TestMeasuredIngredient(inverseRecipe: recipe, ingredient: TestIngredient.salt)
        measuredSalt.amount = 0.35
        measuredSalt.unit = .ounce
        recipe.insertFormulaElement(measuredSalt)
        
        return recipe
    }
}
