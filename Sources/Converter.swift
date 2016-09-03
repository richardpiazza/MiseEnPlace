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
    public static func volumeToMassRatioFor(volumeConvertable: Convertable, massConvertable: Convertable) -> Ratio {
        let volume = self.measurementAmountFor(volumeConvertable, measurementUnit: .FluidOunce)
        let mass = self.measurementAmountFor(massConvertable, measurementUnit: .Ounce)
        
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
    
    /// Calculates the conversion ratio for a given `Convertable`.
    /// If the `Convertable` measurement method is volume, a Mass/Volume calculation is performed.
    /// If the `Convertable` measurement method is mass, a Volume/Mass calculation is performed.
    public static func measurementMethodConversionRatioFor(convertable: Convertable) -> Float {
        if convertable.ratio.volume <= 0 || convertable.ratio.mass <= 0 {
            return 1
        }
        
        if let measurementMethod = convertable.measurementUnit.measurementMethod {
            if measurementMethod == .Volume {
                return convertable.ratio.mass / convertable.ratio.volume
            } else if measurementMethod == .Mass {
                return convertable.ratio.volume / convertable.ratio.mass
            }
        }
        
        return 1
    }
    
    /// Conveince methods that bundles parameters into the typealias `ScaleOptions`
    public static func scale(convertable: Convertable, withOptions scaleOptions: ScaleOptions) -> ScaleMeasure {
        return scale(convertable, multiplier: scaleOptions.multiplier, measurementSystem: scaleOptions.measurementSystem, measurementMethod: scaleOptions.measurementMethod)
    }
    
    /// Wrapper function for determining the correct `MeasurementSystemMethod`, 
    /// passing the result to `Scale(:Convertable,:Float,:MeasurementSystemMethod)`
    public static func scale(convertable: Convertable, multiplier: Float, measurementSystem: MeasurementSystem?, measurementMethod: MeasurementMethod?) -> ScaleMeasure {
        
        let measurementUnit = convertable.measurementUnit
        
        if measurementUnit == .AsNeeded {
            return ScaleMeasure(amount: convertable.measurementAmount, unit: .AsNeeded)
        } else if measurementUnit == .Each {
            return ScaleMeasure(amount: convertable.measurementAmount * multiplier, unit: .Each)
        }
        
        let measurementSystemMethod = measurementUnit.measurementSystemMethod!
        
        if measurementSystem == nil {
            if measurementMethod == nil {
                return ScaleMeasure(amount: convertable.measurementAmount, unit: convertable.measurementUnit)
            } else if measurementMethod! == .Volume {
                if measurementSystemMethod == .USVolume || measurementSystemMethod == .USMass {
                    return self.scale(convertable, multiplier: multiplier, measurementSystemMethod: .USVolume)
                } else if measurementSystemMethod == .MetricVolume || measurementSystemMethod == .MetricMass {
                    return self.scale(convertable, multiplier: multiplier, measurementSystemMethod: .MetricVolume)
                }
            } else if measurementMethod! == .Mass {
                if measurementSystemMethod == .USVolume || measurementSystemMethod == .USMass {
                    return self.scale(convertable, multiplier: multiplier, measurementSystemMethod: .USMass)
                } else if measurementSystemMethod == .MetricVolume || measurementSystemMethod == .MetricMass {
                    return self.scale(convertable, multiplier: multiplier, measurementSystemMethod: .MetricMass)
                }
            }
        } else if measurementSystem! == .US {
            if measurementMethod == nil {
                if measurementSystemMethod == .USVolume || measurementSystemMethod == .MetricVolume {
                    return self.scale(convertable, multiplier: multiplier, measurementSystemMethod: .USVolume)
                } else if measurementSystemMethod == .USMass || measurementSystemMethod == .MetricMass {
                    return self.scale(convertable, multiplier: multiplier, measurementSystemMethod: .USMass)
                }
            } else if measurementMethod! == .Volume {
                return self.scale(convertable, multiplier: multiplier, measurementSystemMethod: .USVolume)
            } else if measurementMethod! == .Mass {
                return self.scale(convertable, multiplier: multiplier, measurementSystemMethod: .USMass)
            }
        } else if measurementSystem! == .Metric {
            if measurementMethod == nil {
                if measurementSystemMethod == .USVolume || measurementSystemMethod == .MetricVolume {
                    return self.scale(convertable, multiplier: multiplier, measurementSystemMethod: .MetricVolume)
                } else if measurementSystemMethod == .USMass || measurementSystemMethod == .MetricMass {
                    return self.scale(convertable, multiplier: multiplier, measurementSystemMethod: .MetricMass)
                }
            } else if measurementMethod! == .Volume {
                return self.scale(convertable, multiplier: multiplier, measurementSystemMethod: .MetricVolume)
            } else if measurementMethod! == .Mass {
                return self.scale(convertable, multiplier: multiplier, measurementSystemMethod: .MetricMass)
            }
        }
        
        return ScaleMeasure(amount: convertable.measurementAmount, unit: convertable.measurementUnit)
    }
    
    /// Returns a `ScaleMeasure` that best fits a `Convertable` measurementAmount * the multipler 
    /// within the specified `MeasurementSystemMethod`
    public static func scale(convertable: Convertable, multiplier: Float, measurementSystemMethod: MeasurementSystemMethod) -> ScaleMeasure {
        let measurementUnit = convertable.measurementUnit
        
        if measurementUnit == .AsNeeded {
            return ScaleMeasure(amount: convertable.measurementAmount, unit: .AsNeeded)
        } else if measurementUnit == .Each {
            return ScaleMeasure(amount: convertable.measurementAmount * multiplier, unit: .Each)
        }
        
        let measurementUnits = Array(MeasurementUnit.measurementUnits(forMeasurementSystemMethod: measurementSystemMethod).reverse())
        for unit in measurementUnits {
            let measurementAmount = self.measurementAmountFor(convertable, measurementUnit: unit)
            let total = measurementAmount * multiplier
            
            if total >= unit.stepDownThreshold {
                return ScaleMeasure(amount: total, unit: unit)
            }
        }
        
        return ScaleMeasure(amount: convertable.measurementAmount, unit: convertable.measurementUnit)
    }
    
    /// Calculates the measurementAmount of a specific `MeasurementUnit` for a `Convertable`
    public static func measurementAmountFor(convertable: Convertable, measurementUnit: MeasurementUnit) -> Float {
        if convertable.measurementAmount == 0 {
            return convertable.measurementAmount
        }
        
        guard let fromMeasurementSystemMethod = convertable.measurementUnit.measurementSystemMethod else {
            return 0
        }
        
        guard let toMeasurementSystemMethod = measurementUnit.measurementSystemMethod else {
            return 0
        }
        
        switch fromMeasurementSystemMethod {
        case .USVolume:
            if toMeasurementSystemMethod == .USVolume {
                return self.convert(convertable.measurementAmount, fromMeasurementUnit: convertable.measurementUnit, toMeasurementUnit: measurementUnit)
            }
            
            let fluidOunce: Float = self.measurementAmountFor(convertable, measurementUnit: .FluidOunce)
            let ounce: Float = self.measurementMethodConversionRatioFor(convertable) * fluidOunce
            let milliliter: Float = self.fluidOunceMilliliterRatio * fluidOunce
            let gram: Float = self.ounceGramRatio * ounce
            
            if toMeasurementSystemMethod == .USMass {
                return self.convert(ounce, fromMeasurementUnit: .Ounce, toMeasurementUnit: measurementUnit)
            } else if toMeasurementSystemMethod == .MetricVolume {
                return self.convert(milliliter, fromMeasurementUnit: .Milliliter, toMeasurementUnit: measurementUnit)
            } else if toMeasurementSystemMethod == .MetricMass {
                return self.convert(gram, fromMeasurementUnit: .Gram, toMeasurementUnit: measurementUnit)
            }
        case .USMass:
            if toMeasurementSystemMethod == .USMass {
                return self.convert(convertable.measurementAmount, fromMeasurementUnit: convertable.measurementUnit, toMeasurementUnit: measurementUnit)
            }
            
            let ounce: Float = self.measurementAmountFor(convertable, measurementUnit: .Ounce)
            let fluidOunce: Float = self.measurementMethodConversionRatioFor(convertable) * ounce
            let milliliter: Float = self.fluidOunceMilliliterRatio * fluidOunce
            let gram: Float = self.ounceGramRatio * ounce
            
            if toMeasurementSystemMethod == .USVolume {
                return self.convert(fluidOunce, fromMeasurementUnit: .FluidOunce, toMeasurementUnit: measurementUnit)
            } else if toMeasurementSystemMethod == .MetricVolume {
                return self.convert(milliliter, fromMeasurementUnit: .Milliliter, toMeasurementUnit: measurementUnit)
            } else if toMeasurementSystemMethod == .MetricMass {
                return self.convert(gram, fromMeasurementUnit: .Gram, toMeasurementUnit: measurementUnit)
            }
        case .MetricVolume:
            if toMeasurementSystemMethod == .MetricVolume {
                return self.convert(convertable.measurementAmount, fromMeasurementUnit: convertable.measurementUnit, toMeasurementUnit: measurementUnit)
            }
            
            let milliliter: Float = self.measurementAmountFor(convertable, measurementUnit: .Milliliter)
            let gram: Float = self.measurementMethodConversionRatioFor(convertable) * milliliter
            let fluidOunce: Float = milliliter / self.fluidOunceMilliliterRatio
            let ounce: Float = gram / self.ounceGramRatio
            
            if toMeasurementSystemMethod == .MetricMass {
                return self.convert(gram, fromMeasurementUnit: .Gram, toMeasurementUnit: measurementUnit)
            } else if toMeasurementSystemMethod == .USVolume {
                return self.convert(fluidOunce, fromMeasurementUnit: .FluidOunce, toMeasurementUnit: measurementUnit)
            } else if toMeasurementSystemMethod == .USMass {
                return self.convert(ounce, fromMeasurementUnit: .Ounce, toMeasurementUnit: measurementUnit)
            }
        case .MetricMass:
            if toMeasurementSystemMethod == .MetricMass {
                return self.convert(convertable.measurementAmount, fromMeasurementUnit: convertable.measurementUnit, toMeasurementUnit: measurementUnit)
            }
            
            let gram: Float = self.measurementAmountFor(convertable, measurementUnit: .Gram)
            let milliliter: Float = self.measurementMethodConversionRatioFor(convertable) * gram
            let fluidOunce: Float = milliliter / self.fluidOunceMilliliterRatio
            let ounce: Float = gram / self.ounceGramRatio
            
            if toMeasurementSystemMethod == .MetricVolume {
                return self.convert(milliliter, fromMeasurementUnit: .Milliliter, toMeasurementUnit: measurementUnit)
            } else if toMeasurementSystemMethod == .USVolume {
                return self.convert(fluidOunce, fromMeasurementUnit: .FluidOunce, toMeasurementUnit: measurementUnit)
            } else if toMeasurementSystemMethod == .USMass {
                return self.convert(ounce, fromMeasurementUnit: .Ounce, toMeasurementUnit: measurementUnit)
            }
        }
        
        return 0
    }
    
    /// Converts a specified measurementAmount from one `MeasurementUnit` to another `MeasurementUnit` 
    /// within the same `MeasurementSystemMethod`
    public static func convert(measurementAmount: Float, fromMeasurementUnit: MeasurementUnit, toMeasurementUnit: MeasurementUnit) -> Float {
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
        
        for (index, item) in measurementUnits.enumerate() {
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
