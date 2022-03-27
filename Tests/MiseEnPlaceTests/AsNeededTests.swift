import Foundation
import XCTest
@testable import MiseEnPlace

class AsNeededTests: XCTestCase {
    
    private var measuredIngredient: TestMeasuredIngredient = TestMeasuredIngredient(ratio: Ratio(volume: 1.0, weight: 1.0))
    
    func testFormulaElementScaleBy() {
        measuredIngredient.unit = .ounce
        measuredIngredient.amount = -1
        
        XCTAssertThrowsError(try measuredIngredient.scale(by: 1.0, measurementSystem: .us, measurementMethod: .volume)) { (error) in
            guard case MiseEnPlaceError.nanZeroConversion = error else {
                XCTFail("Expected MisEnPlaceError.nanZeroConversion")
                return
            }
        }
    }
}
