import XCTest
@testable import MiseEnPlace

class ErrorTests: XCTestCase {
    
    func testErrorDescriptions() {
        XCTAssertEqual(MiseEnPlace.Error.asNeededConversion.errorDescription, "Conversion to/from MeasurementUnit .asNeeded is not supported.")
        XCTAssertEqual(MiseEnPlace.Error.quantifiableConversion.errorDescription, "The specified ingredient has an invalid 'each' measurement.")
        XCTAssertEqual(MiseEnPlace.Error.unhandledConversion.errorDescription, "Conversion is not supported at this time.")
        XCTAssertEqual(MiseEnPlace.Error.measurementAmount(method: nil).errorDescription, "Measurement amount must be a positive non-zero amount.")
        XCTAssertEqual(MiseEnPlace.Error.measurementAmount(method: .volume).errorDescription, "Volume measurement requires a positive non-zero amount.")
        XCTAssertEqual(MiseEnPlace.Error.measurementAmount(method: .weight).errorDescription, "Weight measurement requires a positive non-zero amount.")
        XCTAssertEqual(MiseEnPlace.Error.measurementUnit(method: nil).errorDescription, "Measurement unit must be specified.")
        XCTAssertEqual(MiseEnPlace.Error.measurementUnit(method: .volume).errorDescription, "Volume measurement requires a unit `MeasurementMethod` of type .volume.")
        XCTAssertEqual(MiseEnPlace.Error.measurementUnit(method: .weight).errorDescription, "Weight measurement requires a unit `MeasurementMethod` of type .weight.")
    }
    
}
