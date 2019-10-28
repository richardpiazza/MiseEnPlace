import Foundation

/// ## Convertable
/// Protocol specifying properties needing to be supplied for conversion.
@available(*, deprecated, message: "Use `Proportioned` and `Quantifiable` protocols.")
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
    @available(*, deprecated, message: "Use `Proportioned.multiplier(for:)`?")
    var conversionMultiplier: Double {
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
    @available(*, deprecated, message: "Use `Quantification.amount(for:..)`")
    func amount(for unit: MeasurementUnit) -> Double {
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
            let milliliter = Configuration.millilitersPerFluidOunce * fluidOunce
            let gram: Double = Configuration.gramsPerOunce * ounce
            
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
            let milliliter = Configuration.millilitersPerFluidOunce * fluidOunce
            let gram = Configuration.gramsPerOunce * ounce
            
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
            let fluidOunce = milliliter / Configuration.millilitersPerFluidOunce
            let ounce = gram / Configuration.gramsPerOunce
            
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
            let fluidOunce = milliliter / Configuration.millilitersPerFluidOunce
            let ounce = gram / Configuration.gramsPerOunce
            
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
    @available(*, deprecated, message: "Use `FormulaElement.scale(by:...)`")
    func scale(by multiplier: Double, measurementSystemMethod: MeasurementSystemMethod) -> CookingMeasurement {
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
    @available(*, deprecated, message: "Use `FormulaElement.scale(by:...)`")
    func scale(by multiplier: Double, measurementSystem: MeasurementSystem?, measurementMethod: MeasurementMethod?) -> CookingMeasurement {
        if measurementSystem == .numeric || measurementMethod == .quantity {
            return scale(by: multiplier, measurementSystemMethod: .numericQuantity)
        }
        
        let measurementSystemMethod = measurement.unit.measurementSystemMethod
        
        if measurementSystem == nil {
            guard let measurementMethod = measurementMethod else {
                return CookingMeasurement(amount: measurement.amount * multiplier, unit: measurement.unit)
            }
            
            switch measurementMethod {
            case .quantity:
                return scale(by: multiplier, measurementSystemMethod: .numericQuantity)
            case .volume:
                switch measurementSystemMethod {
                case .numericQuantity:
                    return scale(by: multiplier, measurementSystemMethod: .numericQuantity)
                case .usVolume, .usWeight:
                    return scale(by: multiplier, measurementSystemMethod: .usVolume)
                case .metricVolume, .metricWeight:
                    return scale(by: multiplier, measurementSystemMethod: .metricVolume)
                }
            case .weight:
                switch measurementSystemMethod {
                case .numericQuantity:
                    return scale(by: multiplier, measurementSystemMethod: .numericQuantity)
                case .usVolume, .usWeight:
                    return scale(by: multiplier, measurementSystemMethod: .usWeight)
                case .metricVolume, .metricWeight:
                    return scale(by: multiplier, measurementSystemMethod: .metricWeight)
                }
            }
        } else if measurementSystem! == .us {
            if measurementMethod == nil {
                switch measurementSystemMethod {
                case .numericQuantity:
                    return scale(by: multiplier, measurementSystemMethod: .numericQuantity)
                case .usVolume, .metricVolume:
                    return scale(by: multiplier, measurementSystemMethod: .usVolume)
                case .usWeight, .metricWeight:
                    return scale(by: multiplier, measurementSystemMethod: .usWeight)
                }
            } else if measurementMethod! == .volume {
                return scale(by: multiplier, measurementSystemMethod: .usVolume)
            } else if measurementMethod! == .weight {
                return scale(by: multiplier, measurementSystemMethod: .usWeight)
            }
        } else if measurementSystem! == .metric {
            if measurementMethod == nil {
                switch measurementSystemMethod {
                case .numericQuantity:
                    return scale(by: multiplier, measurementSystemMethod: .numericQuantity)
                case .usVolume, .metricVolume:
                    return scale(by: multiplier, measurementSystemMethod: .metricVolume)
                case .usWeight, .metricWeight:
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
    @available(*, deprecated, message: "Use `FormulaElement.scale(by:...)`")
    func scale(with parameters: ScaleParameters) -> CookingMeasurement {
        return scale(by: parameters.multiplier, measurementSystem: parameters.measurementSystem, measurementMethod: parameters.measurementMethod)
    }
}

@available(*, deprecated)
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
