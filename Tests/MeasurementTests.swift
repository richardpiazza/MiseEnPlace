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

    func testNormalizedMeasurement() {
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
        var measurement: MiseEnPlace.Measurement
        var components: [MiseEnPlace.Measurement]
        
        measurement = MiseEnPlace.Measurement(amount: 0.0, unit: .asNeeded)
        components = measurement.components
        XCTAssertEqual(components.count, 1)
        XCTAssertTrue(components[0] == measurement)
        
        measurement.amount = 1.0
        measurement.unit = .each
        components = measurement.components
        XCTAssertEqual(components.count, 1)
        XCTAssertTrue(components[0] == measurement)
        
        measurement.amount = 0.5
        measurement.unit = .kilogram
        components = measurement.components
        XCTAssertEqual(components.count, 1)
        XCTAssertEqual(components[0].amount, 500.0)
        XCTAssertEqual(components[0].unit, .gram)
        
        
        measurement.amount = 1.5
        components = measurement.components
        XCTAssertEqual(components.count, 2)
        XCTAssertEqual(components[0].amount, 1.0)
        XCTAssertEqual(components[0].unit, .kilogram)
        XCTAssertEqual(components[1].amount, 500.0)
        XCTAssertEqual(components[1].unit, .gram)
        
        measurement.amount = 1100.0
        measurement.unit = .gram
        components = measurement.components
        XCTAssertEqual(components.count, 1)
        XCTAssertTrue(components[0] == measurement)
    }
    
    func testTranslation() {
        XCTAssertFalse(Configuration.abbreviateTranslations)
        
        var measurement: MiseEnPlace.Measurement
        
        // Significant Digits
        measurement = MiseEnPlace.Measurement(amount: 0.0951019406578092, unit: .cup)
        XCTAssertEqual(measurement.translation, "0.095 Cup")
        
        measurement = MiseEnPlace.Measurement(amount: 0.0475509703289046, unit: .pint)
        XCTAssertEqual(measurement.translation, "0.048 Pint")
        
        measurement = MiseEnPlace.Measurement(amount: 0.0237754851644523, unit: .quart)
        XCTAssertEqual(measurement.translation, "0.024 Quart")
        
        measurement = MiseEnPlace.Measurement(amount: 0.00594387129111308, unit: .gallon)
        XCTAssertEqual(measurement.translation, "0.0059 Gallon")
        
        measurement = MiseEnPlace.Measurement(amount: 0.022046226315695, unit: .pound)
        XCTAssertEqual(measurement.translation, "0.022 Pound")
        
        Configuration.abbreviateTranslations = true
        XCTAssertTrue(Configuration.abbreviateTranslations)
        
        measurement = MiseEnPlace.Measurement(amount: 0.0951019406578092, unit: .cup)
        XCTAssertEqual(measurement.translation, "0.095 c")
        
        measurement = MiseEnPlace.Measurement(amount: 0.0475509703289046, unit: .pint)
        XCTAssertEqual(measurement.translation, "0.048 pt")
        
        measurement = MiseEnPlace.Measurement(amount: 0.0237754851644523, unit: .quart)
        XCTAssertEqual(measurement.translation, "0.024 qt")
        
        measurement = MiseEnPlace.Measurement(amount: 0.00594387129111308, unit: .gallon)
        XCTAssertEqual(measurement.translation, "0.0059 gal")
        
        measurement = MiseEnPlace.Measurement(amount: 0.022046226315695, unit: .pound)
        XCTAssertEqual(measurement.translation, "0.022 lb")
        
        Configuration.abbreviateTranslations = false
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
        
        Configuration.abbreviateTranslations = true
        XCTAssertTrue(Configuration.abbreviateTranslations)
        
        measurement = MiseEnPlace.Measurement(amount: 7.542, unit: .gram)
        XCTAssertEqual(measurement.componentsTranslation, "7.5 g")
        
        measurement.amount = 68.843
        XCTAssertEqual(measurement.componentsTranslation, "69 g")
        
        measurement.amount = 212.43
        XCTAssertEqual(measurement.componentsTranslation, "210 g")
        
        measurement.amount = 1.24
        measurement.unit = .kilogram
        XCTAssertEqual(measurement.componentsTranslation, "1 kg 240 g")
        
        measurement.amount = 60.685
        XCTAssertEqual(measurement.componentsTranslation, "60 kg 685 g")
        
        measurement.amount = 252
        XCTAssertEqual(measurement.componentsTranslation, "252 kg")
        
        measurement.amount = 1.25
        measurement.unit = .milliliter
        XCTAssertEqual(measurement.componentsTranslation, "1.2 mL")
        
        measurement.amount = 76.666
        XCTAssertEqual(measurement.componentsTranslation, "77 mL")
        
        measurement.amount = 901.01
        XCTAssertEqual(measurement.componentsTranslation, "900 mL")
        
        measurement.amount = 3.75
        measurement.unit = .liter
        XCTAssertEqual(measurement.componentsTranslation, "3 L 750 mL")
        
        measurement.amount = 99.999
        XCTAssertEqual(measurement.componentsTranslation, "99 L 1000 mL")
        
        measurement.amount = 624.83
        XCTAssertEqual(measurement.componentsTranslation, "624 L 830 mL")
        
        measurement.amount = 2.675
        measurement.unit = .ounce
        XCTAssertEqual(measurement.componentsTranslation, "2\(Fraction.twoThirds.stringValue) oz")
        
        measurement.amount = 6.90
        XCTAssertEqual(measurement.componentsTranslation, "7 oz")
        
        measurement.amount = 8.5
        XCTAssertEqual(measurement.componentsTranslation, "8\(Fraction.oneHalf.stringValue) oz")
        
        measurement.amount = 1.32
        measurement.unit = .pound
        XCTAssertEqual(measurement.componentsTranslation, "1 lb 5 oz")
        
        measurement.amount = 2.55
        XCTAssertEqual(measurement.componentsTranslation, "2 lb 8\(Fraction.threeFourths.stringValue) oz")
        
        measurement.amount = 250
        XCTAssertEqual(measurement.componentsTranslation, "250 lb")
        
        measurement.amount = 1.5
        measurement.unit = .pinch
        XCTAssertEqual(measurement.componentsTranslation, "1\(Fraction.oneHalf.stringValue) pn")
        
        measurement.amount = 0.75
        measurement.unit = .dash
        XCTAssertEqual(measurement.componentsTranslation, "\(Fraction.threeFourths.stringValue) ds")
        
        measurement.amount = 2.66
        measurement.unit = .teaspoon
        XCTAssertEqual(measurement.componentsTranslation, "2 \(Fraction.twoThirds.stringValue) tsp")
        
        measurement.amount = 3.5
        measurement.unit = .tablespoon
        XCTAssertEqual(measurement.componentsTranslation, "3 tbsp 1\(Fraction.oneHalf.stringValue) tsp")
        
        measurement.amount = 8.111
        measurement.unit = .fluidOunce
        XCTAssertEqual(measurement.componentsTranslation, "8 fl oz \(Fraction.oneFourth.stringValue) tbsp")
        
        measurement.amount = 4.625
        measurement.unit = .cup
        XCTAssertEqual(measurement.componentsTranslation, "4 \(Fraction.fiveEighths.stringValue) c")
        
        measurement.amount = 2.778
        measurement.unit = .pint
        XCTAssertEqual(measurement.componentsTranslation, "2 pt 1\(Fraction.oneHalf.stringValue) c")
        
        measurement.amount = 3.333
        measurement.unit = .quart
        XCTAssertEqual(measurement.componentsTranslation, "3 qt \(Fraction.twoThirds.stringValue) pt")
        
        measurement.amount = 1.789
        measurement.unit = .gallon
        XCTAssertEqual(measurement.componentsTranslation, "1 gal 3\(Fraction.oneEighth.stringValue) qt")
        
        measurement.amount = 2.5
        measurement.unit = .cup
        XCTAssertEqual(measurement.componentsTranslation, "2 \(Fraction.oneHalf.stringValue) c")
        
        Configuration.abbreviateTranslations = false
    }
    
    func testMetricTranslation() {
    }
    
    func testFractionTranslation() {
    }
}
