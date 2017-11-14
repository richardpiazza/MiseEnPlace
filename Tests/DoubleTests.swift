import XCTest
@testable import MiseEnPlace

class DoubleTests: XCTestCase {

    func testRounded() {
        let double = 9.87654321
        
        XCTAssertEqual(double.rounded(to: 0), 10.0)
        XCTAssertEqual(double.rounded(to: 1), 9.9)
        XCTAssertEqual(double.rounded(to: 2), 9.88)
        XCTAssertEqual(double.rounded(to: 3), 9.877)
        XCTAssertEqual(double.rounded(to: 4), 9.8765)
        XCTAssertEqual(double.rounded(to: 5), 9.87654)
        XCTAssertEqual(double.rounded(to: 6), 9.876543)
        XCTAssertEqual(double.rounded(to: 7), 9.8765432)
        XCTAssertEqual(double.rounded(to: 8), 9.87654321)
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
