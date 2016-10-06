//===----------------------------------------------------------------------===//
//
// Double.swift
//
// Copyright (c) 2015 Richard Piazza
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

public extension Double {
    
    public func equals(_ value: Double, precision: Int) -> Bool {
        if self == value {
            return true
        }
        
        switch (precision) {
        case 0: return Int(self) == Int(value)
        case 1: return fabs(self - value) < 0.1
        case 2: return fabs(self - value) < 0.01
        case 3: return fabs(self - value) < 0.001
        case 4: return fabs(self - value) < 0.0001
        case 5: return fabs(self - value) < 0.00001
        case 6: return fabs(self - value) < 0.000001
        default: return false
        }
    }
    
    /// Rounds to the nearest known fraction value.
    /// Values greater than 7/8 (0.875) rounds to 1.0.
    /// Value less than 1/4 (0.25) rounds to 0.0.
    ///
    /// Smaller fractional values are not relevent to MiseEnPlace.
    public var nearestKnownFraction: Double {
        if self >= Fractions.sevenEighths {
            return 1.0
        } else if self >= Fractions.threeFourthsDecimalBoundary {
            return Fractions.threeFourths
        } else if self >= Fractions.twoThirdsDecimalBoundary {
            return Fractions.twoThirds
        } else if self >= Fractions.fiveEighthsDecimalBoundary {
            return Fractions.fiveEighths
        } else if self >= Fractions.oneHalfDecimalBoundary {
            return Fractions.oneHalf
        } else if self >= Fractions.oneThirdDecimalBoundary {
            return Fractions.oneThird
        } else if self >= Fractions.oneFourthDecimalBoundary {
            return Fractions.oneFourth
        }
        
        return 0.0
    }
    
    
    /// Returns the unicode symbol (or empty string) for known fraction values.
    public var fractionSymbol: String {
        if self == Fractions.sevenEighths || self.equals(Fractions.sevenEighths, precision: 2) {
            return Fractions.sevenEighthsSymbol
        } else if self == Fractions.threeFourths || self.equals(Fractions.threeFourths, precision: 2) {
            return Fractions.threeFourthsSymbol
        } else if self == Fractions.twoThirds || self.equals(Fractions.twoThirds, precision: 2) {
            return Fractions.twoThirdsSymbol
        } else if self == Fractions.fiveEighths || self.equals(Fractions.fiveEighths, precision: 2) {
            return Fractions.fiveEighthsSymbol
        } else if self == Fractions.oneHalf || self.equals(Fractions.oneHalf, precision: 2) {
            return Fractions.oneHalfSymbol
        } else if self == Fractions.oneThird || self.equals(Fractions.oneThird, precision: 2) {
            return Fractions.oneThirdSymbol
        } else if self == Fractions.oneFourth || self.equals(Fractions.oneFourth, precision: 2) {
            return Fractions.oneFourthSymbol
        }
        
        return ""
    }
    
    /// Converts an amount from one `MeasurementUnit` to another `MeasurementUnit`
    /// within the same `MeasurementSystemMethod`
    public func convert(from fromUnit: MeasurementUnit, to toUnit: MeasurementUnit) -> Double {
        guard let _ = fromUnit.measurementSystemMethod else {
            return 0.0
        }
        
        guard let toSystemMethod = toUnit.measurementSystemMethod else {
            return 0.0
        }
        
        let measurementUnits = MeasurementUnit.measurementUnits(forMeasurementSystemMethod: toSystemMethod)
        guard measurementUnits.contains(fromUnit) else {
            return 0.0
        }
        
        var currentIndex = -1
        var goalIndex = -1
        
        for (index, unit) in measurementUnits.enumerated() {
            if unit == fromUnit {
                currentIndex = index
            }
            if unit == toUnit {
                goalIndex = index
            }
        }
        
        guard currentIndex != goalIndex else {
            return self
        }
        
        var stepDirection = 0
        var nextValue = self
        
        if goalIndex - currentIndex > 0 {
            stepDirection = 1
            nextValue = self * fromUnit.stepUpMultiplier
        } else {
            stepDirection = -1
            nextValue = self / fromUnit.stepDownMultiplier
        }
        
        let nextIndex = currentIndex + stepDirection
        let nextUnit = measurementUnits[nextIndex]
        
        return nextValue.convert(from: nextUnit, to: toUnit)
    }
}
