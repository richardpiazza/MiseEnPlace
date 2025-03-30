import Foundation
@testable import MiseEnPlace
import XCTest

final class QuantificationTests: XCTestCase {

    private let us = Locale(identifier: "en_US")
    private let gb = Locale(identifier: "en_GB")

    func testEqualRatioMeasurementPair() throws {
        let currentLocale = Configuration.locale

        Configuration.locale = us
        var equalRatio = Quantification.equalRatio
        var ratio = try Ratio.makeRatio(volume: equalRatio.volume, weight: equalRatio.weight)
        XCTAssertEqual(ratio, .oneToOne)

        Configuration.locale = gb
        equalRatio = Quantification.equalRatio
        ratio = try Ratio.makeRatio(volume: equalRatio.volume, weight: equalRatio.weight)
        XCTAssertEqual(ratio, .oneToOne)

        Configuration.locale = currentLocale
    }
}
