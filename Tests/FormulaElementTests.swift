import XCTest
@testable import MiseEnPlace

class FormulaElementTests: XCTestCase {

    var water = _SharedModels.water
    let flour = _SharedModels.flour
    var salt = _SharedModels.salt
    let yeast = _SharedModels.yeast
    
    lazy var measuredWater = MeasuredIngredient(ingredient: self.water, amount: 250.0, unit: .milliliter)
    lazy var measuredFlour = MeasuredIngredient(ingredient: self.flour, amount: 14.0, unit: .ounce)
    lazy var measuredSalt = MeasuredIngredient(ingredient: self.salt, amount: 4.0, unit: .gram)
    lazy var measuredYeast = MeasuredIngredient(ingredient: self.yeast, amount: 2.5, unit: .teaspoon)
    
    override func setUp() {
        super.setUp()
        
        XCTAssertEqual(water.name, "Water")
        XCTAssertEqual(water.volume, 1.0)
        XCTAssertEqual(water.weight, 1.0)
        water.amount = 1.5
        water.unit = .liter
        
        XCTAssertEqual(flour.name, "Bread Flour")
        XCTAssertEqual(flour.volume, 1.88)
        XCTAssertEqual(flour.weight, 1.0)
        
        XCTAssertEqual(salt.name, "Salt")
        XCTAssertEqual(salt.volume, 1.0)
        XCTAssertEqual(salt.weight, 1.2)
        salt.amount = 87.6
        salt.unit = .kilogram
        
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
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertTrue(amount.equals(2.52, precision: 1))
            
            let ma = measuredIngredient.amount
            let mu = measuredIngredient.unit
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: mu)
            XCTAssertEqual(amount.rounded(to: 2), ma.rounded(to: 2))
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
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertTrue(amount.equals(2.52, precision: 1))
            
            let ma = measuredIngredient.amount
            let mu = measuredIngredient.unit
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: mu)
            XCTAssertEqual(amount.rounded(to: 2), ma.rounded(to: 2))
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
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertTrue(amount.equals(2.52, precision: 1))
            
            let ma = measuredIngredient.amount
            let mu = measuredIngredient.unit
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: mu)
            XCTAssertEqual(amount.rounded(to: 2), ma.rounded(to: 2))
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
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertTrue(amount.equals(2.52, precision: 1))
            
            let ma = measuredIngredient.amount
            let mu = measuredIngredient.unit
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: mu)
            XCTAssertEqual(amount.rounded(to: 2), ma.rounded(to: 2))
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
    }
    
    func testAmountForIngredientHighWeight() {
        var amount: Double
        let measuredIngredient = MeasuredIngredient(ingredient: self.salt, amount: 1, unit: .gallon)
        
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
            XCTAssertEqual(amount, 153.6)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount, 9.6)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertTrue(amount.equals(3785.41, precision: 2))
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertTrue(amount.equals(3.79, precision: 2))
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertTrue(amount.equals(4354.48, precision: 2))
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertTrue(amount.equals(4.35, precision: 2))
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertTrue(amount.equals(0.049, precision: 1))
            
            let ma = measuredIngredient.amount
            let mu = measuredIngredient.unit
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: mu)
            XCTAssertEqual(amount.rounded(to: 2), ma.rounded(to: 2))
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measuredIngredient.amount = 8.0
        measuredIngredient.unit = .pound
        
        do {
            amount = try measuredIngredient.amount(for: .gallon)
            XCTAssertEqual(amount.rounded(to: 2), 0.83)
            
            amount = try measuredIngredient.amount(for: .quart)
            XCTAssertEqual(amount.rounded(to: 2), 3.33)
            
            amount = try measuredIngredient.amount(for: .pint)
            XCTAssertEqual(amount.rounded(to: 2), 6.67)
            
            amount = try measuredIngredient.amount(for: .cup)
            XCTAssertEqual(amount.rounded(to: 2), 13.33)
            
            amount = try measuredIngredient.amount(for: .fluidOunce)
            XCTAssertEqual(amount.rounded(to: 2), 106.67)
            
            amount = try measuredIngredient.amount(for: .tablespoon)
            XCTAssertEqual(amount.rounded(to: 2), 213.33)
            
            amount = try measuredIngredient.amount(for: .teaspoon)
            XCTAssertEqual(amount.rounded(to: 2), 640.0)
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertEqual(amount.rounded(to: 2), 5120.0)
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertEqual(amount.rounded(to: 2), 10240.0)
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertEqual(amount.rounded(to: 2), 128.0)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 8.0)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertEqual(amount.rounded(to: 2), 3154.51)
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 2), 3.15)
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertTrue(amount.equals(3628.74, precision: 2))
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertTrue(amount.equals(3.63, precision: 2))
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertTrue(amount.equals(0.04, precision: 1))
            
            let ma = measuredIngredient.amount
            let mu = measuredIngredient.unit
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: mu)
            XCTAssertEqual(amount.rounded(to: 2), ma.rounded(to: 2))
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
            XCTAssertTrue(amount.equals(160.21, precision: 1))
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertTrue(amount.equals(10.01, precision: 1))
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertTrue(amount.equals(3785.0, precision: 0))
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertTrue(amount.equals(3.785, precision: 0))
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertTrue(amount.equals(4542.0, precision: 0))
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertTrue(amount.equals(4.54, precision: 0))
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertEqual(amount.rounded(to: 3), 0.052)
            
            let ma = measuredIngredient.amount
            let mu = measuredIngredient.unit
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: mu)
            XCTAssertEqual(amount.rounded(to: 2), ma.rounded(to: 2))
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measuredIngredient.amount = 3.785
        measuredIngredient.unit = .kilogram
        
        do {
            amount = try measuredIngredient.amount(for: .gallon)
            XCTAssertEqual(amount.rounded(to: 2), 0.83)
            
            amount = try measuredIngredient.amount(for: .quart)
            XCTAssertEqual(amount.rounded(to: 2), 3.33)
            
            amount = try measuredIngredient.amount(for: .pint)
            XCTAssertEqual(amount.rounded(to: 2), 6.67)
            
            amount = try measuredIngredient.amount(for: .cup)
            XCTAssertEqual(amount.rounded(to: 2), 13.33)
            
            amount = try measuredIngredient.amount(for: .fluidOunce)
            XCTAssertEqual(amount.rounded(to: 2), 106.66)
            
            amount = try measuredIngredient.amount(for: .tablespoon)
            XCTAssertEqual(amount.rounded(to: 2), 213.31)
            
            amount = try measuredIngredient.amount(for: .teaspoon)
            XCTAssertEqual(amount.rounded(to: 2), 639.93)
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertEqual(amount.rounded(to: 2), 5119.44)
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertEqual(amount.rounded(to: 2), 10238.89)
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertEqual(amount.rounded(to: 2), 133.51)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 8.34)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertEqual(amount.rounded(to: 2), 3154.17)
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 2), 3.15)
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertTrue(amount.equals(3785.0, precision: 0))
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertTrue(amount.equals(3.785, precision: 0))
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertTrue(amount.equals(0.043, precision: 1))
            
            let ma = measuredIngredient.amount
            let mu = measuredIngredient.unit
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: mu)
            XCTAssertEqual(amount.rounded(to: 2), ma.rounded(to: 2))
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
    }
    
    func testAmountForIngredientHighVolume() {
        var amount: Double
        let measuredIngredient = MeasuredIngredient(ingredient: self.yeast, amount: 1, unit: .gallon)
        
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
            XCTAssertEqual(amount, 102.4)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount, 6.4)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertTrue(amount.equals(3785.41, precision: 2))
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertTrue(amount.equals(3.79, precision: 2))
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertTrue(amount.equals(2902.99, precision: 2))
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertTrue(amount.equals(2.90, precision: 2))
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertTrue(amount.equals(414.71, precision: 1))
            
            let ma = measuredIngredient.amount
            let mu = measuredIngredient.unit
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: mu)
            XCTAssertEqual(amount.rounded(to: 2), ma.rounded(to: 2))
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measuredIngredient.amount = 8.0
        measuredIngredient.unit = .pound
        
        do {
            amount = try measuredIngredient.amount(for: .gallon)
            XCTAssertEqual(amount.rounded(to: 2), 1.25)
            
            amount = try measuredIngredient.amount(for: .quart)
            XCTAssertEqual(amount.rounded(to: 2), 5.0)
            
            amount = try measuredIngredient.amount(for: .pint)
            XCTAssertEqual(amount.rounded(to: 2), 10.0)
            
            amount = try measuredIngredient.amount(for: .cup)
            XCTAssertEqual(amount.rounded(to: 2), 20.0)
            
            amount = try measuredIngredient.amount(for: .fluidOunce)
            XCTAssertEqual(amount.rounded(to: 2), 160.0)
            
            amount = try measuredIngredient.amount(for: .tablespoon)
            XCTAssertEqual(amount.rounded(to: 2), 320.0)
            
            amount = try measuredIngredient.amount(for: .teaspoon)
            XCTAssertEqual(amount.rounded(to: 2), 960.0)
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertEqual(amount.rounded(to: 2), 7680.0)
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertEqual(amount.rounded(to: 2), 15360.0)
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertEqual(amount.rounded(to: 2), 128.0)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 8.0)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertEqual(amount.rounded(to: 2), 4731.76)
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 2), 4.73)
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertEqual(amount.rounded(to: 2), 3628.74)
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 2), 3.63)
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertEqual(amount.rounded(to: 2), 518.39)
            
            let ma = measuredIngredient.amount
            let mu = measuredIngredient.unit
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: mu)
            XCTAssertEqual(amount.rounded(to: 2), ma.rounded(to: 2))
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measuredIngredient.amount = 3.785
        measuredIngredient.unit = .liter
        
        do {
            amount = try measuredIngredient.amount(for: .gallon)
            XCTAssertEqual(amount.rounded(to: 2), 1.0)
            
            amount = try measuredIngredient.amount(for: .quart)
            XCTAssertEqual(amount.rounded(to: 2), 4.0)
            
            amount = try measuredIngredient.amount(for: .pint)
            XCTAssertEqual(amount.rounded(to: 2), 8.0)
            
            amount = try measuredIngredient.amount(for: .cup)
            XCTAssertEqual(amount.rounded(to: 2), 16.0)
            
            amount = try measuredIngredient.amount(for: .fluidOunce)
            XCTAssertEqual(amount.rounded(to: 2), 127.99)
            
            amount = try measuredIngredient.amount(for: .tablespoon)
            XCTAssertEqual(amount.rounded(to: 2), 255.97)
            
            amount = try measuredIngredient.amount(for: .teaspoon)
            XCTAssertEqual(amount.rounded(to: 2), 767.92)
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertEqual(amount.rounded(to: 2), 6143.33)
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertEqual(amount.rounded(to: 2), 12286.66)
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertEqual(amount.rounded(to: 2), 106.81)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 6.68)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertEqual(amount.rounded(to: 2), 3785.0)
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 2), 3.79)
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertEqual(amount.rounded(to: 2), 3028.0)
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 2), 3.03)
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertEqual(amount.rounded(to: 2), 432.57)
            
            let ma = measuredIngredient.amount
            let mu = measuredIngredient.unit
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: mu)
            XCTAssertEqual(amount.rounded(to: 2), ma.rounded(to: 2))
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measuredIngredient.amount = 3.785
        measuredIngredient.unit = .kilogram
        
        do {
            amount = try measuredIngredient.amount(for: .gallon)
            XCTAssertEqual(amount.rounded(to: 2), 1.25)
            
            amount = try measuredIngredient.amount(for: .quart)
            XCTAssertEqual(amount.rounded(to: 2), 5.0)
            
            amount = try measuredIngredient.amount(for: .pint)
            XCTAssertEqual(amount.rounded(to: 2), 10.0)
            
            amount = try measuredIngredient.amount(for: .cup)
            XCTAssertEqual(amount.rounded(to: 2), 20.0)
            
            amount = try measuredIngredient.amount(for: .fluidOunce)
            XCTAssertEqual(amount.rounded(to: 2), 159.98)
            
            amount = try measuredIngredient.amount(for: .tablespoon)
            XCTAssertEqual(amount.rounded(to: 2), 319.97)
            
            amount = try measuredIngredient.amount(for: .teaspoon)
            XCTAssertEqual(amount.rounded(to: 2), 959.9)
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertEqual(amount.rounded(to: 2), 7679.17)
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertEqual(amount.rounded(to: 2), 15358.33)
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertEqual(amount.rounded(to: 2), 133.51)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 8.34)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertEqual(amount.rounded(to: 2), 4731.25)
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 2), 4.73)
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertEqual(amount.rounded(to: 2), 3785.0)
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 2), 3.79)
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertEqual(amount.rounded(to: 2), 540.71)
            
            let ma = measuredIngredient.amount
            let mu = measuredIngredient.unit
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: mu)
            XCTAssertEqual(amount.rounded(to: 2), ma.rounded(to: 2))
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
    }
}
