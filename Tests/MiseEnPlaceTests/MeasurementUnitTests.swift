import Foundation
import XCTest
@testable import MiseEnPlace

class MeasurementUnitTests: XCTestCase {
    
    static var allTests = [
        ("testAllMeasurementUnits", testAllMeasurementUnits),
        ("testQuantifiableMeasurementUnits", testQuantifiableMeasurementUnits),
        ("testMeasurementUnitsForSystemMethod", testMeasurementUnitsForSystemMethod),
        ("testMeasurementUnitsForMeasurementMethod", testMeasurementUnitsForMeasurementMethod),
        ("testRawValueInit", testRawValueInit),
        ("testStringValueInit", testStringValueInit),
        ("testLegacyRawValueInit", testLegacyRawValueInit),
    ]
    
    func testAllMeasurementUnits() {
        let units = MeasurementUnit.allCases
        XCTAssertEqual(units.count, 18)
        XCTAssertEqual(units[5], .teaspoon)
        XCTAssertEqual(units[14], .milliliter)
    }
    
    func testQuantifiableMeasurementUnits() {
        let units = MeasurementUnit.quantifiableMeasurementUnits
        XCTAssertEqual(units.count, 15)
        XCTAssertFalse(units.contains(.asNeeded))
        XCTAssertFalse(units.contains(.each))
    }
    
    func testMeasurementUnitsForSystemMethod() {
        var units = MeasurementUnit.measurementUnits(forMeasurementSystemMethod: .numericQuantity)
        XCTAssertEqual(units.count, 2)
        units = MeasurementUnit.measurementUnits(forMeasurementSystemMethod: .usVolume)
        XCTAssertEqual(units.count, 9)
        units = MeasurementUnit.measurementUnits(forMeasurementSystemMethod: .usWeight)
        XCTAssertEqual(units.count, 2)
        units = MeasurementUnit.measurementUnits(forMeasurementSystemMethod: .metricVolume)
        XCTAssertEqual(units.count, 2)
        units = MeasurementUnit.measurementUnits(forMeasurementSystemMethod: .metricWeight)
        XCTAssertEqual(units.count, 2)
    }
    
    func testMeasurementUnitsForMeasurementMethod() {
        var units = MeasurementUnit.measurementUnits(forMeasurementMethod: .quantity)
        XCTAssertEqual(units.count, 2)
        units = MeasurementUnit.measurementUnits(forMeasurementMethod: .volume)
        XCTAssertEqual(units.count, 11)
        XCTAssertEqual(units[2], .teaspoon)
        XCTAssertEqual(units[9], .milliliter)
        units = MeasurementUnit.measurementUnits(forMeasurementMethod: .weight)
        XCTAssertEqual(units.count, 4)
        XCTAssertEqual(units[0], .ounce)
        XCTAssertEqual(units[3], .kilogram)
    }
    
    func testRawValueInit() {
        var unit = MeasurementUnit(rawValue: 0)
        XCTAssertEqual(unit, .asNeeded)
        unit = MeasurementUnit(rawValue: 1)
        XCTAssertEqual(unit, .each)
        unit = MeasurementUnit(rawValue: 1100)
        XCTAssertEqual(unit, .pinch)
        unit = MeasurementUnit(rawValue: 1101)
        XCTAssertEqual(unit, .dash)
        unit = MeasurementUnit(rawValue: 1102)
        XCTAssertEqual(unit, .teaspoon)
        unit = MeasurementUnit(rawValue: 1103)
        XCTAssertEqual(unit, .tablespoon)
        unit = MeasurementUnit(rawValue: 1104)
        XCTAssertEqual(unit, .fluidOunce)
        unit = MeasurementUnit(rawValue: 1105)
        XCTAssertEqual(unit, .cup)
        unit = MeasurementUnit(rawValue: 1106)
        XCTAssertEqual(unit, .pint)
        unit = MeasurementUnit(rawValue: 1107)
        XCTAssertEqual(unit, .quart)
        unit = MeasurementUnit(rawValue: 1108)
        XCTAssertEqual(unit, .gallon)
        unit = MeasurementUnit(rawValue: 1200)
        XCTAssertEqual(unit, .ounce)
        unit = MeasurementUnit(rawValue: 1201)
        XCTAssertEqual(unit, .pound)
        unit = MeasurementUnit(rawValue: 2100)
        XCTAssertEqual(unit, .milliliter)
        unit = MeasurementUnit(rawValue: 2101)
        XCTAssertEqual(unit, .liter)
        unit = MeasurementUnit(rawValue: 2200)
        XCTAssertEqual(unit, .gram)
        unit = MeasurementUnit(rawValue: 2201)
        XCTAssertEqual(unit, .kilogram)
        unit = MeasurementUnit(rawValue: -1)
        XCTAssertEqual(unit, .noUnit)
    }
    
    func testStringValueInit() {
        var unit = MeasurementUnit(stringValue: "As Needed")
        XCTAssertEqual(unit, .asNeeded)
        unit = MeasurementUnit(stringValue: "Each")
        XCTAssertEqual(unit, .each)
        unit = MeasurementUnit(stringValue: "Pinch")
        XCTAssertEqual(unit, .pinch)
        unit = MeasurementUnit(stringValue: "Dash")
        XCTAssertEqual(unit, .dash)
        unit = MeasurementUnit(stringValue: "Teaspoon")
        XCTAssertEqual(unit, .teaspoon)
        unit = MeasurementUnit(stringValue: "Tablespoon")
        XCTAssertEqual(unit, .tablespoon)
        unit = MeasurementUnit(stringValue: "Fluid Ounce")
        XCTAssertEqual(unit, .fluidOunce)
        unit = MeasurementUnit(stringValue: "Cup")
        XCTAssertEqual(unit, .cup)
        unit = MeasurementUnit(stringValue: "Pint")
        XCTAssertEqual(unit, .pint)
        unit = MeasurementUnit(stringValue: "Quart")
        XCTAssertEqual(unit, .quart)
        unit = MeasurementUnit(stringValue: "Gallon")
        XCTAssertEqual(unit, .gallon)
        unit = MeasurementUnit(stringValue: "Ounce")
        XCTAssertEqual(unit, .ounce)
        unit = MeasurementUnit(stringValue: "Pound")
        XCTAssertEqual(unit, .pound)
        unit = MeasurementUnit(stringValue: "Milliliter")
        XCTAssertEqual(unit, .milliliter)
        unit = MeasurementUnit(stringValue: "Liter")
        XCTAssertEqual(unit, .liter)
        unit = MeasurementUnit(stringValue: "Gram")
        XCTAssertEqual(unit, .gram)
        unit = MeasurementUnit(stringValue: "Kilogram")
        XCTAssertEqual(unit, .kilogram)
        unit = MeasurementUnit(stringValue: "Quantity")
        XCTAssertEqual(unit, .each)
        unit = MeasurementUnit(stringValue: "FluidOunce")
        XCTAssertEqual(unit, .fluidOunce)
        unit = MeasurementUnit(stringValue: "Mililitre")
        XCTAssertEqual(unit, .milliliter)
        unit = MeasurementUnit(stringValue: "Litre")
        XCTAssertEqual(unit, .liter)
        unit = MeasurementUnit(stringValue: "")
        XCTAssertEqual(unit, nil)
    }
    
    func testLegacyRawValueInit() {
        var unit = MeasurementUnit(legacyRawValue: 0)
        XCTAssertEqual(unit, .asNeeded)
        unit = MeasurementUnit(legacyRawValue: 1)
        XCTAssertEqual(unit, .each)
        unit = MeasurementUnit(legacyRawValue: 1100)
        XCTAssertEqual(unit, .pinch)
        unit = MeasurementUnit(legacyRawValue: 1101)
        XCTAssertEqual(unit, .dash)
        unit = MeasurementUnit(legacyRawValue: 1102)
        XCTAssertEqual(unit, .teaspoon)
        unit = MeasurementUnit(legacyRawValue: 1103)
        XCTAssertEqual(unit, .tablespoon)
        unit = MeasurementUnit(legacyRawValue: 1104)
        XCTAssertEqual(unit, .fluidOunce)
        unit = MeasurementUnit(legacyRawValue: 1105)
        XCTAssertEqual(unit, .cup)
        unit = MeasurementUnit(legacyRawValue: 1106)
        XCTAssertEqual(unit, .pint)
        unit = MeasurementUnit(legacyRawValue: 1107)
        XCTAssertEqual(unit, .quart)
        unit = MeasurementUnit(legacyRawValue: 1108)
        XCTAssertEqual(unit, .gallon)
        unit = MeasurementUnit(legacyRawValue: 1200)
        XCTAssertEqual(unit, .ounce)
        unit = MeasurementUnit(legacyRawValue: 1201)
        XCTAssertEqual(unit, .pound)
        unit = MeasurementUnit(legacyRawValue: 2100)
        XCTAssertEqual(unit, .milliliter)
        unit = MeasurementUnit(legacyRawValue: 2101)
        XCTAssertEqual(unit, .liter)
        unit = MeasurementUnit(legacyRawValue: 2200)
        XCTAssertEqual(unit, .gram)
        unit = MeasurementUnit(legacyRawValue: 2201)
        XCTAssertEqual(unit, .kilogram)
        unit = MeasurementUnit(legacyRawValue: 9000)
        XCTAssertEqual(unit, .asNeeded)
        unit = MeasurementUnit(legacyRawValue: 9001)
        XCTAssertEqual(unit, .each)
        unit = MeasurementUnit(legacyRawValue: -1)
        XCTAssertEqual(unit, .noUnit)
    }
}
