//===----------------------------------------------------------------------===//
//
// Double+MiseEnPlace.swift
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
    
    /// Converts an amount from one `MeasurementUnit` to another `MeasurementUnit`
    /// within the same `MeasurementSystemMethod`
    public func convert(from fromUnit: MeasurementUnit, to toUnit: MeasurementUnit) -> Double {
        let measurementUnits = MeasurementUnit.measurementUnits(forMeasurementSystemMethod: toUnit.measurementSystemMethod)
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
