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

    func testMeasurementMatching() {
        var measurement = MiseEnPlace.Measurement(amount: 0.0, unit: .asNeeded)
        do {
            let _ = try measurement.normalizedMeasurement()
            XCTFail("Error.measurementAmount() should be thrown.")
            return
        } catch MiseEnPlace.Error.measurementAmount(let method) {
            XCTAssertNil(method)
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measurement.amount = 16.0
        do {
            let _ = try measurement.normalizedMeasurement()
            XCTFail("Error.measurementUnit() should be thrown.")
            return
        } catch MiseEnPlace.Error.measurementUnit(let method) {
            XCTAssertNil(method)
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measurement.unit = .cup
        do {
            let normalized = try measurement.normalizedMeasurement()
            XCTAssertEqual(normalized.amount, 1.0)
            XCTAssertEqual(normalized.unit, .gallon)
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measurement.amount = 1 / 16
        measurement.unit = .gallon
        do {
            let normalized = try measurement.normalizedMeasurement()
            XCTAssertEqual(normalized.amount, 1.0)
            XCTAssertEqual(normalized.unit, .cup)
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
    }
    
    func testComponents() {
    }
    
    func testTranslation() {
        // Configuration.abbreviateTranslations
    }
    
    func testComponentsTranslation() {
        XCTAssertFalse(Configuration.abbreviateTranslations)
        
        var measurement: MiseEnPlace.Measurement
        
        measurement = MiseEnPlace.Measurement(amount: 7.542, unit: .gram)
        XCTAssertEqual(measurement.componentsTranslation, "7.5 Gram")
        
        measurement.amount = 68.843
        XCTAssertEqual(measurement.componentsTranslation, "69 Gram")
        
        measurement.amount = 212.43
        XCTAssertEqual(measurement.componentsTranslation, "210 Gram")
        
        measurement.amount = 1.24
        measurement.unit = .kilogram
        XCTAssertEqual(measurement.componentsTranslation, "1 Kilogram 240 Gram")
        
        measurement.amount = 60.685
        XCTAssertEqual(measurement.componentsTranslation, "60 Kilogram 685 Gram")
        
        measurement.amount = 252
        XCTAssertEqual(measurement.componentsTranslation, "252 Kilogram")
        
        measurement.amount = 1.25
        measurement.unit = .milliliter
        XCTAssertEqual(measurement.componentsTranslation, "1.2 Milliliter")
        
        measurement.amount = 76.666
        XCTAssertEqual(measurement.componentsTranslation, "77 Milliliter")
        
        measurement.amount = 901.01
        XCTAssertEqual(measurement.componentsTranslation, "900 Milliliter")
        
        measurement.amount = 3.75
        measurement.unit = .liter
        XCTAssertEqual(measurement.componentsTranslation, "3 Liter 750 Milliliter")
        
        measurement.amount = 99.999
        XCTAssertEqual(measurement.componentsTranslation, "99 Liter 1000 Milliliter")
        
        measurement.amount = 624.83
        XCTAssertEqual(measurement.componentsTranslation, "624 Liter 830 Milliliter")
        
        measurement.amount = 2.675
        measurement.unit = .ounce
        XCTAssertEqual(measurement.componentsTranslation, "2\(Fraction.twoThirds.stringValue) Ounce")
        
        measurement.amount = 6.90
        XCTAssertEqual(measurement.componentsTranslation, "7 Ounce")
        
        measurement.amount = 8.5
        XCTAssertEqual(measurement.componentsTranslation, "8\(Fraction.oneHalf.stringValue) Ounce")
        
        measurement.amount = 1.32
        measurement.unit = .pound
        XCTAssertEqual(measurement.componentsTranslation, "1 Pound 5 Ounce")
        
        measurement.amount = 2.55
        XCTAssertEqual(measurement.componentsTranslation, "2 Pound 8\(Fraction.threeFourths.stringValue) Ounce")
        
        measurement.amount = 250
        XCTAssertEqual(measurement.componentsTranslation, "250 Pound")
        
        measurement.amount = 1.5
        measurement.unit = .pinch
        XCTAssertEqual(measurement.componentsTranslation, "1\(Fraction.oneHalf.stringValue) Pinch")
        
        measurement.amount = 0.75
        measurement.unit = .dash
        XCTAssertEqual(measurement.componentsTranslation, "\(Fraction.threeFourths.stringValue) Dash")
        
        measurement.amount = 2.66
        measurement.unit = .teaspoon
        XCTAssertEqual(measurement.componentsTranslation, "2 \(Fraction.twoThirds.stringValue) Teaspoon")
        
        measurement.amount = 3.5
        measurement.unit = .tablespoon
        XCTAssertEqual(measurement.componentsTranslation, "3 Tablespoon 1\(Fraction.oneHalf.stringValue) Teaspoon")
        
        measurement.amount = 8.111
        measurement.unit = .fluidOunce
        XCTAssertEqual(measurement.componentsTranslation, "8 Fluid Ounce \(Fraction.oneFourth.stringValue) Tablespoon")
        
        measurement.amount = 4.625
        measurement.unit = .cup
        XCTAssertEqual(measurement.componentsTranslation, "4 \(Fraction.fiveEighths.stringValue) Cup")
        
        measurement.amount = 2.778
        measurement.unit = .pint
        XCTAssertEqual(measurement.componentsTranslation, "2 Pint 1\(Fraction.oneHalf.stringValue) Cup")
        
        measurement.amount = 3.333
        measurement.unit = .quart
        XCTAssertEqual(measurement.componentsTranslation, "3 Quart \(Fraction.twoThirds.stringValue) Pint")
        
        measurement.amount = 1.789
        measurement.unit = .gallon
        XCTAssertEqual(measurement.componentsTranslation, "1 Gallon 3\(Fraction.oneEighth.stringValue) Quart")
        
        measurement.amount = 2.5
        measurement.unit = .cup
        XCTAssertEqual(measurement.componentsTranslation, "2 \(Fraction.oneHalf.stringValue) Cup")
    }
    
    func testMetricTranslation() {
    }
    
    func testFractionTranslation() {
    }
}
