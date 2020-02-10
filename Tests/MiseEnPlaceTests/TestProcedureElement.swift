import Foundation
@testable import MiseEnPlace

struct TestProcedureElement: ProcedureElement {
    var uuid: UUID = UUID()
    var creationDate: Date = Date()
    var modificationDate: Date = Date()
    var sequence: Int = 0
    var name: String?
    var commentary: String?
    var classification: String?
    var imagePath: String?
    var inverseRecipe: Recipe?
    
    init() {
    }
    
    init(commentary: String) {
        self.commentary = commentary
    }
}
