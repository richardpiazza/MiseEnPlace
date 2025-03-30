import Foundation
@testable import MiseEnPlace
import XCTest

class FractionTests: XCTestCase {

    func testRawValue() {
        XCTAssertEqual(Fraction(rawValue: 0.0), .zero)
        XCTAssertEqual(Fraction(rawValue: 0.001), .oneThousandth)
        XCTAssertEqual(Fraction(rawValue: 0.0625), .oneSixteenth)
        XCTAssertEqual(Fraction(rawValue: 0.125), .oneEighth)
        XCTAssertEqual(Fraction(rawValue: 0.1666), .oneSixth)
        XCTAssertEqual(Fraction(rawValue: 0.25), .oneFourth)
        XCTAssertEqual(Fraction(rawValue: 0.3333), .oneThird)
        XCTAssertEqual(Fraction(rawValue: 0.5), .oneHalf)
        XCTAssertEqual(Fraction(rawValue: 0.625), .fiveEighths)
        XCTAssertEqual(Fraction(rawValue: 0.6666), .twoThirds)
        XCTAssertEqual(Fraction(rawValue: 0.75), .threeFourths)
        XCTAssertEqual(Fraction(rawValue: 0.875), .sevenEighths)
        XCTAssertEqual(Fraction(rawValue: 1.0), .one)
    }

    func testApproximateValue() {
        XCTAssertEqual(Fraction(approximateValue: 0.0), .zero)
        XCTAssertEqual(Fraction(approximateValue: 0.001), .oneThousandth)
        XCTAssertEqual(Fraction(approximateValue: 0.0625), .oneSixteenth)
        XCTAssertEqual(Fraction(approximateValue: 0.125), .oneEighth)
        XCTAssertEqual(Fraction(approximateValue: 0.166), .oneSixth)
        XCTAssertEqual(Fraction(approximateValue: 0.25), .oneFourth)
        XCTAssertEqual(Fraction(approximateValue: 0.333), .oneThird)
        XCTAssertEqual(Fraction(approximateValue: 0.5), .oneHalf)
        XCTAssertEqual(Fraction(approximateValue: 0.625), .fiveEighths)
        XCTAssertEqual(Fraction(approximateValue: 0.666), .twoThirds)
        XCTAssertEqual(Fraction(approximateValue: 0.75), .threeFourths)
        XCTAssertEqual(Fraction(approximateValue: 0.875), .sevenEighths)
        XCTAssertEqual(Fraction(approximateValue: 1.0), .one)
    }

    func testProximateValue() {
        XCTAssertEqual(Fraction(proximateValue: 0.0), .zero)
        XCTAssertEqual(Fraction(proximateValue: 0.001), .oneThousandth)
        XCTAssertEqual(Fraction(proximateValue: 0.0625), .oneSixteenth)
        XCTAssertEqual(Fraction(proximateValue: 0.125), .oneEighth)
        XCTAssertEqual(Fraction(proximateValue: 0.166), .oneSixth)
        XCTAssertEqual(Fraction(proximateValue: 0.25), .oneFourth)
        XCTAssertEqual(Fraction(proximateValue: 0.333), .oneThird)
        XCTAssertEqual(Fraction(proximateValue: 0.5), .oneHalf)
        XCTAssertEqual(Fraction(proximateValue: 0.625), .fiveEighths)
        XCTAssertEqual(Fraction(proximateValue: 0.666), .twoThirds)
        XCTAssertEqual(Fraction(proximateValue: 0.75), .threeFourths)
        XCTAssertEqual(Fraction(proximateValue: 0.875), .sevenEighths)
        XCTAssertEqual(Fraction(proximateValue: 1.0), .one)

        XCTAssertEqual(Fraction(proximateValue: 0.0), .zero)
        XCTAssertEqual(Fraction(proximateValue: 0.0005), .zero)
        XCTAssertEqual(Fraction(proximateValue: 0.032), .zero)
        XCTAssertEqual(Fraction(proximateValue: 0.094), .zero)
        XCTAssertEqual(Fraction(proximateValue: 0.146), .oneSixth)
        XCTAssertEqual(Fraction(proximateValue: 0.209), .oneFourth)
        XCTAssertEqual(Fraction(proximateValue: 0.292), .oneThird)
        XCTAssertEqual(Fraction(proximateValue: 0.417), .oneHalf)
        XCTAssertEqual(Fraction(proximateValue: 0.563), .fiveEighths)
        XCTAssertEqual(Fraction(proximateValue: 0.646), .twoThirds)
        XCTAssertEqual(Fraction(proximateValue: 0.709), .threeFourths)
        XCTAssertEqual(Fraction(proximateValue: 0.8125), .sevenEighths)
        XCTAssertEqual(Fraction(proximateValue: 0.876), .one)
    }

    func testDescription() {
        XCTAssertEqual(Fraction.zero.description, "")
        XCTAssertEqual(Fraction.oneThousandth.description, "⅟1000")
        XCTAssertEqual(Fraction.oneSixteenth.description, "⅟16")
        XCTAssertEqual(Fraction.oneEighth.description, "⅛")
        XCTAssertEqual(Fraction.oneSixth.description, "⅙")
        XCTAssertEqual(Fraction.oneFourth.description, "¼")
        XCTAssertEqual(Fraction.oneThird.description, "⅓")
        XCTAssertEqual(Fraction.oneHalf.description, "½")
        XCTAssertEqual(Fraction.fiveEighths.description, "⅝")
        XCTAssertEqual(Fraction.twoThirds.description, "⅔")
        XCTAssertEqual(Fraction.threeFourths.description, "¾")
        XCTAssertEqual(Fraction.sevenEighths.description, "⅞")
        XCTAssertEqual(Fraction.one.description, "")
    }

    func testIsCommon() {
        XCTAssertEqual(Fraction.zero.isCommon, false)
        XCTAssertEqual(Fraction.oneThousandth.isCommon, false)
        XCTAssertEqual(Fraction.oneSixteenth.isCommon, false)
        XCTAssertEqual(Fraction.oneEighth.isCommon, true)
        XCTAssertEqual(Fraction.oneSixth.isCommon, false)
        XCTAssertEqual(Fraction.oneFourth.isCommon, true)
        XCTAssertEqual(Fraction.oneThird.isCommon, true)
        XCTAssertEqual(Fraction.oneHalf.isCommon, true)
        XCTAssertEqual(Fraction.fiveEighths.isCommon, false)
        XCTAssertEqual(Fraction.twoThirds.isCommon, true)
        XCTAssertEqual(Fraction.threeFourths.isCommon, true)
        XCTAssertEqual(Fraction.sevenEighths.isCommon, false)
        XCTAssertEqual(Fraction.one.isCommon, false)
    }

    func testIsUnicodeRepresentable() {
        XCTAssertEqual(Fraction.zero.isUnicodeRepresentable, false)
        XCTAssertEqual(Fraction.oneThousandth.isUnicodeRepresentable, false)
        XCTAssertEqual(Fraction.oneSixteenth.isUnicodeRepresentable, false)
        XCTAssertEqual(Fraction.oneEighth.isUnicodeRepresentable, true)
        XCTAssertEqual(Fraction.oneSixth.isUnicodeRepresentable, true)
        XCTAssertEqual(Fraction.oneFourth.isUnicodeRepresentable, true)
        XCTAssertEqual(Fraction.oneThird.isUnicodeRepresentable, true)
        XCTAssertEqual(Fraction.oneHalf.isUnicodeRepresentable, true)
        XCTAssertEqual(Fraction.fiveEighths.isUnicodeRepresentable, true)
        XCTAssertEqual(Fraction.twoThirds.isUnicodeRepresentable, true)
        XCTAssertEqual(Fraction.threeFourths.isUnicodeRepresentable, true)
        XCTAssertEqual(Fraction.sevenEighths.isUnicodeRepresentable, true)
        XCTAssertEqual(Fraction.one.isUnicodeRepresentable, false)
    }
}
