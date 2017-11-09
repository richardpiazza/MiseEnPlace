import XCTest
@testable import MiseEnPlace

class DoubleTests: XCTestCase {

    func testEquals() {
        let double = 9.87654321
        XCTAssertTrue(double.equals(9.87654321, precision: 0))
        XCTAssertTrue(double.equals(9.8765432, precision: 0))
        XCTAssertTrue(double.equals(9.8765432, precision: 1))
        XCTAssertTrue(double.equals(9.8765432, precision: 2))
        XCTAssertTrue(double.equals(9.8765432, precision: 3))
        XCTAssertTrue(double.equals(9.8765432, precision: 4))
        XCTAssertTrue(double.equals(9.8765432, precision: 5))
        XCTAssertTrue(double.equals(9.8765432, precision: 6))
        XCTAssertFalse(double.equals(9.8765432, precision: 7))
        XCTAssertFalse(double.equals(9.8765432, precision: -1))
    }
    
    func testFractionedString() {
        var double = Double.nan
        XCTAssertEqual(double.fractionedString, "0")
        
        double = 5.0
        XCTAssertEqual(double.fractionedString, "5")
        
        double = 12.00001
        XCTAssertEqual(double.fractionedString, "12")
        
        double = 12.99999
        XCTAssertEqual(double.fractionedString, "13")
        
        double = 0.50
        XCTAssertEqual(double.fractionedString, Fraction.oneHalf.stringValue)
        
        double = 2.333
        XCTAssertEqual(double.fractionedString, "2\(Fraction.oneThird.stringValue)")
    }

}
