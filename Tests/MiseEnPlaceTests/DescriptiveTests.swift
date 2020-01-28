import Foundation
import XCTest
@testable import MiseEnPlace

class DescriptiveTests: XCTestCase {
    
    static var allTests = [
        ("testProperties", testProperties),
        ("testCharacterIndex", testCharacterIndex),
    ]
    
    private var entity: Entity = Entity()
    
    func testProperties() {
        entity.name = nil
        entity.commentary = nil
        entity.classification = nil
        
        XCTAssertNil(entity.name)
        XCTAssertNil(entity.commentary)
        XCTAssertNil(entity.classification)
        
        entity.name = "bob"
        entity.commentary = "a guy"
        entity.classification = "humanoid, terran, bob"
        
        XCTAssertEqual(entity.name, "bob")
        XCTAssertEqual(entity.commentary, "a guy")
        XCTAssertEqual(entity.classification, "humanoid, terran, bob")
    }
    
    func testCharacterIndex() {
        entity.name = nil
        
        XCTAssertEqual(entity.indexCharacter, "")
        
        entity.name = "bob"
        
        XCTAssertEqual(entity.indexCharacter, "B")
    }
}

fileprivate struct Entity: Descriptive {
    var name: String?
    var commentary: String?
    var classification: String?
}
