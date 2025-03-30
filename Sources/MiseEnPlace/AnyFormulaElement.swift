import Foundation

/// A generic `FormulaElement`.
public struct AnyFormulaElement: FormulaElement {
    public var uuid: UUID
    public var creationDate: Date
    public var modificationDate: Date
    public var sequence: Int
    public var amount: Double
    public var unit: MeasurementUnit
    public var measured: Measured
    public var inverseRecipe: Recipe?

    public init(
        uuid: UUID = UUID(),
        creationDate: Date = Date(),
        modificationDate: Date = Date(),
        sequence: Int = 0,
        amount: Double = 1.0,
        unit: MeasurementUnit = .noUnit,
        measured: Measured,
        inverseRecipe: Recipe? = nil
    ) {
        self.uuid = uuid
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.sequence = sequence
        self.amount = amount
        self.unit = unit
        self.measured = measured
        self.inverseRecipe = inverseRecipe
    }

    public init(
        _ formulaElement: FormulaElement,
        mapInverse: Bool = false
    ) {
        uuid = formulaElement.uuid
        creationDate = formulaElement.creationDate
        modificationDate = formulaElement.modificationDate
        sequence = formulaElement.sequence
        amount = formulaElement.amount
        unit = formulaElement.unit
        measured = formulaElement.measured
        if mapInverse {
            inverseRecipe = formulaElement.inverseRecipe.map { AnyRecipe($0) }
        }
    }
}

extension AnyFormulaElement: Identifiable {
    public var id: UUID { uuid }
}
