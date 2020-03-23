import Foundation
import XCTest
@testable import MiseEnPlace

class HighMassRatioIngredientTests: XCTestCase {
    
    static var allTests = [
        ("testMeasurementAmountForUSVolume", testMeasurementAmountForUSVolume),
        ("testMeasurementAmountForUSMass", testMeasurementAmountForUSMass),
        ("testMeasurementAmountForMetricVolume", testMeasurementAmountForMetricVolume),
        ("testMeasurementAmountForMetricMass", testMeasurementAmountForMetricMass),
        ("testScaleUSMassToUSMass", testScaleUSMassToUSMass),
        ("testScaleUSMassToUSVolume", testScaleUSMassToUSVolume),
        ("testScaleUSMassToMetricMass", testScaleUSMassToMetricMass),
        ("testScaleUSMassToMetricVolume", testScaleUSMassToMetricVolume),
        ("testScaleUSVolumeToUSMass", testScaleUSVolumeToUSMass),
        ("testScaleUSVolumeToUSVolume", testScaleUSVolumeToUSVolume),
        ("testScaleUSVolumeToMetricMass", testScaleUSVolumeToMetricMass),
        ("testScaleUSVolumeToMetricVolume", testScaleUSVolumeToMetricVolume),
        ("testScaleMetricMassToUSMass", testScaleMetricMassToUSMass),
        ("testScaleMetricMassToUSVolume", testScaleMetricMassToUSVolume),
        ("testScaleMetricMassToMetricMass", testScaleMetricMassToMetricMass),
        ("testScaleMetricMassToMetricVolume", testScaleMetricMassToMetricVolume),
        ("testScaleMetricVolumeToUSMass", testScaleMetricVolumeToUSMass),
        ("testScaleMetricVolumeToUSVolume", testScaleMetricVolumeToUSVolume),
        ("testScaleMetricVolumeToMetricMass", testScaleMetricVolumeToMetricMass),
        ("testScaleMetricVolumeToMetricVolume", testScaleMetricVolumeToMetricVolume),
    ]
    
    private var measuredIngredient: TestMeasuredIngredient = TestMeasuredIngredient(ratio: Ratio(volume: 1.0, weight: 1.42))

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
        XCTAssertEqual(try measuredIngredient.amount(for: .ounce), 181.76, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pound), 11.36, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .milliliter), 3785.41, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .liter), 3.79, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .gram), 5152.809, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .kilogram), 5.153, accuracy: 0.01)
    }
    
    func testMeasurementAmountForUSMass() throws {
        measuredIngredient.amount = 5.0
        measuredIngredient.unit = .pound
        
        XCTAssertEqual(try measuredIngredient.amount(for: .gallon), 0.44, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .quart), 1.76, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pint), 3.52, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .cup), 7.052, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .fluidOunce), 56.338, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .tablespoon), 112.676, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .teaspoon), 338.062, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .dash), 2704.496, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pinch), 5408.992, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .ounce), 80.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pound), 5.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .milliliter), 1666.114, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .liter), 1.666, accuracy: 0.01)
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
        XCTAssertEqual(try measuredIngredient.amount(for: .ounce), 37.567, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pound), 2.348, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .milliliter), 750.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .liter), 0.75, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .gram), 1065.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .kilogram), 1.065, accuracy: 0.01)
    }
    
    func testMeasurementAmountForMetricMass() {
        measuredIngredient.amount = 2.5
        measuredIngredient.unit = .kilogram
        
        XCTAssertEqual(try measuredIngredient.amount(for: .gallon), 0.465, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .quart), 1.86, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pint), 3.721, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .cup), 7.441, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .fluidOunce), 59.532, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .tablespoon), 119.063, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .teaspoon), 357.226, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .dash), 2857.809, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pinch), 5715.618, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .ounce), 88.18, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pound), 5.51, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .milliliter), 1760.563, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .liter), 1.761, accuracy: 0.01)
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
        
        XCTAssertEqual(quantification.amount, 0.88, accuracy: 0.01)
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
        
        XCTAssertEqual(quantification.amount, 166.611, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .milliliter)
    }
    
    func testScaleUSVolumeToUSMass() throws {
        measuredIngredient.amount = 4
        measuredIngredient.unit = .tablespoon
        
        let quantification = try measuredIngredient.scale(by: 3.5, measurementSystem: .us, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 9.94, accuracy: 0.01)
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
        
        XCTAssertEqual(quantification.amount, 9.017, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .kilogram)
    }
    
    func testScaleUSVolumeToMetricVolume() throws {
        measuredIngredient.amount = 1.3
        measuredIngredient.unit = .ounce
        
        let quantification = try measuredIngredient.scale(by: 3.0, measurementSystem: .metric, measurementMethod: .volume)
        
        XCTAssertEqual(quantification.amount, 81.223, accuracy: 0.01)
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
        
        XCTAssertEqual(quantification.amount, 1.25,  accuracy: 0.01)
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
        
        XCTAssertEqual(quantification.amount, 417.277, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .milliliter)
    }
    
    func testScaleMetricVolumeToUSMass() throws {
        measuredIngredient.amount = 130
        measuredIngredient.unit = .milliliter
        
        let quantification = try measuredIngredient.scale(by: 1.01, measurementSystem: .us, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 6.577, accuracy: 0.01)
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
        
        XCTAssertEqual(quantification.amount, 63.9, accuracy: 0.01)
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
