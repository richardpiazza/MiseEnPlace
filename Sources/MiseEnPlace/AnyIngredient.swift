import Foundation

public struct AnyIngredient: Ingredient {
    public var uuid: UUID
    public var creationDate: Date
    public var modificationDate: Date
    public var name: String?
    public var commentary: String?
    public var classification: String?
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
        name: String? = nil,
        commentary: String? = nil,
        classification: String? = nil,
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
        self.uuid = ingredient.uuid
        self.creationDate = ingredient.creationDate
        self.modificationDate = ingredient.modificationDate
        self.name = ingredient.name
        self.commentary = ingredient.commentary
        self.classification = ingredient.classification
        self.imageData = ingredient.imageData
        self.imagePath = ingredient.imagePath
        self.volume = ingredient.volume
        self.weight = ingredient.weight
        self.amount = ingredient.amount
        self.unit = ingredient.unit
    }
}
