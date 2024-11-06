import Foundation

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
        self.uuid = formulaElement.uuid
        self.creationDate = formulaElement.creationDate
        self.modificationDate = formulaElement.modificationDate
        self.sequence = formulaElement.sequence
        self.amount = formulaElement.amount
        self.unit = formulaElement.unit
        self.measured = formulaElement.measured
        if mapInverse {
            self.inverseRecipe = formulaElement.inverseRecipe.map { AnyRecipe($0) }
        }
    }
}
