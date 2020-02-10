import Foundation
import XCTest
@testable import MiseEnPlace

class RecipeTests: XCTestCase {
    
    static var allTests = [
        ("testTotalAmount", testTotalAmount),
        ("testYield", testYield),
        ("testPortion", testPortion),
        ("testTranslatedFormula", testTranslatedFormula),
    ]
    
    private let italianBread = TestRecipe.italianBread
    private let poolishBaguette = TestRecipe.poolishBaguette
    
    func testTotalAmount() {
        XCTAssertEqual(italianBread.totalAmount(for: .gram), 2811.0, accuracy: 0.1)
        XCTAssertEqual(italianBread.totalAmount(for: .ounce), 99.2, accuracy: 0.1)
        
        XCTAssertEqual(poolishBaguette.totalAmount(for: .gram), 996.49, accuracy: 0.01)
        XCTAssertEqual(poolishBaguette.totalAmount(for: .ounce), 35.15, accuracy: 0.01)
    }
    
    func testYield() throws {
        XCTAssertEqual(italianBread.yield, 4.0, accuracy: 0.1)
        XCTAssertEqual(italianBread.yieldString, "4 portions")
        XCTAssertEqual(italianBread.yieldTranslation, "2810 Gram, 4 portions")
        XCTAssertEqual(italianBread.yieldTranslationNormalized, "2 Kilogram 810 Gram, 4 portions")
        
        XCTAssertEqual(poolishBaguette.yield, 2, accuracy: 0.1)
        XCTAssertEqual(poolishBaguette.yieldString, "2 portions")
        XCTAssertEqual(poolishBaguette.yieldTranslation, "35⅙ Ounce, 2 portions")
        XCTAssertEqual(poolishBaguette.yieldTranslationNormalized, "2 Pound 3⅙ Ounce, 2 portions")
    }
    
    func testPortion() {
        XCTAssertEqual(italianBread.portion.amount, 702.5)
        XCTAssertEqual(italianBread.portion.unit, .gram)
        
        XCTAssertEqual(poolishBaguette.portion.amount, 17.5)
        XCTAssertEqual(poolishBaguette.portion.unit, .ounce)
    }
    
    func testTranslatedFormula() throws {
        let formula = try poolishBaguette.scale(by: 1.875, measurementSystem: .metric, measurementMethod: .weight)
        XCTAssertEqual(formula.count, 5)
        
        // Debug
        formula.forEach({
            let name = $0.ingredient?.name ?? $0.recipe?.name ?? ""
            let grams: Double
            do {
                grams = try $0.amount(for: .gram)
            } catch {
                print(error)
                grams = 0.0
            }
            let ounces: Double
            do {
                ounces = try $0.amount(for: .ounce)
            } catch {
                print(error)
                ounces = 0.0
            }
            let g = Quantification(amount: grams, unit: .gram).componentsTranslation
            let oz = Quantification(amount: ounces, unit: .ounce).componentsTranslation
            print("\(name)")
            print("\t\(g) (\(grams)g)")
            print("\t\(oz) (\(ounces)oz)")
        })
        
        let poolish = formula[0]
        XCTAssertEqual(poolish.recipe?.id, TestRecipe.poolish.id)
        XCTAssertEqual(poolish.quantification.amount, 370.0, accuracy: 5)
        XCTAssertEqual(poolish.quantification.unit, .gram)
        
        let flour = formula[1]
        XCTAssertEqual(flour.ingredient?.id, TestIngredient.flour.id)
        XCTAssertEqual(flour.quantification.amount, 895.0, accuracy: 10)
        XCTAssertEqual(flour.quantification.unit, .gram)
        
        let yeast = formula[2]
        XCTAssertEqual(yeast.ingredient?.id, TestIngredient.yeast.id)
        XCTAssertEqual(yeast.quantification.amount, 42.0, accuracy: 1)
        XCTAssertEqual(yeast.quantification.unit, .gram)
        
        let water = formula[3]
        XCTAssertEqual(water.ingredient?.id, TestIngredient.water.id)
        XCTAssertEqual(water.quantification.amount, 525.0, accuracy: 10)
        XCTAssertEqual(water.quantification.unit, .gram)
        
        let salt = formula[4]
        XCTAssertEqual(salt.ingredient?.id, TestIngredient.salt.id)
        XCTAssertEqual(salt.quantification.amount, 18.0, accuracy: 1)
        XCTAssertEqual(salt.quantification.unit, .gram)
    }
}
