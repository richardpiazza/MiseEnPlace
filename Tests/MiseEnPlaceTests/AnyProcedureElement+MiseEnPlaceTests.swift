import Foundation
@testable import MiseEnPlace

extension AnyProcedureElement {
    static let poolishBaguetteStep1: ProcedureElement = AnyProcedureElement(
        uuid: UUID(uuidString: "B4961957-FC71-4CA1-BFE2-62FF966F23D2")!,
        commentary: "Bring all ingredients together in a mixer.",
        sequence: 0
    )
    
    static let poolishBaguetteStep2: ProcedureElement = AnyProcedureElement(
        uuid: UUID(uuidString: "284DDDC9-8746-4977-B120-D4B4B5FA4C7E")!,
        commentary: "Ferment until doubled, approximately 1-2 hours.",
        sequence: 1
    )
    
    static let poolishBaguetteStep3: ProcedureElement = AnyProcedureElement(
        uuid: UUID(uuidString: "FCC6047A-B515-4BA3-BD0E-E9552059A187")!,
        commentary: "Bake at 450℉ apx 20-22 minutes.",
        sequence: 2
    )
}
