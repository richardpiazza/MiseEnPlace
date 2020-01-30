import Foundation
import XCTest
@testable import MiseEnPlace

class DoubleTests: XCTestCase {
    
    static var allTests = [
        ("testRounded", testRounded),
        ("testFractionedString", testFractionedString),
    ]
    
    func testRounded() {
        XCTAssertEqual(10.5678.rounded(to: 0), 11.0)
        XCTAssertEqual(10.5678.rounded(to: 1), 10.6)
        XCTAssertEqual(10.5678.rounded(to: 2), 10.57)
        XCTAssertEqual(10.5678.rounded(to: 3), 10.568)
    }
    
    func testFractionedString() {
        var value: Double = 0.0
        
        value = Double.nan
        XCTAssertEqual(value.fractionedString, "0")
        
        value = 10.0
        XCTAssertEqual(value.fractionedString, "10")
        
        value = 10.001
        XCTAssertEqual(value.fractionedString, "10")
        
        value = 10.0625
        XCTAssertEqual(value.fractionedString, "10\u{215F}16")
        
        value = 10.125
        XCTAssertEqual(value.fractionedString, "10⅛")
        
        value = 10.167
        XCTAssertEqual(value.fractionedString, "10⅙")
        
        value = 10.25
        XCTAssertEqual(value.fractionedString, "10¼")
        
        value = 10.333
        XCTAssertEqual(value.fractionedString, "10⅓")
        
        value = 10.5
        XCTAssertEqual(value.fractionedString, "10½")
        
        value = 10.625
        XCTAssertEqual(value.fractionedString, "10⅝")
        
        value = 10.666
        XCTAssertEqual(value.fractionedString, "10⅔")
        
        value = 10.75
        XCTAssertEqual(value.fractionedString, "10¾")
        
        value = 10.875
        XCTAssertEqual(value.fractionedString, "10⅞")
        
        value = 10.9
        XCTAssertEqual(value.fractionedString, "11")
        
        value = 0.875
        XCTAssertEqual(value.fractionedString, "⅞")
    }
}
