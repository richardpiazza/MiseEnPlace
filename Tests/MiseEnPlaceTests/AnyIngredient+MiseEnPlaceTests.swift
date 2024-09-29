import Foundation
@testable import MiseEnPlace

extension AnyIngredient {
    static let water: Ingredient = AnyIngredient(
        uuid: UUID(uuidString: "218ab2d0-16d1-4804-adf8-5918d800c25c")!,
        name: "Water",
        volume: 1.0,
        weight: 1.0
    )
    
    static let flour: Ingredient = AnyIngredient(
        uuid: UUID(uuidString: "d7602b04-3984-4cb5-8c26-7512aadd90c5")!,
        name: "Flour",
        volume: 1.882,
        weight: 1.0
    )
    
    static let salt: Ingredient = AnyIngredient(
        uuid: UUID(uuidString: "b803c759-9590-4dbf-9cd7-38cbac8ab0ae")!,
        name: "Salt",
        volume: 1.0,
        weight: 1.2
    )
    
    static let yeast: Ingredient = AnyIngredient(
        uuid: UUID(uuidString: "9814b4c8-e4dc-4197-a9b9-4ec3af437145")!,
        name: "Yeast",
        volume: 1.25,
        weight: 1.0
    )
}
