import Foundation
@testable import MiseEnPlace

extension AnyProcedureElement {
    static let poolishBaguetteStep1: ProcedureElement = AnyProcedureElement(
        uuid: UUID(uuidString: "B4961957-FC71-4CA1-BFE2-62FF966F23D2")!,
        name: "one",
        commentary: "Bring all ingredients together in a mixer.",
        sequence: 0
    )

    static let poolishBaguetteStep2: ProcedureElement = AnyProcedureElement(
        uuid: UUID(uuidString: "284DDDC9-8746-4977-B120-D4B4B5FA4C7E")!,
        name: "two",
        commentary: "Ferment until doubled, approximately 1-2 hours.",
        sequence: 1
    )

    static let poolishBaguetteStep3: ProcedureElement = AnyProcedureElement(
        uuid: UUID(uuidString: "FCC6047A-B515-4BA3-BD0E-E9552059A187")!,
        name: "three",
        commentary: "Bake at 450℉ apx 20-22 minutes.",
        sequence: 2
    )

    static let poolishBaguetteStep4: ProcedureElement = AnyProcedureElement(
        uuid: UUID(uuidString: "E93F340B-5CBA-4678-9B48-AB6DCC0D1CEA")!,
        name: "four",
        commentary: "Enjoy",
        sequence: 3
    )
}
