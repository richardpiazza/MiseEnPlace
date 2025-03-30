import Foundation

/// A generic `Recipe`.
public struct AnyRecipe: Recipe {
    public var uuid: UUID
    public var creationDate: Date
    public var modificationDate: Date
    public var name: String
    public var commentary: String
    public var classification: String
    public var imageData: Data?
    public var imagePath: String?
    public var amount: Double
    public var unit: MeasurementUnit
    public var formulaElements: [FormulaElement]
    public var procedureElements: [ProcedureElement]

    public init(
        uuid: UUID = UUID(),
        creationDate: Date = Date(),
        modificationDate: Date = Date(),
        name: String = "",
        commentary: String = "",
        classification: String = "",
        imageData: Data? = nil,
        imagePath: String? = nil,
        amount: Double = 1.0,
        unit: MeasurementUnit = .noUnit,
        formulaElements: [FormulaElement] = [],
        procedureElements: [ProcedureElement] = []
    ) {
        self.uuid = uuid
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.name = name
        self.commentary = commentary
        self.classification = classification
        self.imageData = imageData
        self.imagePath = imagePath
        self.amount = amount
        self.unit = unit
        self.formulaElements = formulaElements
        self.procedureElements = procedureElements
    }

    public init(_ recipe: Recipe) {
        uuid = recipe.uuid
        creationDate = recipe.creationDate
        modificationDate = recipe.modificationDate
        name = recipe.name
        commentary = recipe.commentary
        classification = recipe.classification
        imageData = recipe.imageData
        imagePath = recipe.imagePath
        amount = recipe.amount
        unit = recipe.unit
        formulaElements = recipe.formulaElements.map { AnyFormulaElement($0) }
        procedureElements = recipe.procedureElements.map { AnyProcedureElement($0) }
    }
}

extension AnyRecipe: Identifiable {
    public var id: UUID { uuid }
}
