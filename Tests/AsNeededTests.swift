import XCTest
@testable import MiseEnPlace

class AsNeededTests: XCTestCase {
    var ingredient: ConvertableIngredient = ConvertableIngredient()

    override func setUp() {
        super.setUp()
        
        ingredient.ratio.weight = 1
        ingredient.ratio.volume = 1
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAsNeededConvertAndInterpret() {
        ingredient.measurement.unit = .asNeeded
        
        let scaleMeasure = try! ingredient.scale(by: 1.0, measurementSystemMethod: .usVolume)
        XCTAssertTrue(scaleMeasure.amount == 0)
        XCTAssertTrue(scaleMeasure.unit == .asNeeded)
        
        let interpret = scaleMeasure.componentsTranslation
        XCTAssertTrue(interpret == "As Needed")
    }
}
