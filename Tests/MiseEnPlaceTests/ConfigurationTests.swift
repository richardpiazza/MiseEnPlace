import Foundation
@testable import MiseEnPlace
import XCTest

class ConfigurationTests: XCTestCase {

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
        XCTAssertEqual(Configuration.millilitersPerFluidOunce, Configuration.preciseMillilitersPerFluidOunce)
        Configuration.useLooseConversions = true
        XCTAssertEqual(Configuration.millilitersPerFluidOunce, Configuration.looseMillilitersPerFluidOunce)
        Configuration.useLooseConversions = current
    }

    func testOunceGram() {
        let current = Configuration.useLooseConversions
        Configuration.useLooseConversions = false
        XCTAssertEqual(Configuration.gramsPerOunce, Configuration.preciseGramsPerOunce)
        Configuration.useLooseConversions = true
        XCTAssertEqual(Configuration.gramsPerOunce, Configuration.looseGramsPerOunce)
        Configuration.useLooseConversions = current
    }

    func testSmallMeasurement() {
        let current = Configuration.locale

        Configuration.locale = us
        var smallMeasurement = Quantification.small
        XCTAssertEqual(smallMeasurement.amount, 1.0)
        XCTAssertEqual(smallMeasurement.unit, .ounce)

        Configuration.locale = gb
        smallMeasurement = Quantification.small
        XCTAssertEqual(smallMeasurement.amount, 100.0)
        XCTAssertEqual(smallMeasurement.unit, .gram)

        Configuration.locale = current
    }

    func testLargeMeasurement() {
        let current = Configuration.locale

        Configuration.locale = us
        var measurement = Quantification.large
        XCTAssertEqual(measurement.amount, 1.0)
        XCTAssertEqual(measurement.unit, .pound)

        Configuration.locale = gb
        measurement = Quantification.large
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
