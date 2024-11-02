import Foundation
@testable import MiseEnPlace

extension AnyRecipe {
    static let italianBread: Recipe = AnyRecipe(
        uuid: UUID(uuidString: "05e27e08-337c-402c-9456-b2bcba028517")!,
        name: "Italian Bread",
        amount: 702.5,
        unit: .gram,
        formulaElements: [
            AnyFormulaElement.italianBreadFlour,
            AnyFormulaElement.italianBreadSalt,
            AnyFormulaElement.italianBreadYeast,
            AnyFormulaElement.italianBreadWater
        ]
    )
    
    static let poolish: Recipe = AnyRecipe(
        uuid: UUID(uuidString: "8a3a1075-767e-4f58-95ec-acccfc2489dd")!,
        name: "Poolish",
        amount: 709,
        unit: .gram,
        formulaElements: [
            AnyFormulaElement.poolishWater,
            AnyFormulaElement.poolishYeast,
            AnyFormulaElement.poolishFlour
        ]
    )
    
    static let poolishBaguette: Recipe = AnyRecipe(
        uuid: UUID(uuidString: "3cba80c5-d695-4f8b-be53-646c9c053d8b")!,
        name: "Poolish Baguette",
        amount: 17.5,
        unit: .ounce,
        formulaElements: [
            AnyFormulaElement.poolishBaguettePoolish,
            AnyFormulaElement.poolishBaguetteFlour,
            AnyFormulaElement.poolishBaguetteYeast,
            AnyFormulaElement.poolishBaguetteWater,
            AnyFormulaElement.poolishBaguetteSalt
        ],
        procedureElements: [
            AnyProcedureElement.poolishBaguetteStep1,
            AnyProcedureElement.poolishBaguetteStep2,
            AnyProcedureElement.poolishBaguetteStep3,
            AnyProcedureElement.poolishBaguetteStep4
        ]
    )
}
