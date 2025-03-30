import Foundation
@testable import MiseEnPlace
import XCTest

class AsNeededTests: XCTestCase {

    private var measuredIngredient: FormulaElement = AnyFormulaElement(
        measured: .ingredient(AnyIngredient(volume: 1.0, weight: 1.0))
    )

    func testFormulaElementScaleBy() {
        measuredIngredient.unit = .ounce
        measuredIngredient.amount = -1

        XCTAssertThrowsError(try measuredIngredient.scale(by: 1.0, measurementSystem: .us, measurementMethod: .volume)) { error in
            guard case MiseEnPlaceError.nanZeroConversion = error else {
                XCTFail("Expected MisEnPlaceError.nanZeroConversion")
                return
            }
        }
    }
}
