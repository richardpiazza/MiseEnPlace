import XCTest
@testable import MiseEnPlace

class DescriptiveTests: XCTestCase {

    fileprivate class TestClass: Descriptive {
        var name: String?
        var commentary: String?
        var classification: String?
    }

    func testNameIndexCharacter() {
        let testable = TestClass()
        XCTAssertEqual(testable.nameIndexCharacter, "")
        
        testable.name = "Whole Milk"
        XCTAssertEqual(testable.nameIndexCharacter, "W")
        
        testable.name = "cornflour"
        XCTAssertEqual(testable.nameIndexCharacter, "C")
    }
}
