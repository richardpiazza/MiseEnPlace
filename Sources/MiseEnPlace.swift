//===----------------------------------------------------------------------===//
//
// MiseEnPlace.swift
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

public struct MiseEnPlace {
    
    /// Changes the default behavior of the `Measurement` translation functions.
    public static var abbreviateTranslations: Bool = false
    
    /// Replaces precise oz->g / floz->ml conversions with 30g/30ml respectively.
    public static var useLooseConversions: Bool = false
    
    public struct Multipliers {
        public static let looseOunceGram: Float = 30.0
        public static let preciseOunceGram: Float = 28.349523
        public static let looseFluidOunceMilliliter: Float = 30.0
        public static let preciseFluidOunceMilliliter: Float = 29.573529
        
        public static var fluidOunceMilliliter: Float {
            return (MiseEnPlace.useLooseConversions) ? looseFluidOunceMilliliter : preciseFluidOunceMilliliter
        }
        
        public static var ounceGram: Float {
            return (MiseEnPlace.useLooseConversions) ? looseOunceGram : preciseOunceGram
        }
    }
    
    public struct Fractions {
        public static let sevenEighths: Float = 0.875
        public static let sevenEighthsSymbol = "⅞"
        
        public static let threeFourths: Float = 0.75
        public static let threeFourthsDecimalBoundary: Float = 0.708333
        public static let threeFourthsSymbol = "¾"
        
        public static let twoThirds: Float = 0.666666
        public static let twoThirdsDecimalBoundary: Float = 0.645833
        public static let twoThirdsSymbol = "⅔"
        
        public static let fiveEighths: Float = 0.625
        public static let fiveEighthsDecimalBoundary: Float = 0.5625
        public static let fiveEighthsSymbol = "⅝"
        
        public static let oneHalf: Float = 0.5
        public static let oneHalfDecimalBoundary: Float = 0.416666
        public static let oneHalfSymbol = "½"
        
        public static let oneThird: Float = 0.3333333
        public static let oneThirdDecimalBoundary: Float = 0.291666
        public static let oneThirdSymbol = "⅓"
        
        public static let oneFourth: Float = 0.25
        public static let oneFourthDecimalBoundary: Float = 0.208333
        public static let oneFourthSymbol = "¼"
        
        public static let oneSixth: Float = 0.166666
        public static let oneSixthSymbol = "⅙"
        
        public static let oneEighth: Float = 0.125
        public static let oneEighthSymbol = "⅛"
        
        public static let oneSixteenth: Float = 0.0625
        
        public static let oneThousandth: Float = 0.001
    }
    
}
