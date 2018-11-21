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
            XCTAssertEqual(amount.rounded(to: 2), 1.0)
            
            amount = try measuredIngredient.amount(for: .quart)
            XCTAssertEqual(amount.rounded(to: 2), 4.0)
            
            amount = try measuredIngredient.amount(for: .pint)
            XCTAssertEqual(amount.rounded(to: 2), 8.0)
            
            amount = try measuredIngredient.amount(for: .cup)
            XCTAssertEqual(amount.rounded(to: 2), 16.0)
            
            amount = try measuredIngredient.amount(for: .fluidOunce)
            XCTAssertEqual(amount.rounded(to: 2), 128.0)
            
            amount = try measuredIngredient.amount(for: .tablespoon)
            XCTAssertEqual(amount.rounded(to: 2), 256.0)
            
            amount = try measuredIngredient.amount(for: .teaspoon)
            XCTAssertEqual(amount.rounded(to: 2), 768.0)
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertEqual(amount.rounded(to: 2), 6144.0)
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertEqual(amount.rounded(to: 2), 12288.0)
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertEqual(amount.rounded(to: 2), 128.0)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 8.0)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertEqual(amount.rounded(to: 2), 3785.41)
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 2), 3.79)
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertEqual(amount.rounded(to: 2), 3785.41)
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 2), 3.79)
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertEqual(amount.rounded(to: 2), 2.52)
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: .gallon)
            XCTAssertEqual(amount.rounded(to: 2), 1.0)
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measuredIngredient.amount = 8.0
        measuredIngredient.unit = .pound
        
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
            XCTAssertEqual(amount.rounded(to: 2), 128.0)
            
            amount = try measuredIngredient.amount(for: .tablespoon)
            XCTAssertEqual(amount.rounded(to: 2), 256.0)
            
            amount = try measuredIngredient.amount(for: .teaspoon)
            XCTAssertEqual(amount.rounded(to: 0), 768.0)
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertEqual(amount.rounded(to: 0), 6144.0)
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertEqual(amount.rounded(to: 0), 12288.0)
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertEqual(amount.rounded(to: 2), 128.0)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 8.0)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertEqual(amount.rounded(to: 2), 3628.74)
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 2), 3.63)
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertEqual(amount.rounded(to: 2), 3628.74)
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 2), 3.63)
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertEqual(amount.rounded(to: 2), 2.42)
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: .pound)
            // You would expect this amount to be 8.0, but you have to
            // take into account the different calculation path when going
            // back to the .pound unit.
            // To Each: us weight > metric weight > metric volume
            // From Each: metric volume > us volume > us weight
            XCTAssertEqual(amount.rounded(to: 2), 7.67)
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
            XCTAssertEqual(amount.rounded(to: 2), 127.99)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 8.0)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertEqual(amount.rounded(to: 2), 3785.0)
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 3), 3.785)
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertEqual(amount.rounded(to: 2), 3785.0)
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 3), 3.785)
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertEqual(amount.rounded(to: 2), 2.52)
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 3), 3.785)
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measuredIngredient.amount = 3.785
        measuredIngredient.unit = .kilogram
        
        do {
            amount = try measuredIngredient.amount(for: .gallon)
            XCTAssertEqual(amount.rounded(to: 2), 1.04)
            
            amount = try measuredIngredient.amount(for: .quart)
            XCTAssertEqual(amount.rounded(to: 2), 4.17)
            
            amount = try measuredIngredient.amount(for: .pint)
            XCTAssertEqual(amount.rounded(to: 2), 8.34)
            
            amount = try measuredIngredient.amount(for: .cup)
            XCTAssertEqual(amount.rounded(to: 2), 16.69)
            
            amount = try measuredIngredient.amount(for: .fluidOunce)
            XCTAssertEqual(amount.rounded(to: 2), 133.51)
            
            amount = try measuredIngredient.amount(for: .tablespoon)
            XCTAssertEqual(amount.rounded(to: 2), 267.02)
            
            amount = try measuredIngredient.amount(for: .teaspoon)
            XCTAssertEqual(amount.rounded(to: 2), 801.07)
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertEqual(amount.rounded(to: 2), 6408.57)
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertEqual(amount.rounded(to: 2), 12817.15)
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertEqual(amount.rounded(to: 2), 133.51)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 8.34)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertEqual(amount.rounded(to: 2), 3785.0)
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 3), 3.785)
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertEqual(amount.rounded(to: 2), 3785.0)
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 3), 3.785)
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertEqual(amount.rounded(to: 2), 2.52)
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 3), 3.785)
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
            XCTAssertEqual(amount.rounded(to: 2), 1.0)
            
            amount = try measuredIngredient.amount(for: .quart)
            XCTAssertEqual(amount.rounded(to: 2), 4.0)
            
            amount = try measuredIngredient.amount(for: .pint)
            XCTAssertEqual(amount.rounded(to: 2), 8.0)
            
            amount = try measuredIngredient.amount(for: .cup)
            XCTAssertEqual(amount.rounded(to: 2), 16.0)
            
            amount = try measuredIngredient.amount(for: .fluidOunce)
            XCTAssertEqual(amount.rounded(to: 2), 128.0)
            
            amount = try measuredIngredient.amount(for: .tablespoon)
            XCTAssertEqual(amount.rounded(to: 2), 256.0)
            
            amount = try measuredIngredient.amount(for: .teaspoon)
            XCTAssertEqual(amount.rounded(to: 2), 768.0)
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertEqual(amount.rounded(to: 2), 6144.0)
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertEqual(amount.rounded(to: 2), 12288.0)
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertEqual(amount.rounded(to: 2), 153.6)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 9.6)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertEqual(amount.rounded(to: 2), 3785.41)
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 2), 3.79)
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertEqual(amount.rounded(to: 2), 4542.49)
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 2), 4.54)
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertEqual(amount.rounded(to: 2), 0.04) //0.05
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: .gallon)
            // You would expect this amount to be 1.0, but you have to
            // take into account the different calculation path when going
            // back to the .gallon unit.
            // To Each: us volume > metric volume > metric weight
            // From Each: metric weight > us weight > us volume
            XCTAssertEqual(amount.rounded(to: 2), 1.04) //1.5
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
            XCTAssertEqual(amount.rounded(to: 0), 640.0)
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertEqual(amount.rounded(to: 0), 5120.0)
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertEqual(amount.rounded(to: 0), 10240.0)
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertEqual(amount.rounded(to: 2), 128.0)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 8.0)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertEqual(amount.rounded(to: 2), 3023.95)
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 2), 3.02)
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertEqual(amount.rounded(to: 2), 3628.74)
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 2), 3.63)
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertEqual(amount.rounded(to: 2), 0.04)
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 8.0)
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
            XCTAssertEqual(amount.rounded(to: 2), 153.58)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 9.6)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertEqual(amount.rounded(to: 2), 3785.0)
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 3), 3.785)
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertEqual(amount.rounded(to: 2), 4542.0)
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 3), 4.542)
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertEqual(amount.rounded(to: 2), 0.04) //0.05
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 3), 3.785)
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measuredIngredient.amount = 3.785
        measuredIngredient.unit = .kilogram
        
        do {
            amount = try measuredIngredient.amount(for: .gallon)
            XCTAssertEqual(amount.rounded(to: 2), 0.87)
            
            amount = try measuredIngredient.amount(for: .quart)
            XCTAssertEqual(amount.rounded(to: 2), 3.48)
            
            amount = try measuredIngredient.amount(for: .pint)
            XCTAssertEqual(amount.rounded(to: 2), 6.95)
            
            amount = try measuredIngredient.amount(for: .cup)
            XCTAssertEqual(amount.rounded(to: 2), 13.91)
            
            amount = try measuredIngredient.amount(for: .fluidOunce)
            XCTAssertEqual(amount.rounded(to: 2), 111.26)
            
            amount = try measuredIngredient.amount(for: .tablespoon)
            XCTAssertEqual(amount.rounded(to: 2), 222.52)
            
            amount = try measuredIngredient.amount(for: .teaspoon)
            XCTAssertEqual(amount.rounded(to: 2), 667.56)
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertEqual(amount.rounded(to: 2), 5340.48)
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertEqual(amount.rounded(to: 2), 10680.96)
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertEqual(amount.rounded(to: 2), 133.51)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 8.34)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertEqual(amount.rounded(to: 2), 3154.17)
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 3), 3.154)
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertEqual(amount.rounded(to: 2), 3785.0)
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 3), 3.785)
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertEqual(amount.rounded(to: 2), 0.04)
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 3), 3.785)
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
            XCTAssertEqual(amount.rounded(to: 2), 1.0)
            
            amount = try measuredIngredient.amount(for: .quart)
            XCTAssertEqual(amount.rounded(to: 2), 4.0)
            
            amount = try measuredIngredient.amount(for: .pint)
            XCTAssertEqual(amount.rounded(to: 2), 8.0)
            
            amount = try measuredIngredient.amount(for: .cup)
            XCTAssertEqual(amount.rounded(to: 2), 16.0)
            
            amount = try measuredIngredient.amount(for: .fluidOunce)
            XCTAssertEqual(amount.rounded(to: 2), 128.0)
            
            amount = try measuredIngredient.amount(for: .tablespoon)
            XCTAssertEqual(amount.rounded(to: 2), 256.0)
            
            amount = try measuredIngredient.amount(for: .teaspoon)
            XCTAssertEqual(amount.rounded(to: 2), 768.0)
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertEqual(amount.rounded(to: 2), 6144.0)
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertEqual(amount.rounded(to: 2), 12288.0)
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertEqual(amount.rounded(to: 2), 102.4)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 6.4)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertEqual(amount.rounded(to: 2), 3785.41)
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 2), 3.79)
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertEqual(amount.rounded(to: 2), 3028.33)
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 2), 3.03)
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertEqual(amount.rounded(to: 2), 540.77) //432.62
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: .gallon)
            // You would expect this amount to be 1.0, but you have to
            // take into account the different calculation path when going
            // back to the .gallon unit.
            // To Each: us volume > metric volume > metric weight
            // From Each: metric weight > us weight > us volume
            XCTAssertEqual(amount.rounded(to: 2), 1.04) //0.67
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
            XCTAssertEqual(amount.rounded(to: 0), 960.0)
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertEqual(amount.rounded(to: 0), 7680.0)
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertEqual(amount.rounded(to: 0), 15360.0)
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertEqual(amount.rounded(to: 2), 128.0)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 8.0)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertEqual(amount.rounded(to: 2), 4535.92)
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 2), 4.54)
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertEqual(amount.rounded(to: 2), 3628.74)
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 2), 3.63)
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertEqual(amount.rounded(to: 2), 518.39)
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 8.0)
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
            XCTAssertEqual(amount.rounded(to: 2), 102.39)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 6.4)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertEqual(amount.rounded(to: 2), 3785.0)
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 3), 3.785)
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertEqual(amount.rounded(to: 2), 3028.0)
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 3), 3.028)
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertEqual(amount.rounded(to: 2), 540.71) //432.57
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 3), 3.785)
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
        
        measuredIngredient.amount = 3.785
        measuredIngredient.unit = .kilogram
        
        do {
            amount = try measuredIngredient.amount(for: .gallon)
            XCTAssertEqual(amount.rounded(to: 2), 1.3)
            
            amount = try measuredIngredient.amount(for: .quart)
            XCTAssertEqual(amount.rounded(to: 2), 5.22)
            
            amount = try measuredIngredient.amount(for: .pint)
            XCTAssertEqual(amount.rounded(to: 2), 10.43)
            
            amount = try measuredIngredient.amount(for: .cup)
            XCTAssertEqual(amount.rounded(to: 2), 20.86)
            
            amount = try measuredIngredient.amount(for: .fluidOunce)
            XCTAssertEqual(amount.rounded(to: 2), 166.89)
            
            amount = try measuredIngredient.amount(for: .tablespoon)
            XCTAssertEqual(amount.rounded(to: 2), 333.78)
            
            amount = try measuredIngredient.amount(for: .teaspoon)
            XCTAssertEqual(amount.rounded(to: 2), 1001.34)
            
            amount = try measuredIngredient.amount(for: .dash)
            XCTAssertEqual(amount.rounded(to: 2), 8010.72)
            
            amount = try measuredIngredient.amount(for: .pinch)
            XCTAssertEqual(amount.rounded(to: 2), 16021.44)
            
            amount = try measuredIngredient.amount(for: .ounce)
            XCTAssertEqual(amount.rounded(to: 2), 133.51)
            
            amount = try measuredIngredient.amount(for: .pound)
            XCTAssertEqual(amount.rounded(to: 2), 8.34)
            
            amount = try measuredIngredient.amount(for: .milliliter)
            XCTAssertEqual(amount.rounded(to: 2), 4731.25)
            
            amount = try measuredIngredient.amount(for: .liter)
            XCTAssertEqual(amount.rounded(to: 3), 4.731)
            
            amount = try measuredIngredient.amount(for: .gram)
            XCTAssertEqual(amount.rounded(to: 2), 3785.0)
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 3), 3.785)
            
            amount = try measuredIngredient.amount(for: .each)
            XCTAssertEqual(amount.rounded(to: 2), 540.71)
            
            measuredIngredient.amount = amount
            measuredIngredient.unit = .each
            
            amount = try measuredIngredient.amount(for: .kilogram)
            XCTAssertEqual(amount.rounded(to: 3), 3.785)
        } catch {
            XCTFail("Unexpected Error Thrown")
            return
        }
    }
}
