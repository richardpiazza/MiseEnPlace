import Foundation
import XCTest
@testable import MiseEnPlace

class HighVolumeRatioIngredientTests: XCTestCase {
    
    private var measuredIngredient: TestMeasuredIngredient = TestMeasuredIngredient(ratio: Ratio(volume: 1.14, weight: 1.0))
    
    func testMeasurementAmountForUSVolume() throws {
        measuredIngredient.amount = 1.0
        measuredIngredient.unit = .gallon
        
        XCTAssertEqual(try measuredIngredient.amount(for: .gallon), 1.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .quart), 4.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pint), 8.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .cup), 16.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .fluidOunce), 128.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .tablespoon), 256.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .teaspoon), 768.08, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .dash), 6144.61, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pinch), 12289.23, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .ounce), 112.281, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pound), 7.018, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .milliliter), 3785.41, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .liter), 3.79, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .gram), 3183.104, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .kilogram), 3.183, accuracy: 0.01)
    }
    
    func testMeasurementAmountForUSMass() throws {
        measuredIngredient.amount = 5.0
        measuredIngredient.unit = .pound
        
        XCTAssertEqual(try measuredIngredient.amount(for: .gallon), 0.712, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .quart), 2.849, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pint), 5.69, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .cup), 11.39, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .fluidOunce), 91.19, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .tablespoon), 182.39, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .teaspoon), 547.255, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .dash), 4378.038, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pinch), 8756.076, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .ounce), 80.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pound), 5.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .milliliter), 2697.106, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .liter), 2.697, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .gram), 2267.96, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .kilogram), 2.27, accuracy: 0.01)
    }
    
    func testMeasurementAmountForMetricVolume() {
        measuredIngredient.amount = 750.0
        measuredIngredient.unit = .milliliter
        
        XCTAssertEqual(try measuredIngredient.amount(for: .gallon), 0.20, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .quart), 0.79, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pint), 1.59, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .cup), 3.17, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .fluidOunce), 25.36, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .tablespoon), 50.72, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .teaspoon), 152.18, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .dash), 1217.43, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pinch), 2434.85, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .ounce), 23.207, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pound), 1.45, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .milliliter), 750.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .liter), 0.75, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .gram), 657.895, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .kilogram), 0.658, accuracy: 0.01)
    }
    
    func testMeasurementAmountForMetricMass() {
        measuredIngredient.amount = 2.5
        measuredIngredient.unit = .kilogram
        
        XCTAssertEqual(try measuredIngredient.amount(for: .gallon), 0.753, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .quart), 3.012, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pint), 6.023, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .cup), 12.046, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .fluidOunce), 96.369, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .tablespoon), 192.739, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .teaspoon), 578.277, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .dash), 4626.22, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pinch), 9252.44, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .ounce), 88.18, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pound), 5.51, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .milliliter), 2849.99, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .liter), 2.849, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .gram), 2500.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .kilogram), 2.5, accuracy: 0.01)
    }
    
    func testScaleUSMassToUSMass() throws {
        measuredIngredient.amount = 2
        measuredIngredient.unit = .pound
        
        let quantification = try measuredIngredient.scale(by: 0.25, measurementSystem: .us, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 8)
        XCTAssertEqual(quantification.unit, .ounce)
    }
    
    func testScaleUSMassToUSVolume() throws {
        measuredIngredient.amount = 0.5
        measuredIngredient.unit = .pound
        
        let quantification = try measuredIngredient.scale(by: 1.25, measurementSystem: .us, measurementMethod: .volume)
        
        XCTAssertEqual(quantification.amount, 1.425, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .cup)
    }
    
    func testScaleUSMassToMetricMass() throws {
        measuredIngredient.amount = 10
        measuredIngredient.unit = .ounce
        
        let quantification = try measuredIngredient.scale(by: 1.0, measurementSystem: .metric, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 283.50, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .gram)
    }
    
    func testScaleUSMassToMetricVolume() throws {
        measuredIngredient.amount = 4
        measuredIngredient.unit = .ounce
        
        let quantification = try measuredIngredient.scale(by: 2.0, measurementSystem: .metric, measurementMethod: .volume)
        
        XCTAssertEqual(quantification.amount, 269.711, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .milliliter)
    }
    
    func testScaleUSVolumeToUSMass() throws {
        measuredIngredient.amount = 4
        measuredIngredient.unit = .tablespoon
        
        let quantification = try measuredIngredient.scale(by: 3.5, measurementSystem: .us, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 6.14, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .ounce)
    }
    
    func testScaleUSVolumeToUSVolume() throws {
        measuredIngredient.amount = 28
        measuredIngredient.unit = .quart
        
        let quantification = try measuredIngredient.scale(by: Fraction.oneSixteenth.rawValue, measurementSystem: .us, measurementMethod: .volume)
        
        XCTAssertEqual(quantification.amount, 1.75, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .quart)
    }
    
    func testScaleUSVolumeToMetricMass() throws {
        measuredIngredient.amount = 1
        measuredIngredient.unit = .gallon
        
        let quantification = try measuredIngredient.scale(by: 1.75, measurementSystem: .metric, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 5.57, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .kilogram)
    }
    
    func testScaleUSVolumeToMetricVolume() throws {
        measuredIngredient.amount = 1.3
        measuredIngredient.unit = .ounce
        
        let quantification = try measuredIngredient.scale(by: 3.0, measurementSystem: .metric, measurementMethod: .volume)
        
        XCTAssertEqual(quantification.amount, 131.484, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .milliliter)
    }
    
    func testScaleMetricMassToUSMass() throws {
        measuredIngredient.amount = 250
        measuredIngredient.unit = .gram
        
        let quantification = try measuredIngredient.scale(by: Fraction.oneHalf.rawValue, measurementSystem: .us, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 4.41, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .ounce)
    }
    
    func testScaleMetricMassToUSVolume() throws {
        measuredIngredient.amount = 1.68
        measuredIngredient.unit = .kilogram
        
        let quantification = try measuredIngredient.scale(by: 1.0, measurementSystem: .us, measurementMethod: .volume)
        
        XCTAssertEqual(quantification.amount, 2.024, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .quart)
    }
    
    func testScaleMetricMassToMetricMass() throws {
        measuredIngredient.amount = 22
        measuredIngredient.unit = .kilogram
        
        let quantification = try measuredIngredient.scale(by: Fraction.oneThird.rawValue, measurementSystem: .metric, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 7.33, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .kilogram)
    }
    
    func testScaleMetricMassToMetricVolume() throws {
        measuredIngredient.amount = 888.888
        measuredIngredient.unit = .gram
        
        let quantification = try measuredIngredient.scale(by: Fraction.twoThirds.rawValue, measurementSystem: .metric, measurementMethod: .volume)
        
        XCTAssertEqual(quantification.amount, 675.487, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .milliliter)
    }
    
    func testScaleMetricVolumeToUSMass() throws {
        measuredIngredient.amount = 130
        measuredIngredient.unit = .milliliter
        
        let quantification = try measuredIngredient.scale(by: 1.01, measurementSystem: .us, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 4.06, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .ounce)
    }
    
    func testScaleMetricVolumeToUSVolume() throws {
        measuredIngredient.amount = 2.99
        measuredIngredient.unit = .liter
        
        let quantification = try measuredIngredient.scale(by: Fraction.oneSixth.rawValue, measurementSystem: .us, measurementMethod: .volume)
        
        XCTAssertEqual(quantification.amount, 1.05, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .pint)
    }
    
    func testScaleMetricVolumeToMetricMass() throws {
        measuredIngredient.amount = 45
        measuredIngredient.unit = .liter
        
        let quantification = try measuredIngredient.scale(by: 1.0, measurementSystem: .metric, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 39.474, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .kilogram)
    }
    
    func testScaleMetricVolumeToMetricVolume() throws {
        measuredIngredient.amount = 45000
        measuredIngredient.unit = .milliliter
        
        let quantification = try measuredIngredient.scale(by: Fraction.oneThousandth.rawValue, measurementSystem: .metric, measurementMethod: .volume)
        
        XCTAssertEqual(quantification.amount, 45, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .milliliter)
    }
}
