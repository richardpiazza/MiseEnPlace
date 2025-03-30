import Foundation

/// A generic `Ingredient`.
public struct AnyIngredient: Ingredient {
    public var uuid: UUID
    public var creationDate: Date
    public var modificationDate: Date
    public var name: String
    public var commentary: String
    public var classification: String
    public var imageData: Data?
    public var imagePath: String?
    public var volume: Double
    public var weight: Double
    public var amount: Double
    public var unit: MeasurementUnit

    public init(
        uuid: UUID = UUID(),
        creationDate: Date = Date(),
        modificationDate: Date = Date(),
        name: String = "",
        commentary: String = "",
        classification: String = "",
        imageData: Data? = nil,
        imagePath: String? = nil,
        volume: Double = 1.0,
        weight: Double = 1.0,
        amount: Double = 1.0,
        unit: MeasurementUnit = .ounce
    ) {
        self.uuid = uuid
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.name = name
        self.commentary = commentary
        self.classification = classification
        self.imageData = imageData
        self.imagePath = imagePath
        self.volume = volume
        self.weight = weight
        self.amount = amount
        self.unit = unit
    }

    public init(_ ingredient: Ingredient) {
        uuid = ingredient.uuid
        creationDate = ingredient.creationDate
        modificationDate = ingredient.modificationDate
        name = ingredient.name
        commentary = ingredient.commentary
        classification = ingredient.classification
        imageData = ingredient.imageData
        imagePath = ingredient.imagePath
        volume = ingredient.volume
        weight = ingredient.weight
        amount = ingredient.amount
        unit = ingredient.unit
    }
}

extension AnyIngredient: Identifiable {
    public var id: UUID { uuid }
}
