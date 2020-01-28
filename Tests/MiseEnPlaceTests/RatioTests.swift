import Foundation
import XCTest
@testable import MiseEnPlace

class RatioTests: XCTestCase {
    
    static var allTests = [
        ("testOneToOneRatio", testOneToOneRatio),
        ("testOneToTwoRatio", testOneToTwoRatio),
        ("testTwoToOneRatio", testTwoToOneRatio),
        ("testMakeRatioErrors", testMakeRatioErrors),
    ]
    
    private var volume: Quantification = Quantification()
    private var weight: Quantification = Quantification()
    
    func testOneToOneRatio() throws {
        volume.amount = 2
        volume.unit = .fluidOunce
        weight.amount = 2
        weight.unit = .ounce
        
        let ratio = try Ratio.makeRatio(volume: volume, weight: weight)
        
        XCTAssertTrue(ratio.volume == 1)
        XCTAssertTrue(ratio.weight == 1)
    }
    
    func testOneToTwoRatio() throws {
        volume.amount = 2
        volume.unit = .fluidOunce
        weight.amount = 4
        weight.unit = .ounce
        
        let ratio = try Ratio.makeRatio(volume: volume, weight: weight)
        
        XCTAssertTrue(ratio.volume == 1)
        XCTAssertTrue(ratio.weight == 2)
    }
    
    func testTwoToOneRatio() throws {
        volume.amount = 4
        volume.unit = .fluidOunce
        weight.amount = 2
        weight.unit = .ounce
        
        let ratio = try Ratio.makeRatio(volume: volume, weight: weight)
        
        XCTAssertTrue(ratio.volume == 2)
        XCTAssertTrue(ratio.weight == 1)
    }
    
    func testMakeRatioErrors() throws {
        volume.amount = -1
        
        XCTAssertThrowsError(try Ratio.makeRatio(volume: volume, weight: weight)) { (error) in
            guard case MiseEnPlaceError.measurementAmount(method: .volume) = error else {
                XCTFail("Expected MisEnPlaceError.measurementAmount(method: .volume)")
                return
            }
        }
        
        volume.amount = 1
        volume.unit = .gram
        
        XCTAssertThrowsError(try Ratio.makeRatio(volume: volume, weight: weight)) { (error) in
            guard case MiseEnPlaceError.measurementUnit(method: .volume) = error else {
                XCTFail("Expected MisEnPlaceError.measurementUnit(method: .volume)")
                return
            }
        }
        
        volume.unit = .fluidOunce
        weight.amount = -1
        
        XCTAssertThrowsError(try Ratio.makeRatio(volume: volume, weight: weight)) { (error) in
            guard case MiseEnPlaceError.measurementAmount(method: .weight) = error else {
                XCTFail("Expected MisEnPlaceError.measurementAmount(method: .weight)")
                return
            }
        }
        
        weight.amount = 1
        weight.unit = .teaspoon
        
        XCTAssertThrowsError(try Ratio.makeRatio(volume: volume, weight: weight)) { (error) in
            guard case MiseEnPlaceError.measurementUnit(method: .weight) = error else {
                XCTFail("Expected MisEnPlaceError.measurementUnit(method: .weight)")
                return
            }
        }
        
        weight.unit = .ounce
        
        _ = try Ratio.makeRatio(volume: volume, weight: weight)
    }
}
