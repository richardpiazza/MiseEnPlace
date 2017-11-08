import XCTest
@testable import MiseEnPlace

class SignificantDigitTests: XCTestCase {
    
    func testCup() {
        let measurement = MiseEnPlace.Measurement(amount: 0.0951019406578092, unit: .cup)
        XCTAssertEqual(measurement.translation, "0.095 Cup")
    }
    
    func testPint() {
        let measurement = MiseEnPlace.Measurement(amount: 0.0475509703289046, unit: .pint)
        XCTAssertEqual(measurement.translation, "0.048 Pint")
    }
    
    func testQuart() {
        let measurement = MiseEnPlace.Measurement(amount: 0.0237754851644523, unit: .quart)
        XCTAssertEqual(measurement.translation, "0.024 Quart")
    }
    
    func testGallon() {
        let measurement = MiseEnPlace.Measurement(amount: 0.00594387129111308, unit: .gallon)
        XCTAssertEqual(measurement.translation, "0.0059 Gallon")
    }
    
    func testPound() {
        let measurement = MiseEnPlace.Measurement(amount: 0.022046226315695, unit: .pound)
        XCTAssertEqual(measurement.translation, "0.022 Pound")
    }
}
