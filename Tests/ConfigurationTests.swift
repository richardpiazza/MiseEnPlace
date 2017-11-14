import XCTest
@testable import MiseEnPlace

class ConfigurationTests: XCTestCase {

    let us = Locale(identifier: "en_US")
    let gb = Locale(identifier: "en_GB")
    
    override func setUp() {
        super.setUp()
        
        XCTAssertFalse(us.usesMetricSystem)
        XCTAssertTrue(gb.usesMetricSystem)
    }
    
    func testConstants() {
        XCTAssertEqual(Configuration.looseOunceGram, 30.0)
        XCTAssertEqual(Configuration.preciseOunceGram, 28.349523)
        XCTAssertEqual(Configuration.looseFluidOunceMilliliter, 30.0)
        XCTAssertEqual(Configuration.preciseFluidOunceMilliliter, 29.573529)
    }
    
    func testFormatters() {
        let multipleDecimal = 1.562
        let singleDecimal = Configuration.singleDecimalFormatter.string(from: NSNumber(value: multipleDecimal))
        XCTAssertEqual(singleDecimal, "1.6")
        
        let multipleSignificant = 253000.0
        let maxSignificant = Configuration.significantDigitFormatter.string(from: NSNumber(value: multipleSignificant))
        XCTAssertEqual(maxSignificant, "250000")
    }

    func testMultiplierRatios() {
        XCTAssertEqual(Configuration.useLooseConversions, false)
        
        XCTAssertEqual(Configuration.fluidOunceMilliliter, Configuration.preciseFluidOunceMilliliter)
        XCTAssertEqual(Configuration.ounceGram, Configuration.preciseOunceGram)
        
        Configuration.useLooseConversions = true
        XCTAssertEqual(Configuration.useLooseConversions, true)
        
        XCTAssertEqual(Configuration.fluidOunceMilliliter, Configuration.looseFluidOunceMilliliter)
        XCTAssertEqual(Configuration.ounceGram, Configuration.looseOunceGram)
        
        Configuration.useLooseConversions = false
        XCTAssertEqual(Configuration.useLooseConversions, false)
    }
    
    func testSmallAndLargeMeasurements() {
        var smallMeasurement: MiseEnPlace.Measurement
        var largeMeasurement: MiseEnPlace.Measurement
        
        let currentLocale = Configuration.locale
        
        Configuration.locale = us
        
        smallMeasurement = Configuration.smallMeasurement
        largeMeasurement = Configuration.largeMeasurement
        
        XCTAssertEqual(smallMeasurement.amount, 1.0)
        XCTAssertEqual(smallMeasurement.unit, .ounce)
        XCTAssertEqual(largeMeasurement.amount, 1.0)
        XCTAssertEqual(largeMeasurement.unit, .pound)
        
        Configuration.locale = gb
        
        smallMeasurement = Configuration.smallMeasurement
        largeMeasurement = Configuration.largeMeasurement
        
        XCTAssertEqual(smallMeasurement.amount, 100.0)
        XCTAssertEqual(smallMeasurement.unit, .gram)
        XCTAssertEqual(largeMeasurement.amount, 1.0)
        XCTAssertEqual(largeMeasurement.unit, .kilogram)
        
        Configuration.locale = currentLocale
    }
}
