import XCTest
@testable import MiseEnPlace

class RatioTests: XCTestCase {
    
    func testOneToOneRatio() {
        let volumeMeasurement = MiseEnPlace.Measurement(amount: 2.0, unit: .fluidOunce)
        let weightMeasurement = MiseEnPlace.Measurement(amount: 2.0, unit: .ounce)
        
        let ratio: Ratio
        do {
            ratio = try Ratio.makeRatio(volume: volumeMeasurement, weight: weightMeasurement)
        } catch {
            XCTFail()
            return
        }
        
        XCTAssertEqual(ratio.volume, 1.0)
        XCTAssertEqual(ratio.weight, 1.0)
    }
    
    func testOneToTwoRatio() {
        let volumeMeasurement = MiseEnPlace.Measurement(amount: 2.0, unit: .fluidOunce)
        let weightMeasurement = MiseEnPlace.Measurement(amount: 4.0, unit: .ounce)
        
        let ratio: Ratio
        do {
            ratio = try Ratio.makeRatio(volume: volumeMeasurement, weight: weightMeasurement)
        } catch {
            XCTFail()
            return
        }
        
        XCTAssertEqual(ratio.volume, 1.0)
        XCTAssertEqual(ratio.weight, 2.0)
    }
    
    func testTwoToOneRatio() {
        let volumeMeasurement = MiseEnPlace.Measurement(amount: 4.0, unit: .fluidOunce)
        let weightMeasurement = MiseEnPlace.Measurement(amount: 2.0, unit: .ounce)
        
        let ratio: Ratio
        do {
            ratio = try Ratio.makeRatio(volume: volumeMeasurement, weight: weightMeasurement)
        } catch {
            XCTFail()
            return
        }
        
        XCTAssertEqual(ratio.volume, 2.0)
        XCTAssertEqual(ratio.weight, 1.0)
    }
}
