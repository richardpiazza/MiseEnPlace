import Foundation
@testable import MiseEnPlace

extension AnyFormulaElement {
    static let italianBreadFlour: FormulaElement = AnyFormulaElement(
        uuid: UUID(uuidString: "EB795BD1-F9E4-4B02-8680-F73B0E49B269")!,
        sequence: 0,
        amount: 1.8,
        unit: .kilogram,
        measured: .ingredient(AnyIngredient.flour)
    )
    
    static let italianBreadSalt: FormulaElement = AnyFormulaElement(
        uuid: UUID(uuidString: "2B401CB0-54A9-47CE-8D41-E87BB645AFA6")!,
        sequence: 1,
        amount: 28,
        unit: .gram,
        measured: .ingredient(AnyIngredient.salt)
    )
    
    static let italianBreadYeast: FormulaElement = AnyFormulaElement(
        uuid: UUID(uuidString: "28B1FBED-6287-43CB-B96C-10B5CC79497F")!,
        sequence: 2,
        amount: 28,
        unit: .gram,
        measured: .ingredient(AnyIngredient.yeast)
    )
    
    static let italianBreadWater: FormulaElement = AnyFormulaElement(
        uuid: UUID(uuidString: "D035A495-F97F-42A1-AD44-45B2A68615AC")!,
        sequence: 3,
        amount: 955,
        unit: .milliliter,
        measured: .ingredient(AnyIngredient.water)
    )
    
    static let poolishWater: FormulaElement = AnyFormulaElement(
        uuid: UUID(uuidString: "FD62F043-6EBB-4CCE-BB7E-E4E508576856")!,
        sequence: 0,
        amount: 340,
        unit: .milliliter,
        measured: .ingredient(AnyIngredient.water)
    )
    
    static let poolishYeast: FormulaElement = AnyFormulaElement(
        uuid: UUID(uuidString: "F8F0BF52-D282-4A1F-9905-3F54313AC6F3")!,
        sequence: 1,
        amount: 9,
        unit: .gram,
        measured: .ingredient(AnyIngredient.yeast)
    )
    
    static let poolishFlour: FormulaElement = AnyFormulaElement(
        uuid: UUID(uuidString: "6F0B4E3B-CEBF-447A-9DDB-5A4BCF02F215")!,
        sequence: 2,
        amount: 360,
        unit: .gram,
        measured: .ingredient(AnyIngredient.flour)
    )
    
    static let poolishBaguettePoolish: FormulaElement = AnyFormulaElement(
        uuid: UUID(uuidString: "65C23D6D-36AF-4FCD-BC6E-FC0BEC4DC996")!,
        sequence: 0,
        amount: 7,
        unit: .ounce,
        measured: .recipe(AnyRecipe.poolish)
    )
    
    static let poolishBaguetteFlour: FormulaElement = AnyFormulaElement(
        uuid: UUID(uuidString: "63887029-5AD3-48A7-85E8-C9BDFEB48E60")!,
        sequence: 1,
        amount: 17,
        unit: .ounce,
        measured: .ingredient(AnyIngredient.flour)
    )
    
    static let poolishBaguetteYeast: FormulaElement = AnyFormulaElement(
        uuid: UUID(uuidString: "99EB5B1D-ECF0-420F-A626-F6D7224D5F5F")!,
        sequence: 2,
        amount: 0.8,
        unit: .ounce,
        measured: .ingredient(AnyIngredient.yeast)
    )
    
    static let poolishBaguetteWater: FormulaElement = AnyFormulaElement(
        uuid: UUID(uuidString: "0EB4AE28-7AF9-4120-9ED2-383C76D9099F")!,
        sequence: 3,
        amount: 10,
        unit: .ounce,
        measured: .ingredient(AnyIngredient.water)
    )
    
    static let poolishBaguetteSalt: FormulaElement = AnyFormulaElement(
        uuid: UUID(uuidString: "5E7D1525-9BBB-4473-B1BC-03904175A3C7")!,
        sequence: 4,
        amount: 0.35,
        unit: .ounce,
        measured: .ingredient(AnyIngredient.salt)
    )
}
