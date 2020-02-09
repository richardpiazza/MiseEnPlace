import Foundation
@testable import MiseEnPlace

struct TestIngredient: Ingredient {
    var uuid: UUID = UUID()
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
    
    init() {
    }
}

extension TestIngredient {
    static var water: Ingredient {
        var ingredient = TestIngredient()
        ingredient.uuid = UUID(uuidString: "218ab2d0-16d1-4804-adf8-5918d800c25c")!
        ingredient.name = "Water"
        ingredient.volume = 1.0
        ingredient.weight = 1.0
        return ingredient
    }
    
    static var flour: Ingredient {
        var ingredient = TestIngredient()
        ingredient.uuid = UUID(uuidString: "d7602b04-3984-4cb5-8c26-7512aadd90c5")!
        ingredient.name = "Flour"
        ingredient.volume = 1.882
        ingredient.weight = 1.0
        return ingredient
    }
    
    static var salt: Ingredient {
        var ingredient = TestIngredient()
        ingredient.uuid = UUID(uuidString: "b803c759-9590-4dbf-9cd7-38cbac8ab0ae")!
        ingredient.name = "Salt"
        ingredient.volume = 1.0
        ingredient.weight = 1.2
        return ingredient
    }
    
    static var yeast: Ingredient {
        var ingredient = TestIngredient()
        ingredient.uuid = UUID(uuidString: "9814b4c8-e4dc-4197-a9b9-4ec3af437145")!
        ingredient.name = "Yeast"
        ingredient.volume = 1.25
        ingredient.weight = 1.0
        return ingredient
    }
}
