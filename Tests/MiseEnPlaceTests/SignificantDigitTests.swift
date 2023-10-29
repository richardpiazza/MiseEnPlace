import Foundation
import XCTest
@testable import MiseEnPlace

class SignificantDigitTests: XCTestCase {
    
    func testCup() {
        let measurement = Quantification(amount: 0.0951019406578092, unit: .cup)
        XCTAssertEqual(measurement.description, "0.095 Cup")
    }
    
    func testPint() {
        let measurement = Quantification(amount: 0.0475509703289046, unit: .pint)
        XCTAssertEqual(measurement.description, "0.048 Pint")
    }
    
    func testQuart() {
        let measurement = Quantification(amount: 0.0237754851644523, unit: .quart)
        XCTAssertEqual(measurement.description, "0.024 Quart")
    }
    
    func testGallon() {
        let measurement = Quantification(amount: 0.00594387129111308, unit: .gallon)
        XCTAssertEqual(measurement.description, "0.0059 Gallon")
    }
    
    func testPound() {
        let measurement = Quantification(amount: 0.022046226315695, unit: .pound)
        XCTAssertEqual(measurement.description, "0.022 Pound")
    }
}
