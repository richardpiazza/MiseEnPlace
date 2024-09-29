import Foundation
import XCTest
@testable import MiseEnPlace

class LooseConversionTests: XCTestCase {
    
    private var measuredIngredient: FormulaElement = AnyFormulaElement(
        measured: .ingredient(
            AnyIngredient(
                volume: 1.0,
                weight: 1.0
            )
        )
    )
    
    private static var useLooseConversions: Bool = false
    
    override func setUp() {
        super.setUp()
        Self.useLooseConversions = Configuration.useLooseConversions
        Configuration.useLooseConversions = true
    }
    
    override func tearDown() {
        Configuration.useLooseConversions = Self.useLooseConversions
        super.tearDown()
    }

    func testEqualRatioMeasurementAmountFor() throws {
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
        XCTAssertEqual(try measuredIngredient.amount(for: .ounce), 128.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .pound), 8.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .milliliter), 3840.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .liter), 3.84, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .gram), 3840.0, accuracy: 0.01)
        XCTAssertEqual(try measuredIngredient.amount(for: .kilogram), 3.84, accuracy: 0.01)
    }
    
    func testEqualRatioScaleUSMassToUSMass() throws {
        measuredIngredient.amount = 2
        measuredIngredient.unit = .pound
        
        let quantification = try measuredIngredient.scale(by: 0.25, measurementSystem: .us, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 8)
        XCTAssertEqual(quantification.unit, .ounce)
    }
    
    func testEqualRatioScaleUSMassToUSVolume() throws {
        measuredIngredient.amount = 0.5
        measuredIngredient.unit = .pound
        
        let quantification = try measuredIngredient.scale(by: 1.25, measurementSystem: .us, measurementMethod: .volume)
        
        XCTAssertEqual(quantification.amount, 1.25, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .cup)
    }
    
    func testEqualRatioScaleUSMassToMetricMass() throws {
        measuredIngredient.amount = 10
        measuredIngredient.unit = .ounce
        
        let quantification = try measuredIngredient.scale(by: 1.0, measurementSystem: .metric, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 300.0, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .gram)
    }
    
    func testEqualRatioScaleUSMassToMetricVolume() throws {
        measuredIngredient.amount = 4
        measuredIngredient.unit = .ounce
        
        let quantification = try measuredIngredient.scale(by: 2.0, measurementSystem: .metric, measurementMethod: .volume)
        
        XCTAssertEqual(quantification.amount, 240.0, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .milliliter)
    }
    
    func testEqualRatioScaleUSVolumeToUSMass() throws {
        measuredIngredient.amount = 4
        measuredIngredient.unit = .tablespoon
        
        let quantification = try measuredIngredient.scale(by: 3.5, measurementSystem: .us, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 7.0, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .ounce)
    }
    
    func testEqualRatioScaleUSVolumeToUSVolume() throws {
        measuredIngredient.amount = 28
        measuredIngredient.unit = .quart
        
        let quantification = try measuredIngredient.scale(by: Fraction.oneSixteenth.rawValue, measurementSystem: .us, measurementMethod: .volume)
        
        XCTAssertEqual(quantification.amount, 1.75, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .quart)
    }
    
    func testEqualRatioScaleUSVolumeToMetricMass() throws {
        measuredIngredient.amount = 1
        measuredIngredient.unit = .gallon
        
        let quantification = try measuredIngredient.scale(by: 1.75, measurementSystem: .metric, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 6.72, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .kilogram)
    }
    
    func testEqualRatioScaleUSVolumeToMetricVolume() throws {
        measuredIngredient.amount = 1.3
        measuredIngredient.unit = .ounce
        
        let quantification = try measuredIngredient.scale(by: 3.0, measurementSystem: .metric, measurementMethod: .volume)
        
        XCTAssertEqual(quantification.amount, 117.0, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .milliliter)
    }
    
    func testEqualRatioScaleMetricMassToUSMass() throws {
        measuredIngredient.amount = 250
        measuredIngredient.unit = .gram
        
        let quantification = try measuredIngredient.scale(by: Fraction.oneHalf.rawValue, measurementSystem: .us, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 4.17, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .ounce)
    }
    
    func testEqualRatioScaleMetricMassToUSVolume() throws {
        measuredIngredient.amount = 1.68
        measuredIngredient.unit = .kilogram
        
        let quantification = try measuredIngredient.scale(by: 1.0, measurementSystem: .us, measurementMethod: .volume)
        
        XCTAssertEqual(quantification.amount, 1.75, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .quart)
    }
    
    func testEqualRatioScaleMetricMassToMetricMass() throws {
        measuredIngredient.amount = 22
        measuredIngredient.unit = .kilogram
        
        let quantification = try measuredIngredient.scale(by: Fraction.oneThird.rawValue, measurementSystem: .metric, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 7.33, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .kilogram)
    }
    
    func testEqualRatioScaleMetricMassToMetricVolume() throws {
        measuredIngredient.amount = 888.888
        measuredIngredient.unit = .gram
        
        let quantification = try measuredIngredient.scale(by: Fraction.twoThirds.rawValue, measurementSystem: .metric, measurementMethod: .volume)
        
        XCTAssertEqual(quantification.amount, 592.53, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .milliliter)
    }
    
    func testEqualRatioScaleMetricVolumeToUSMass() throws {
        measuredIngredient.amount = 130
        measuredIngredient.unit = .milliliter
        
        let quantification = try measuredIngredient.scale(by: 1.01, measurementSystem: .us, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 4.38, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .ounce)
    }
    
    func testEqualRatioScaleMetricVolumeToUSVolume() throws {
        measuredIngredient.amount = 2.99
        measuredIngredient.unit = .liter
        
        let quantification = try measuredIngredient.scale(by: Fraction.oneSixth.rawValue, measurementSystem: .us, measurementMethod: .volume)
        
        XCTAssertEqual(quantification.amount, 1.04, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .pint)
    }
    
    func testEqualRatioScaleMetricVolumeToMetricMass() throws {
        measuredIngredient.amount = 45
        measuredIngredient.unit = .liter
        
        let quantification = try measuredIngredient.scale(by: 1.0, measurementSystem: .metric, measurementMethod: .weight)
        
        XCTAssertEqual(quantification.amount, 45, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .kilogram)
    }
    
    func testEqualRatioScaleMetricVolumeToMetricVolume() throws {
        measuredIngredient.amount = 45000
        measuredIngredient.unit = .milliliter
        
        let quantification = try measuredIngredient.scale(by: Fraction.oneThousandth.rawValue, measurementSystem: .metric, measurementMethod: .volume)
        
        XCTAssertEqual(quantification.amount, 45, accuracy: 0.01)
        XCTAssertEqual(quantification.unit, .milliliter)
    }
}
