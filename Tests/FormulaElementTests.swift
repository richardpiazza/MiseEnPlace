import XCTest
@testable import MiseEnPlace

class FormulaElementTests: XCTestCase {

    let water = _SharedModels.water
    let flour = _SharedModels.flour
    let salt = _SharedModels.salt
    var yeast = _SharedModels.yeast
    
    lazy var measuredWater = MeasuredIngredient(ingredient: self.water, amount: 250.0, unit: .milliliter)
    lazy var measuredFlour = MeasuredIngredient(ingredient: self.flour, amount: 14.0, unit: .ounce)
    lazy var measuredSalt = MeasuredIngredient(ingredient: self.salt, amount: 4.0, unit: .gram)
    lazy var measuredYeast = MeasuredIngredient(ingredient: self.yeast, amount: 2.5, unit: .teaspoon)
    
    override func setUp() {
        super.setUp()
        
        XCTAssertEqual(water.name, "Water")
        XCTAssertEqual(water.volume, 1.0)
        XCTAssertEqual(water.weight, 1.0)
        
        XCTAssertEqual(flour.name, "Bread Flour")
        XCTAssertEqual(flour.volume, 1.88)
        XCTAssertEqual(flour.weight, 1.0)
        
        XCTAssertEqual(salt.name, "Salt")
        XCTAssertEqual(salt.volume, 1.0)
        XCTAssertEqual(salt.weight, 1.2)
        
        XCTAssertEqual(yeast.name, "Active Dry Yeast")
        XCTAssertEqual(yeast.volume, 1.25)
        XCTAssertEqual(yeast.weight, 1.0)
        XCTAssertEqual(yeast.amount, 7.0)
        XCTAssertEqual(yeast.unit, .gram)
        
        XCTAssertNotNil(measuredWater.ingredient)
        XCTAssertEqual(measuredWater.ingredient!.uuid, water.uuid)
        XCTAssertEqual(measuredWater.amount, 250.0)
        XCTAssertEqual(measuredWater.unit, .milliliter)
        
        XCTAssertNotNil(measuredFlour.ingredient)
        XCTAssertEqual(measuredFlour.ingredient!.uuid, flour.uuid)
        XCTAssertEqual(measuredFlour.amount, 14.0)
        XCTAssertEqual(measuredFlour.unit, .ounce)
        
        XCTAssertNotNil(measuredSalt.ingredient)
        XCTAssertEqual(measuredSalt.ingredient!.uuid, salt.uuid)
        XCTAssertEqual(measuredSalt.amount, 4.0)
        XCTAssertEqual(measuredSalt.unit, .gram)
        
        XCTAssertNotNil(measuredYeast.ingredient)
        XCTAssertEqual(measuredYeast.ingredient!.uuid, yeast.uuid)
        XCTAssertEqual(measuredYeast.amount, 2.5)
        XCTAssertEqual(measuredYeast.unit, .teaspoon)
    }
    
    func testAmountForIngredientWithInvalid() {
        let invalid = MeasuredIngredient()
        invalid.unit = .asNeeded
        
        do {
            let _ = try invalid.amount(for: .gallon)
        } catch MiseEnPlace.Error.asNeededConversion {
            
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        invalid.unit = .cup
        
        do {
            let _ = try invalid.amount(for: .gallon)
        } catch MiseEnPlace.Error.unhandledConversion {
            
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        invalid.ingredient = water
        
        do {
            let _ = try invalid.amount(for: .asNeeded)
        } catch MiseEnPlace.Error.asNeededConversion {
            
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        do {
            let _ = try invalid.amount(for: .gallon)
        } catch MiseEnPlace.Error.measurementAmount(let method) {
            XCTAssertNil(method)
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        invalid.amount = 6.0
        
        do {
            let _ = try invalid.amount(for: .each)
        } catch MiseEnPlace.Error.quantifiableConversion {
            
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
    }
    
    func testAmountForIngredientOneToOne() {
        var amount: Double
        let measuredIngredient = MeasuredIngredient(ingredient: self.water, amount: 1, unit: .gallon)
        
        do {
            amount = try measuredIngredient.amount(for: .gallon)
            XCTAssertEqual(amount, 1.0)
            
            amount = try measuredIngredient.amount(for: .quart)
            XCTAssertEqual(amount, 4.0)
            
            amount = try measuredIngredient.amount(for: .pint)
            XCTAssertEqual(amount, 8.0)
            
            amount = try measuredIngredient.amount(for: .cup)
            XCTAssertEqual(amount, 16.0)
            
            amount = try measuredIngredient.amount(for: .fluidOunce)
            XCTAssertEqual(amount, 128.0)
            
            amount = try measuredIngredient.amount(for: .tablespoon)
            XCTAssertEqual(amount, 256.0)
            
            amount = try measuredIngredient.amount(for: .teaspoon)
            XCTAssertTrue(amount.equals(768.0, precision: 0))
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertTrue(amount.equals(6144.0, precision: 0))
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertTrue(amount.equals(12288.0, precision: 0))
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertEqual(amount, 128.0)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount, 8.0)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertTrue(amount.equals(3785.41, precision: 2))
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertTrue(amount.equals(3.79, precision: 2))
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertTrue(amount.equals(3628.74, precision: 2))
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertTrue(amount.equals(3.63, precision: 2))
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measuredIngredient.amount = 8.0
        measuredIngredient.unit = .pound
        
        do {
            amount = try measuredIngredient.amount(for: .gallon)
            XCTAssertEqual(amount, 1.0)
            
            amount = try measuredIngredient.amount(for: .quart)
            XCTAssertEqual(amount, 4.0)
            
            amount = try measuredIngredient.amount(for: .pint)
            XCTAssertEqual(amount, 8.0)
            
            amount = try measuredIngredient.amount(for: .cup)
            XCTAssertEqual(amount, 16.0)
            
            amount = try measuredIngredient.amount(for: .fluidOunce)
            XCTAssertEqual(amount, 128.0)
            
            amount = try measuredIngredient.amount(for: .tablespoon)
            XCTAssertEqual(amount, 256.0)
            
            amount = try measuredIngredient.amount(for: .teaspoon)
            XCTAssertTrue(amount.equals(768.0, precision: 0))
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertTrue(amount.equals(6144.0, precision: 0))
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertTrue(amount.equals(12288.0, precision: 0))
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertEqual(amount, 128.0)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount, 8.0)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertTrue(amount.equals(3785.41, precision: 2))
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertTrue(amount.equals(3.79, precision: 2))
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertTrue(amount.equals(3628.74, precision: 2))
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertTrue(amount.equals(3.63, precision: 2))
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measuredIngredient.amount = 3.785
        measuredIngredient.unit = .liter
        
        do {
            amount = try measuredIngredient.amount(for: .gallon)
            XCTAssertTrue(amount.equals(1.0, precision: 1))
            
            amount = try measuredIngredient.amount(for: .quart)
            XCTAssertTrue(amount.equals(4.0, precision: 1))
            
            amount = try measuredIngredient.amount(for: .pint)
            XCTAssertTrue(amount.equals(8.0, precision: 1))
            
            amount = try measuredIngredient.amount(for: .cup)
            XCTAssertTrue(amount.equals(16.0, precision: 1))
            
            amount = try measuredIngredient.amount(for: .fluidOunce)
            XCTAssertTrue(amount.equals(128.0, precision: 1))
            
            amount = try measuredIngredient.amount(for: .tablespoon)
            XCTAssertTrue(amount.equals(256.0, precision: 1))
            
            amount = try measuredIngredient.amount(for: .teaspoon)
            XCTAssertTrue(amount.equals(768.0, precision: 1))
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertTrue(amount.equals(6143.33, precision: 1))
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertTrue(amount.equals(12286.66, precision: 1))
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertTrue(amount.equals(133.51, precision: 1))
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertTrue(amount.equals(8.34, precision: 1))
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertTrue(amount.equals(3785.0, precision: 0))
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertTrue(amount.equals(3.785, precision: 0))
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertTrue(amount.equals(3785.0, precision: 0))
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertTrue(amount.equals(3.785, precision: 0))
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measuredIngredient.amount = 3.785
        measuredIngredient.unit = .kilogram
        
        do {
            amount = try measuredIngredient.amount(for: .gallon)
            XCTAssertTrue(amount.equals(1.0, precision: 1))
            
            amount = try measuredIngredient.amount(for: .quart)
            XCTAssertTrue(amount.equals(4.0, precision: 1))
            
            amount = try measuredIngredient.amount(for: .pint)
            XCTAssertTrue(amount.equals(8.0, precision: 1))
            
            amount = try measuredIngredient.amount(for: .cup)
            XCTAssertTrue(amount.equals(16.0, precision: 1))
            
            amount = try measuredIngredient.amount(for: .fluidOunce)
            XCTAssertTrue(amount.equals(128.0, precision: 1))
            
            amount = try measuredIngredient.amount(for: .tablespoon)
            XCTAssertTrue(amount.equals(256.0, precision: 1))
            
            amount = try measuredIngredient.amount(for: .teaspoon)
            XCTAssertTrue(amount.equals(768.0, precision: 1))
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertTrue(amount.equals(6143.33, precision: 1))
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertTrue(amount.equals(12286.66, precision: 1))
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertTrue(amount.equals(133.51, precision: 1))
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertTrue(amount.equals(8.34, precision: 1))
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertTrue(amount.equals(3785.0, precision: 0))
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertTrue(amount.equals(3.785, precision: 0))
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertTrue(amount.equals(3785.0, precision: 0))
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertTrue(amount.equals(3.785, precision: 0))
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
    }
}
