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
    
    func testAmountForIngredient() {
        
    }
}
