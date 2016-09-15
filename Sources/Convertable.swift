//===----------------------------------------------------------------------===//
//
// Convertable.swift
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

/// ## Convertable
/// Protocol specifying properties needing to be supplied for conversion.
public protocol Convertable {
    var measurement: Measurement { get }
    var ratio: Ratio { get }
}

public extension Convertable {
    /// Calculates the multiplier needed to convert from one `MeasurementMethod`
    /// to another `MeasurementMethod`.
    ///
    /// If the `MeasurementMethod` is .volume, a Mass/Volume calculation is made.
    /// If the `MeasurementMethod` is .mass, a Volume/Mass calculation is made.
    public var conversionMultiplier: Float {
        guard ratio.volume > 0.0 && ratio.mass > 0.0 else {
            return 1.0
        }
        
        guard let measurementMethod = measurement.unit.measurementMethod else {
            return 1.0
        }
        
        switch measurementMethod {
        case .volume:
            return ratio.mass / ratio.volume
        case .mass:
            return ratio.volume / ratio.mass
        }
    }
    
    /// Calculates the amount for a given unit.
    public func amount(for unit: MeasurementUnit) -> Float {
        guard measurement.amount > 0.0 else {
            return 0.0
        }
        
        guard let fromMeasurementSystemMethod = measurement.unit.measurementSystemMethod else {
            return 0.0
        }
        
        guard let toMeasurementSystemMethod = unit.measurementSystemMethod else {
            return 0.0
        }
        
        switch fromMeasurementSystemMethod {
        case .usVolume:
            if toMeasurementSystemMethod == .usVolume {
                return measurement.amount.convert(from: measurement.unit, to: unit)
            }
            
            let fluidOunce = amount(for: .fluidOunce)
            let ounce = conversionMultiplier * fluidOunce
            let milliliter = MiseEnPlace.Multipliers.fluidOunceMilliliter * fluidOunce
            let gram: Float = MiseEnPlace.Multipliers.ounceGram * ounce
            
            if toMeasurementSystemMethod == .usMass {
                return ounce.convert(from: .ounce, to: unit)
            } else if toMeasurementSystemMethod == .metricVolume {
                return milliliter.convert(from: .milliliter, to: unit)
            } else if toMeasurementSystemMethod == .metricMass {
                return gram.convert(from: .gram, to: unit)
            }
        case .usMass:
            if toMeasurementSystemMethod == .usMass {
                return measurement.amount.convert(from: measurement.unit, to: unit)
            }
            
            let ounce = amount(for: .ounce)
            let fluidOunce = conversionMultiplier * ounce
            let milliliter = MiseEnPlace.Multipliers.fluidOunceMilliliter * fluidOunce
            let gram = MiseEnPlace.Multipliers.ounceGram * ounce
            
            if toMeasurementSystemMethod == .usVolume {
                return fluidOunce.convert(from: .fluidOunce, to: unit)
            } else if toMeasurementSystemMethod == .metricVolume {
                return milliliter.convert(from: .milliliter, to: unit)
            } else if toMeasurementSystemMethod == .metricMass {
                return gram.convert(from: .gram, to: unit)
            }
        case .metricVolume:
            if toMeasurementSystemMethod == .metricVolume {
                return measurement.amount.convert(from: measurement.unit, to: unit)
            }
            
            let milliliter = amount(for: .milliliter)
            let gram = conversionMultiplier * milliliter
            let fluidOunce = milliliter / MiseEnPlace.Multipliers.fluidOunceMilliliter
            let ounce = gram / MiseEnPlace.Multipliers.ounceGram
            
            if toMeasurementSystemMethod == .metricMass {
                return gram.convert(from: .gram, to: unit)
            } else if toMeasurementSystemMethod == .usVolume {
                return fluidOunce.convert(from: .fluidOunce, to: unit)
            } else if toMeasurementSystemMethod == .usMass {
                return ounce.convert(from: .ounce, to: unit)
            }
        case .metricMass:
            if toMeasurementSystemMethod == .metricMass {
                return measurement.amount.convert(from: measurement.unit, to: unit)
            }
            
            let gram = amount(for: .gram)
            let milliliter = conversionMultiplier * gram
            let fluidOunce = milliliter / MiseEnPlace.Multipliers.fluidOunceMilliliter
            let ounce = gram / MiseEnPlace.Multipliers.ounceGram
            
            if toMeasurementSystemMethod == .metricVolume {
                return milliliter.convert(from: .milliliter, to: unit)
            } else if toMeasurementSystemMethod == .usVolume {
                return fluidOunce.convert(from: .fluidOunce, to: unit)
            } else if toMeasurementSystemMethod == .usMass {
                return ounce.convert(from: .ounce, to: unit)
            }
        }
        
        return 0.0
    }
    
    /// Scales a measurement by the given multiplier and returns the result
    /// best fitting within the specified `MeasurementSystemMethod`.
    ///
    /// All `MeasurementUnit`s of a given system are tested, and the unit having
    /// the multiplied total within its stepUp and stepDown range will be returned.
    public func scale(by multiplier: Float, measurementSystemMethod: MeasurementSystemMethod) -> Measurement {
        if measurement.unit == .asNeeded {
            return measurement
        } else if measurement.unit == .each {
            return Measurement(amount: measurement.amount * multiplier, unit: measurement.unit)
        }
        
        let measurementUnits = Array(MeasurementUnit.measurementUnits(forMeasurementSystemMethod: measurementSystemMethod).reversed())
        for unit in measurementUnits {
            let total = amount(for: unit) * multiplier
            if total >= unit.stepDownThreshold {
                return Measurement(amount: total, unit: unit)
            }
        }
        
        return measurement
    }
    
    /// Wrapper for scale(by:measurementSystemMethod:)
    /// Determines the `MeasurementSystemMethod` based on the `MeasurementSystem` and
    /// `MeasurementMethod` provided.
    public func scale(by multiplier: Float, measurementSystem: MeasurementSystem?, measurementMethod: MeasurementMethod?) -> Measurement {
        if measurement.unit == .asNeeded {
            return measurement
        } else if measurement.unit == .each {
            return Measurement(amount: measurement.amount * multiplier, unit: measurement.unit)
        }
        
        guard let measurementSystemMethod = measurement.unit.measurementSystemMethod else {
            return measurement
        }
        
        if measurementSystem == nil {
            if measurementMethod == nil {
                return Measurement(amount: measurement.amount, unit: measurement.unit)
            } else if measurementMethod! == .volume {
                if measurementSystemMethod == .usVolume || measurementSystemMethod == .usMass {
                    return scale(by: multiplier, measurementSystemMethod: .usVolume)
                } else if measurementSystemMethod == .metricVolume || measurementSystemMethod == .metricMass {
                    return scale(by: multiplier, measurementSystemMethod: .metricVolume)
                }
            } else if measurementMethod! == .mass {
                if measurementSystemMethod == .usVolume || measurementSystemMethod == .usMass {
                    return scale(by: multiplier, measurementSystemMethod: .usMass)
                } else if measurementSystemMethod == .metricVolume || measurementSystemMethod == .metricMass {
                    return scale(by: multiplier, measurementSystemMethod: .metricMass)
                }
            }
        } else if measurementSystem! == .us {
            if measurementMethod == nil {
                if measurementSystemMethod == .usVolume || measurementSystemMethod == .metricVolume {
                    return scale(by: multiplier, measurementSystemMethod: .usVolume)
                } else if measurementSystemMethod == .usMass || measurementSystemMethod == .metricMass {
                    return scale(by: multiplier, measurementSystemMethod: .usMass)
                }
            } else if measurementMethod! == .volume {
                return scale(by: multiplier, measurementSystemMethod: .usVolume)
            } else if measurementMethod! == .mass {
                return scale(by: multiplier, measurementSystemMethod: .usMass)
            }
        } else if measurementSystem! == .metric {
            if measurementMethod == nil {
                if measurementSystemMethod == .usVolume || measurementSystemMethod == .metricVolume {
                    return scale(by: multiplier, measurementSystemMethod: .metricVolume)
                } else if measurementSystemMethod == .usMass || measurementSystemMethod == .metricMass {
                    return scale(by: multiplier, measurementSystemMethod: .metricMass)
                }
            } else if measurementMethod! == .volume {
                return scale(by: multiplier, measurementSystemMethod: .metricVolume)
            } else if measurementMethod! == .mass {
                return scale(by: multiplier, measurementSystemMethod: .metricMass)
            }
        }
        
        return measurement
    }
}
