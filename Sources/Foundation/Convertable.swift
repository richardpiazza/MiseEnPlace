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
    var measurement: CookingMeasurement { get }
    var ratio: Ratio { get }
    var eachMeasurement: CookingMeasurement? { get }
}

public extension Convertable {
    /// Calculates the multiplier needed to convert from one `MeasurementMethod`
    /// to another `MeasurementMethod`.
    ///
    /// If the `MeasurementMethod` is .volume, a Weight/Volume calculation is made.
    /// If the `MeasurementMethod` is .weight, a Volume/Weight calculation is made.
    public var conversionMultiplier: Double {
        guard ratio.volume > 0.0 && ratio.weight > 0.0 else {
            return 1.0
        }
        
        var measurementMethod: MeasurementMethod
        if let em = eachMeasurement, measurement.unit == .each {
            measurementMethod = em.unit.measurementMethod
        } else {
            measurementMethod = measurement.unit.measurementMethod
        }
        
        switch measurementMethod {
        case .volume:
            return ratio.weight / ratio.volume
        case .weight:
            return ratio.volume / ratio.weight
        default:
            return 1.0
        }
    }
    
    /// Calculates the amount for a given unit.
    public func amount(for unit: MeasurementUnit) -> Double {
        guard measurement.amount > 0.0 else {
            return 0.0
        }
        
        let fromMeasurementSystemMethod = measurement.unit.measurementSystemMethod
        let toMeasurementSystemMethod = unit.measurementSystemMethod
        
        switch fromMeasurementSystemMethod {
        case .usVolume:
            if toMeasurementSystemMethod == .usVolume {
                return measurement.amount.convert(from: measurement.unit, to: unit)
            }
            
            let fluidOunce = amount(for: .fluidOunce)
            let ounce = conversionMultiplier * fluidOunce
            let milliliter = MiseEnPlace.Multipliers.fluidOunceMilliliter * fluidOunce
            let gram: Double = MiseEnPlace.Multipliers.ounceGram * ounce
            
            if toMeasurementSystemMethod == .usWeight {
                return ounce.convert(from: .ounce, to: unit)
            } else if toMeasurementSystemMethod == .metricVolume {
                return milliliter.convert(from: .milliliter, to: unit)
            } else if toMeasurementSystemMethod == .metricWeight {
                return gram.convert(from: .gram, to: unit)
            }
        case .usWeight:
            if toMeasurementSystemMethod == .usWeight {
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
            } else if toMeasurementSystemMethod == .metricWeight {
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
            
            if toMeasurementSystemMethod == .metricWeight {
                return gram.convert(from: .gram, to: unit)
            } else if toMeasurementSystemMethod == .usVolume {
                return fluidOunce.convert(from: .fluidOunce, to: unit)
            } else if toMeasurementSystemMethod == .usWeight {
                return ounce.convert(from: .ounce, to: unit)
            }
        case .metricWeight:
            if toMeasurementSystemMethod == .metricWeight {
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
            } else if toMeasurementSystemMethod == .usWeight {
                return ounce.convert(from: .ounce, to: unit)
            }
        default:
            return 0.0
        }
        
        return 0.0
    }
    
    /// Scales a measurement by the given multiplier and returns the result
    /// best fitting within the specified `MeasurementSystemMethod`.
    ///
    /// All `MeasurementUnit`s of a given system are tested, and the unit having
    /// the multiplied total within its stepUp and stepDown range will be returned.
    public func scale(by multiplier: Double, measurementSystemMethod: MeasurementSystemMethod) -> CookingMeasurement {
        guard measurement.unit != .asNeeded else {
            return measurement
        }
        
        guard measurement.unit != .each else {
            guard let _ = self.eachMeasurement else {
                return CookingMeasurement(amount: measurement.amount * multiplier, unit: measurement.unit)
            }
            
            switch measurementSystemMethod {
            case .numericQuantity:
                return CookingMeasurement(amount: measurement.amount * multiplier, unit: measurement.unit)
            default:
                guard let eachConvertable = EachConvertable(convertable: self) else {
                    return CookingMeasurement(amount: measurement.amount * multiplier, unit: measurement.unit)
                }
                
                return eachConvertable.scale(by: multiplier, measurementSystemMethod: measurementSystemMethod)
            }
        }
        
        guard measurementSystemMethod != .numericQuantity else {
            guard let eachMeasurement = self.eachMeasurement else {
                return CookingMeasurement(amount: measurement.amount * multiplier, unit: measurement.unit)
            }
            
            let amt = amount(for: eachMeasurement.unit)
            let total = amt / eachMeasurement.amount
            
            return CookingMeasurement(amount: total, unit: .each)
        }
        
        let measurementUnits = Array(MeasurementUnit.measurementUnits(forMeasurementSystemMethod: measurementSystemMethod).reversed())
        for unit in measurementUnits {
            let total = amount(for: unit) * multiplier
            if total >= unit.stepDownThreshold {
                return CookingMeasurement(amount: total, unit: unit)
            }
        }
        
        return measurement
    }
    
    /// Wrapper for scale(by:measurementSystemMethod:)
    /// Determines the `MeasurementSystemMethod` based on the `MeasurementSystem` and
    /// `MeasurementMethod` provided.
    public func scale(by multiplier: Double, measurementSystem: MeasurementSystem?, measurementMethod: MeasurementMethod?) -> CookingMeasurement {
        if measurementSystem == .numeric || measurementMethod == .quantity {
            return scale(by: multiplier, measurementSystemMethod: .numericQuantity)
        }
        
        if measurement.unit == .asNeeded {
            return measurement
        } else if measurement.unit == .each {
            return CookingMeasurement(amount: measurement.amount * multiplier, unit: measurement.unit)
        }
        
        let measurementSystemMethod = measurement.unit.measurementSystemMethod
        
        if measurementSystem == nil {
            if measurementMethod == nil {
                return CookingMeasurement(amount: measurement.amount * multiplier, unit: measurement.unit)
            } else if measurementMethod! == .volume {
                if measurementSystemMethod == .usVolume || measurementSystemMethod == .usWeight {
                    return scale(by: multiplier, measurementSystemMethod: .usVolume)
                } else if measurementSystemMethod == .metricVolume || measurementSystemMethod == .metricWeight {
                    return scale(by: multiplier, measurementSystemMethod: .metricVolume)
                }
            } else if measurementMethod! == .weight {
                if measurementSystemMethod == .usVolume || measurementSystemMethod == .usWeight {
                    return scale(by: multiplier, measurementSystemMethod: .usWeight)
                } else if measurementSystemMethod == .metricVolume || measurementSystemMethod == .metricWeight {
                    return scale(by: multiplier, measurementSystemMethod: .metricWeight)
                }
            }
        } else if measurementSystem! == .us {
            if measurementMethod == nil {
                if measurementSystemMethod == .usVolume || measurementSystemMethod == .metricVolume {
                    return scale(by: multiplier, measurementSystemMethod: .usVolume)
                } else if measurementSystemMethod == .usWeight || measurementSystemMethod == .metricWeight {
                    return scale(by: multiplier, measurementSystemMethod: .usWeight)
                }
            } else if measurementMethod! == .volume {
                return scale(by: multiplier, measurementSystemMethod: .usVolume)
            } else if measurementMethod! == .weight {
                return scale(by: multiplier, measurementSystemMethod: .usWeight)
            }
        } else if measurementSystem! == .metric {
            if measurementMethod == nil {
                if measurementSystemMethod == .usVolume || measurementSystemMethod == .metricVolume {
                    return scale(by: multiplier, measurementSystemMethod: .metricVolume)
                } else if measurementSystemMethod == .usWeight || measurementSystemMethod == .metricWeight {
                    return scale(by: multiplier, measurementSystemMethod: .metricWeight)
                }
            } else if measurementMethod! == .volume {
                return scale(by: multiplier, measurementSystemMethod: .metricVolume)
            } else if measurementMethod! == .weight {
                return scale(by: multiplier, measurementSystemMethod: .metricWeight)
            }
        }
        
        return measurement
    }
    
    /// Wrapper for scale(by:measurementSystem:measurementMethod)
    public func scale(with parameters: ScaleParameters) -> CookingMeasurement {
        return scale(by: parameters.multiplier, measurementSystem: parameters.measurementSystem, measurementMethod: parameters.measurementMethod)
    }
}

fileprivate struct EachConvertable: Convertable {
    var measurement: CookingMeasurement
    var ratio: Ratio
    var eachMeasurement: CookingMeasurement?
    
    init?(convertable: Convertable) {
        guard let em = convertable.eachMeasurement else {
            return nil
        }
        
        self.measurement = CookingMeasurement(amount: convertable.measurement.amount * em.amount, unit: em.unit)
        self.ratio = convertable.ratio
    }
}
