import Foundation

public struct AnyProcedureElement: ProcedureElement {
    public var uuid: UUID
    public var creationDate: Date
    public var modificationDate: Date
    public var name: String
    public var commentary: String
    public var classification: String
    public var sequence: Int
    public var imageData: Data?
    public var imagePath: String?
    public var inverseRecipe: Recipe?
    
    public init(
        uuid: UUID = UUID(),
        creationDate: Date = Date(),
        modificationDate: Date = Date(),
        name: String = "",
        commentary: String = "",
        classification: String = "",
        sequence: Int = 0,
        imageData: Data? = nil,
        imagePath: String? = nil,
        inverseRecipe: Recipe? = nil
    ) {
        self.uuid = uuid
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.name = name
        self.commentary = commentary
        self.classification = classification
        self.sequence = sequence
        self.imageData = imageData
        self.imagePath = imagePath
        self.inverseRecipe = inverseRecipe
    }
    
    public init(
        _ procedureElement: ProcedureElement,
        mapInverse: Bool = false
    ) {
        self.uuid = procedureElement.uuid
        self.creationDate = procedureElement.creationDate
        self.modificationDate = procedureElement.modificationDate
        self.name = procedureElement.name
        self.commentary = procedureElement.commentary
        self.classification = procedureElement.classification
        self.sequence = procedureElement.sequence
        self.imageData = procedureElement.imageData
        self.imagePath = procedureElement.imagePath
        if mapInverse {
            self.inverseRecipe = procedureElement.inverseRecipe.map { AnyRecipe($0) }
        }
    }
}
