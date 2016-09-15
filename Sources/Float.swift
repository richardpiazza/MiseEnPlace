//===----------------------------------------------------------------------===//
//
// Float.swift
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

internal extension Float {
    internal var integerValue: Int {
        return Int(roundf(self))
    }
    
    internal var oneDecimalValue: Float {
        return NSString(format: "%.1f", self).floatValue
    }
    
    internal var twoDecimalValue: Float {
        return NSString(format: "%.2f", self).floatValue
    }
    
    internal var threeDecimalValue: Float {
        return NSString(format: "%.3f", self).floatValue
    }
    
    internal func equals(value: Float, precision: Int) -> Bool {
        if self == value {
            return true;
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
    internal var nearestKnownFraction: Float {
        if self >= MiseEnPlace.Fractions.sevenEighths {
            return 1.0
        } else if self >= MiseEnPlace.Fractions.threeFourthsDecimalBoundary {
            return MiseEnPlace.Fractions.threeFourths
        } else if self >= MiseEnPlace.Fractions.twoThirdsDecimalBoundary {
            return MiseEnPlace.Fractions.twoThirds
        } else if self >= MiseEnPlace.Fractions.fiveEighthsDecimalBoundary {
            return MiseEnPlace.Fractions.fiveEighths
        } else if self >= MiseEnPlace.Fractions.oneHalfDecimalBoundary {
            return MiseEnPlace.Fractions.oneHalf
        } else if self >= MiseEnPlace.Fractions.oneThirdDecimalBoundary {
            return MiseEnPlace.Fractions.oneThird
        } else if self >= MiseEnPlace.Fractions.oneFourthDecimalBoundary {
            return MiseEnPlace.Fractions.oneFourth
        }
        
        return 0.0
    }

    
    /// Returns the unicode symbol (or empty string) for known fraction values.
    internal var fractionSymbol: String {
        if self == MiseEnPlace.Fractions.sevenEighths || twoDecimalValue == MiseEnPlace.Fractions.sevenEighths.twoDecimalValue {
            return MiseEnPlace.Fractions.sevenEighthsSymbol
        } else if self == MiseEnPlace.Fractions.threeFourths || twoDecimalValue == MiseEnPlace.Fractions.threeFourths.twoDecimalValue {
            return MiseEnPlace.Fractions.threeFourthsSymbol
        } else if self == MiseEnPlace.Fractions.twoThirds || twoDecimalValue == MiseEnPlace.Fractions.twoThirds.twoDecimalValue {
            return MiseEnPlace.Fractions.twoThirdsSymbol
        } else if self == MiseEnPlace.Fractions.fiveEighths || twoDecimalValue == MiseEnPlace.Fractions.fiveEighths.twoDecimalValue {
            return MiseEnPlace.Fractions.fiveEighthsSymbol
        } else if self == MiseEnPlace.Fractions.oneHalf || twoDecimalValue == MiseEnPlace.Fractions.oneHalf.twoDecimalValue {
            return MiseEnPlace.Fractions.oneHalfSymbol
        } else if self == MiseEnPlace.Fractions.oneThird || twoDecimalValue == MiseEnPlace.Fractions.oneThird.twoDecimalValue {
            return MiseEnPlace.Fractions.oneThirdSymbol
        } else if self == MiseEnPlace.Fractions.oneFourth || twoDecimalValue == MiseEnPlace.Fractions.oneFourth.twoDecimalValue {
            return MiseEnPlace.Fractions.oneFourthSymbol
        }
        
        return ""
    }
    
    /// Converts an amoutn from one `MeasurementUnit` to another `MeasurementUnit`
    /// within the same `MeasurementSystemMethod`
    internal func convert(from fromUnit: MeasurementUnit, to toUnit: MeasurementUnit) -> Float {
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
