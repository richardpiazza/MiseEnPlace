//===----------------------------------------------------------------------===//
//
// Integral.swift
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

/// ## Integral
/// Enumeration of commonly used intergrals in cooking.
public enum Integral: Int {
    case zero = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    case eleven = 11
    case twelve = 12
    case thirteen = 13
    case fourteen = 14
    case fifteen = 15
    case twenty = 20
    case twentyFive = 25
    case thirty = 30
    case thirtyFive = 35
    case fourty = 40
    case fourtyFive = 45
    case fifty = 50
    case sixty = 60
    case seventy = 70
    case eighty = 80
    case ninety = 90
    case oneHundred = 100
    case oneTwentyFive = 125
    case oneFifty = 150
    case oneSeventyFive = 175
    case twoHundred = 200
    case twoFifty = 250
    case threeHundred = 300
    case fourHundred = 400
    case fiveHundred = 500
    case sixHundred = 600
    case sevenHundred = 700
    case sevenFifty = 750
    case eightHundred = 800
    case nineHundred = 900
    
    public static let allIntegrals: [Integral] = [.zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine,
                                                    .ten, .eleven, .twelve, .thirteen, .fourteen, .fifteen,
                                                    .twenty, .twentyFive, .thirty, .thirtyFive, .fourty, .fourtyFive, .fifty,
                                                    .sixty, .seventy, .eighty, .ninety, .oneHundred,
                                                    .oneTwentyFive, .oneFifty, .oneSeventyFive, .twoHundred, .twoFifty,
                                                    .threeHundred, .fourHundred, .fiveHundred, .sixHundred, .sevenHundred, .sevenFifty,
                                                    .eightHundred, .nineHundred]
    public static let singleDigitIntegrals: [Integral] = [.zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine]
    
    public var stringValue: String {
        return "\(self.rawValue)"
    }
}
