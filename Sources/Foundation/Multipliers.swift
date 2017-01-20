//===----------------------------------------------------------------------===//
//
// Multipliers.swift
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

public struct Multipliers {
    /// Replaces precise oz->g / floz->ml conversions with 30g/30ml respectively.
    public static var useLooseConversions: Bool = false
    
    public static let looseOunceGram: Double = 30.0
    public static let preciseOunceGram: Double = 28.349523
    public static let looseFluidOunceMilliliter: Double = 30.0
    public static let preciseFluidOunceMilliliter: Double = 29.573529
    
    public static var fluidOunceMilliliter: Double {
        return (useLooseConversions) ? looseFluidOunceMilliliter : preciseFluidOunceMilliliter
    }
    
    public static var ounceGram: Double {
        return (useLooseConversions) ? looseOunceGram : preciseOunceGram
    }
}