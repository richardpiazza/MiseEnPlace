//===----------------------------------------------------------------------===//
//
// Converter.swift
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

/// ## Converter
/// Provides functions needed for the conversion of amounts from 
/// one system of measurement to another system of measurement.
public class Converter {
    
    /// Replaces precise oz->g / floz->ml conversions with 30g/30ml respectively.
    public static var allowLooseConversion: Bool = false
    
    public static var fluidOunceMilliliterRatio: Float {
        get {
            return (self.allowLooseConversion) ? Constants.LooseFluidOunceMilliliterRatio : Constants.PreciseFluidOunceMilliliterRatio
        }
    }
    
    public static var ounceGramRatio: Float {
        get {
            return (self.allowLooseConversion) ? Constants.LooseOunceGramRatio : Constants.PreciseOunceGramRatio
        }
    }
    
    /// Calculates the volume : mass ratio for the given `Convertable` parameters.
    public static func volumeToMassRatioFor(_ volumeConvertable: Convertable, massConvertable: Convertable) -> Ratio {
        let volume = volumeConvertable.amount(for: .fluidOunce)
        let mass = massConvertable.amount(for: .ounce)
        
        guard volume != 0 && mass != 0 else {
            return Ratio(volume: 0.0, mass: 0.0)
        }
        
        var ratioVolume: Float = volume
        var ratioMass: Float = mass
        
        if volume >= mass {
            ratioVolume = ratioVolume / ratioMass
            ratioMass = ratioMass / ratioMass
        } else {
            ratioMass = ratioMass / ratioVolume
            ratioVolume = ratioVolume / ratioVolume
        }
        
        return Ratio(volume: ratioVolume, mass: ratioMass)
    }
    
    /// Converts a specified measurementAmount from one `MeasurementUnit` to another `MeasurementUnit`
    /// within the same `MeasurementSystemMethod`
    public static func convert(_ measurementAmount: Float, fromMeasurementUnit: MeasurementUnit, toMeasurementUnit: MeasurementUnit) -> Float {
        guard let _ = fromMeasurementUnit.measurementSystemMethod else {
            return 0
        }
        
        guard let toMeasurementSystemMethod = toMeasurementUnit.measurementSystemMethod else {
            return 0
        }
        
        let measurementUnits = MeasurementUnit.measurementUnits(forMeasurementSystemMethod: toMeasurementSystemMethod)
        if measurementUnits.contains(fromMeasurementUnit) == false {
            return 0
        }
        
        var currentIndex = -1
        var goalIndex = -1
        
        for (index, item) in measurementUnits.enumerated() {
            if item == fromMeasurementUnit {
                currentIndex = index
            }
            if item == toMeasurementUnit {
                goalIndex = index
            }
        }
        
        if currentIndex == goalIndex {
            return measurementAmount
        }
        
        var stepDirection = 0
        var nextMeasurementAmount: Float = measurementAmount
        if goalIndex - currentIndex > 0 {
            stepDirection = 1
            nextMeasurementAmount = measurementAmount * fromMeasurementUnit.stepUpMultiplier
        } else {
            stepDirection = -1
            nextMeasurementAmount = measurementAmount / fromMeasurementUnit.stepDownMultiplier
        }
        
        let nextIndex = currentIndex + stepDirection
        let nextMeasurementUnit = measurementUnits[nextIndex]
        
        return convert(nextMeasurementAmount, fromMeasurementUnit: nextMeasurementUnit, toMeasurementUnit: toMeasurementUnit)
    }
}
