import XCTest
@testable import MiseEnPlace

class MeasurementTests: XCTestCase {

    func testAmountForUnit() {
        var measurement = MiseEnPlace.Measurement(amount: 0.0, unit: .asNeeded)
        do {
            let _ = try measurement.amount(for: .kilogram)
            XCTFail("Error.measurementAmount() should be thrown.")
            return
        } catch MiseEnPlace.Error.measurementAmount(let method) {
            XCTAssertNil(method)
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measurement.amount = 100.0
        do {
            let _ = try measurement.amount(for: .kilogram)
            XCTFail("Error.measurementUnit() should be thrown.")
            return
        } catch MiseEnPlace.Error.measurementUnit(let method) {
            XCTAssertNil(method)
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measurement.unit = .gram
        do {
            let _ = try measurement.amount(for: .asNeeded)
            XCTFail("Error.measurementUnit() should be thrown.")
            return
        } catch MiseEnPlace.Error.measurementUnit(let method) {
            XCTAssertNil(method)
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        do {
            let _ = try measurement.amount(for: .pound)
            XCTFail("Error.measurementUnit() should be thrown.")
            return
        } catch MiseEnPlace.Error.measurementUnit(let method) {
            XCTAssertNil(method)
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        do {
            let amount = try measurement.amount(for: .kilogram)
            XCTAssertEqual(amount, 0.1)
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measurement.amount = 30000.0
        measurement.unit = .pinch
        
        do {
            let amount = try measurement.amount(for: .gallon)
            XCTAssertTrue(amount.equals(2.4414, precision: 3))
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measurement.amount = 6.5
        measurement.unit = .gallon
        
        do {
            let amount = try measurement.amount(for: .pinch)
            XCTAssertTrue(amount.equals(79872.0, precision: 1))
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
    }

}
