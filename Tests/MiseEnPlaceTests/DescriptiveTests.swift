import Foundation
import XCTest
@testable import MiseEnPlace

class DescriptiveTests: XCTestCase {
    
    struct Entity: Descriptive {
        var name: String = ""
        var commentary: String = ""
        var classification: String = ""
    }
    
    private var entity: Entity = Entity()
    
    func testProperties() {
        XCTAssertEqual(entity.name, "")
        XCTAssertEqual(entity.commentary, "")
        XCTAssertEqual(entity.classification, "")
        
        entity.name = "bob"
        entity.commentary = "a guy"
        entity.classification = "humanoid, terran, bob"
        
        XCTAssertEqual(entity.name, "bob")
        XCTAssertEqual(entity.commentary, "a guy")
        XCTAssertEqual(entity.classification, "humanoid, terran, bob")
    }
}
