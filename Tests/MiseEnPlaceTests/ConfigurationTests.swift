import XCTest
@testable import MiseEnPlace

class ConfigurationTests: XCTestCase {
    
    static var allTests = [
        ("testLocale", testLocale),
        ("testAbbreviateTranslations", testAbbreviateTranslations),
        ("testUseLooseConversions", testUseLooseConversions),
        ("testFluidOunceMilliliter", testFluidOunceMilliliter),
        ("testOunceGram", testOunceGram),
        ("testSmallMeasurement", testSmallMeasurement),
        ("testLargeMeasurement", testLargeMeasurement),
    ]
    
    let us = Locale(identifier: "en_US")
    let gb = Locale(identifier: "en_GB")
    
    func testLocale() {
        XCTAssertEqual(Configuration.locale, .current)
        Configuration.locale = gb
        XCTAssertEqual(Configuration.locale, gb)
        Configuration.locale = .current
    }
    
    func testAbbreviateTranslations() {
        let current = Configuration.abbreviateTranslations
        Configuration.abbreviateTranslations = true
        XCTAssertEqual(Configuration.abbreviateTranslations, true)
        Configuration.abbreviateTranslations = false
        XCTAssertEqual(Configuration.abbreviateTranslations, false)
        Configuration.abbreviateTranslations = current
    }
    
    func testUseLooseConversions() {
        let current = Configuration.useLooseConversions
        Configuration.useLooseConversions = true
        XCTAssertEqual(Configuration.useLooseConversions, true)
        Configuration.useLooseConversions = false
        XCTAssertEqual(Configuration.useLooseConversions, false)
        Configuration.useLooseConversions = current
    }
    
    func testFluidOunceMilliliter() {
        let current = Configuration.useLooseConversions
        Configuration.useLooseConversions = false
        XCTAssertEqual(Configuration.fluidOunceMilliliter, Configuration.preciseFluidOunceMilliliter)
        Configuration.useLooseConversions = true
        XCTAssertEqual(Configuration.fluidOunceMilliliter, Configuration.looseFluidOunceMilliliter)
        Configuration.useLooseConversions = current
    }
    
    func testOunceGram() {
        let current = Configuration.useLooseConversions
        Configuration.useLooseConversions = false
        XCTAssertEqual(Configuration.ounceGram, Configuration.preciseOunceGram)
        Configuration.useLooseConversions = true
        XCTAssertEqual(Configuration.ounceGram, Configuration.looseOunceGram)
        Configuration.useLooseConversions = current
    }
    
    func testSmallMeasurement() {
        let current = Configuration.locale
        
        Configuration.locale = us
        var smallMeasurement = Configuration.smallMeasurement
        XCTAssertEqual(smallMeasurement.amount, 1.0)
        XCTAssertEqual(smallMeasurement.unit, .ounce)
        
        Configuration.locale = gb
        smallMeasurement = Configuration.smallMeasurement
        XCTAssertEqual(smallMeasurement.amount, 100.0)
        XCTAssertEqual(smallMeasurement.unit, .gram)
        
        Configuration.locale = current
    }
    
    func testLargeMeasurement() {
        let current = Configuration.locale
        
        Configuration.locale = us
        var measurement = Configuration.largeMeasurement
        XCTAssertEqual(measurement.amount, 1.0)
        XCTAssertEqual(measurement.unit, .pound)
        
        Configuration.locale = gb
        measurement = Configuration.largeMeasurement
        XCTAssertEqual(measurement.amount, 1.0)
        XCTAssertEqual(measurement.unit, .kilogram)
        
        Configuration.locale = current
    }
    
    func testSingleDecimalFormatter() {
        let decimal: Double = 1.563
        guard let formatted = Configuration.singleDecimalFormatter.string(for: decimal) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(formatted, "1.6")
    }
    
    func testSignificantDigitFormatter() {
        let decimal: Double = 0.563
        guard let formatted = Configuration.significantDigitFormatter.string(for: decimal) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(formatted, "0.56")
    }
}
