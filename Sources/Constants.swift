//===----------------------------------------------------------------------===//
//
// Constants.swift
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

public struct Constants {
    public static let LooseOunceGramRatio: Float = 30.0
    public static let PreciseOunceGramRatio: Float = 28.349523
    public static let LooseFluidOunceMilliliterRatio: Float = 30.0
    public static let PreciseFluidOunceMilliliterRatio: Float = 29.573529
    
    public static let SevenEighths: Float = 0.875
    public static let SevenEighthsSymbol: String = "⅞"
    
    public static let ThreeFourths: Float = 0.75
    public static let ThreeFourthsDecimalBoundary: Float = 0.708333
    public static let ThreeFourthsSymbol: String = "¾"
    
    public static let TwoThirds: Float = 0.666666
    public static let TwoThirdsDecimalBoundary: Float = 0.645833
    public static let TwoThirdsSymbol: String = "⅔"
    
    public static let FiveEighths: Float = 0.625
    public static let FiveEighthsDecimalBoundary: Float = 0.5625
    public static let FiveEighthsSymbol: String = "⅝"
    
    public static let OneHalf: Float = 0.5
    public static let OneHalfDecimalBoundary: Float = 0.416666
    public static let OneHalfSymbol: String = "½"
    
    public static let OneThird: Float = 0.3333333
    public static let OneThirdDecimalBoundary: Float = 0.291666
    public static let OneThirdSymbol: String = "⅓"
    
    public static let OneFourth: Float = 0.25
    public static let OneFourthDecimalBoundary: Float = 0.208333
    public static let OneFourthSymbol: String = "¼"
    
    public static let OneSixth: Float = 0.166666
    public static let OneSixthSymbol: String = "⅙"
    
    public static let OneEighth: Float = 0.125
    public static let OneEighthSymbol: String = "⅛"
    
    public static let OneSixteenth: Float = 0.0625
    public static let OneThousandth: Float = 0.001
}
