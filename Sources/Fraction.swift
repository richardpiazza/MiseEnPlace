//===----------------------------------------------------------------------===//
//
// Fraction.swift
//
// Copyright (c) 2016 Richard Piazza
// https://github.com/richardpiazza/MiseEnPlace
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//===----------------------------------------------------------------------===//
import Foundation

/// ## Fraction
/// Enumeration of commonly used fractions in cooking.
public enum Fraction: Double {
    case zero = 0.0
    case oneThousandth = 0.001
    case oneSixteenth = 0.0625
    case oneEighth = 0.125
    case oneSixth = 0.166666
    case oneFourth = 0.25
    case oneThird = 0.3333333
    case oneHalf = 0.5
    case fiveEighths = 0.625
    case twoThirds = 0.666666
    case threeFourths = 0.75
    case sevenEights = 0.875
    case one = 1.0
    
    public static let allFractions: [Fraction] = [.zero, .oneThousandth, .oneSixteenth, .oneEighth, .oneSixth, .oneFourth, .oneThird, .oneHalf, .fiveEighths, .twoThirds, .threeFourths, .sevenEights, .one]
    public static let commonFractions: [Fraction] = [.oneEighth, .oneFourth, .oneThird, .oneHalf, .twoThirds, .threeFourths]
    public static let zeroBasedCommonFractions: [Fraction] = [.zero, .oneEighth, .oneFourth, .oneThird, .oneHalf, .twoThirds, .threeFourths]
    public static let symbolFractions: [Fraction] = [.oneEighth, .oneSixth, .oneFourth, .oneThird, .oneHalf, .fiveEighths, .twoThirds, .threeFourths, .sevenEights]
    public static let zeroBasedSymbolFractions: [Fraction] = [.zero, .oneEighth, .oneSixth, .oneFourth, .oneThird, .oneHalf, .fiveEighths, .twoThirds, .threeFourths, .sevenEights]
    
    public init(closestValue value: Double) {
        if let fraction = Fraction(rawValue: value) {
            self = fraction
            return
        }
        
        for fraction in Fraction.allFractions.reversed() {
            if value >= fraction.stepDownThreshold {
                self = fraction
                return
            }
        }
        
        self = .zero
    }
    
    public init?(commonValue value: Double) {
        for fraction in Fraction.zeroBasedCommonFractions {
            if fraction.rawValue == value {
                self = fraction
                return
            }
        }
        
        return nil
    }
    
    public init?(symbolValue value: Double) {
        for fraction in Fraction.zeroBasedSymbolFractions {
            if fraction.rawValue == value {
                self = fraction
                return
            }
        }
        
        return nil
    }
    
    /// The threshold at which the next smallest fraction should be used.
    /// Values greater than 7/8 (0.875) should be considered 1.0 (.one).
    /// Values less than 1/4 (0.25) should be considered 0.0 (.zero).
    public var stepDownThreshold: Double {
        switch self {
        case .zero, .oneThousandth, .oneSixteenth, .oneEighth: return Fraction.oneEighth.rawValue
        case .oneSixth: return Fraction.oneFourth.rawValue //0.14583
        case .oneFourth: return 0.208333
        case .oneThird: return 0.291666
        case .oneHalf: return 0.41666
        case .fiveEighths: return 0.5625
        case .twoThirds: return 0.645833
        case .threeFourths: return 0.708333
        case .sevenEights: return 0.8125
        case .one: return Fraction.sevenEights.rawValue
        }
    }
    
    /// The unicode symbol (or empty string) for known fraction values.
    public var stringValue: String {
        switch self {
        case .oneThousandth: return "\u{215F}1000"
        case .oneSixteenth: return "\u{215F}16"
        case .oneEighth: return "⅛"
        case .oneSixth: return "⅙"
        case .oneFourth: return "¼"
        case .oneThird: return "⅓"
        case .oneHalf: return "½"
        case .fiveEighths: return "⅝"
        case .twoThirds: return "⅔"
        case .threeFourths: return "¾"
        case .sevenEights: return "⅞"
        default: return ""
        }
    }
}
