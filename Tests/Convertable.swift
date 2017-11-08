import Foundation

/// ## Convertable
/// Protocol specifying properties needing to be supplied for conversion.
public protocol Convertable {
    var measurement: MiseEnPlace.Measurement { get }
    var ratio: Ratio { get }
    var eachMeasurement: MiseEnPlace.Measurement? { get }
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
    public func amount(for unit: MeasurementUnit) throws -> Double {
        guard measurement.amount > 0.0 else {
            return 0.0
        }
        
        let fromMeasurementSystemMethod = measurement.unit.measurementSystemMethod
        let toMeasurementSystemMethod = unit.measurementSystemMethod
        
        switch fromMeasurementSystemMethod {
        case .usVolume:
            if toMeasurementSystemMethod == .usVolume {
                return try measurement.amount(for: unit)
            }
            
            let fluidOunce = try self.amount(for: .fluidOunce)
            let ounce = conversionMultiplier * fluidOunce
            let milliliter = MiseEnPlace.Configuration.fluidOunceMilliliter * fluidOunce
            let gram: Double = MiseEnPlace.Configuration.ounceGram * ounce
            
            if toMeasurementSystemMethod == .usWeight {
                return try MiseEnPlace.Measurement(amount: ounce, unit: .ounce).amount(for: unit)
            } else if toMeasurementSystemMethod == .metricVolume {
                return try MiseEnPlace.Measurement(amount: milliliter, unit: .milliliter).amount(for: unit)
            } else if toMeasurementSystemMethod == .metricWeight {
                return try MiseEnPlace.Measurement(amount: gram, unit: .gram).amount(for: unit)
            }
        case .usWeight:
            if toMeasurementSystemMethod == .usWeight {
                return try measurement.amount(for: unit)
            }
            
            let ounce = try self.amount(for: .ounce)
            let fluidOunce = conversionMultiplier * ounce
            let milliliter = MiseEnPlace.Configuration.fluidOunceMilliliter * fluidOunce
            let gram = MiseEnPlace.Configuration.ounceGram * ounce
            
            if toMeasurementSystemMethod == .usVolume {
                return try MiseEnPlace.Measurement(amount: fluidOunce, unit: .fluidOunce).amount(for: unit)
            } else if toMeasurementSystemMethod == .metricVolume {
                return try MiseEnPlace.Measurement(amount: milliliter, unit: .milliliter).amount(for: unit)
            } else if toMeasurementSystemMethod == .metricWeight {
                return try MiseEnPlace.Measurement(amount: gram, unit: .gram).amount(for: unit)
            }
        case .metricVolume:
            if toMeasurementSystemMethod == .metricVolume {
                return try measurement.amount(for: unit)
            }
            
            let milliliter = try self.amount(for: .milliliter)
            let gram = conversionMultiplier * milliliter
            let fluidOunce = milliliter / MiseEnPlace.Configuration.fluidOunceMilliliter
            let ounce = gram / MiseEnPlace.Configuration.ounceGram
            
            if toMeasurementSystemMethod == .metricWeight {
                return try MiseEnPlace.Measurement(amount: gram, unit: .gram).amount(for: unit)
            } else if toMeasurementSystemMethod == .usVolume {
                return try MiseEnPlace.Measurement(amount: fluidOunce, unit: .fluidOunce).amount(for: unit)
            } else if toMeasurementSystemMethod == .usWeight {
                return try MiseEnPlace.Measurement(amount: ounce, unit: .ounce).amount(for: unit)
            }
        case .metricWeight:
            if toMeasurementSystemMethod == .metricWeight {
                return try measurement.amount(for: unit)
            }
            
            let gram = try self.amount(for: .gram)
            let milliliter = conversionMultiplier * gram
            let fluidOunce = milliliter / MiseEnPlace.Configuration.fluidOunceMilliliter
            let ounce = gram / MiseEnPlace.Configuration.ounceGram
            
            if toMeasurementSystemMethod == .metricVolume {
                return try MiseEnPlace.Measurement(amount: milliliter, unit: .milliliter).amount(for: unit)
            } else if toMeasurementSystemMethod == .usVolume {
                return try MiseEnPlace.Measurement(amount: fluidOunce, unit: .fluidOunce).amount(for: unit)
            } else if toMeasurementSystemMethod == .usWeight {
                return try MiseEnPlace.Measurement(amount: ounce, unit: .ounce).amount(for: unit)
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
    public func scale(by multiplier: Double, measurementSystemMethod: MeasurementSystemMethod) throws -> MiseEnPlace.Measurement {
        guard measurement.unit != .asNeeded else {
            return measurement
        }
        
        guard measurement.unit != .each else {
            guard let _ = self.eachMeasurement else {
                return MiseEnPlace.Measurement(amount: measurement.amount * multiplier, unit: measurement.unit)
            }
            
            switch measurementSystemMethod {
            case .numericQuantity:
                return MiseEnPlace.Measurement(amount: measurement.amount * multiplier, unit: measurement.unit)
            default:
                guard let eachConvertable = EachConvertable(convertable: self) else {
                    return MiseEnPlace.Measurement(amount: measurement.amount * multiplier, unit: measurement.unit)
                }
                
                return try eachConvertable.scale(by: multiplier, measurementSystemMethod: measurementSystemMethod)
            }
        }
        
        guard measurementSystemMethod != .numericQuantity else {
            guard let eachMeasurement = self.eachMeasurement else {
                return MiseEnPlace.Measurement(amount: measurement.amount * multiplier, unit: measurement.unit)
            }
            
            let amt = try self.amount(for: eachMeasurement.unit)
            let total = amt / eachMeasurement.amount
            
            return MiseEnPlace.Measurement(amount: total, unit: .each)
        }
        
        let measurementUnits = Array(MeasurementUnit.measurementUnits(forMeasurementSystemMethod: measurementSystemMethod).reversed())
        for unit in measurementUnits {
            let total = try self.amount(for: unit) * multiplier
            if total >= unit.stepDownThreshold {
                return MiseEnPlace.Measurement(amount: total, unit: unit)
            }
        }
        
        return measurement
    }
    
    /// Wrapper for scale(by:measurementSystemMethod:)
    /// Determines the `MeasurementSystemMethod` based on the `MeasurementSystem` and
    /// `MeasurementMethod` provided.
    public func scale(by multiplier: Double, measurementSystem: MeasurementSystem?, measurementMethod: MeasurementMethod?) throws -> MiseEnPlace.Measurement {
        if measurementSystem == .numeric || measurementMethod == .quantity {
            return try self.scale(by: multiplier, measurementSystemMethod: .numericQuantity)
        }
        
        let measurementSystemMethod = measurement.unit.measurementSystemMethod
        
        if measurementSystem == nil {
            guard let measurementMethod = measurementMethod else {
                return MiseEnPlace.Measurement(amount: measurement.amount * multiplier, unit: measurement.unit)
            }
            
            switch measurementMethod {
            case .quantity:
                return try self.scale(by: multiplier, measurementSystemMethod: .numericQuantity)
            case .volume:
                switch measurementSystemMethod {
                case .numericQuantity:
                    return try self.scale(by: multiplier, measurementSystemMethod: .numericQuantity)
                case .usVolume, .usWeight:
                    return try self.scale(by: multiplier, measurementSystemMethod: .usVolume)
                case .metricVolume, .metricWeight:
                    return try self.scale(by: multiplier, measurementSystemMethod: .metricVolume)
                }
            case .weight:
                switch measurementSystemMethod {
                case .numericQuantity:
                    return try self.scale(by: multiplier, measurementSystemMethod: .numericQuantity)
                case .usVolume, .usWeight:
                    return try self.scale(by: multiplier, measurementSystemMethod: .usWeight)
                case .metricVolume, .metricWeight:
                    return try self.scale(by: multiplier, measurementSystemMethod: .metricWeight)
                }
            }
        } else if measurementSystem! == .us {
            if measurementMethod == nil {
                switch measurementSystemMethod {
                case .numericQuantity:
                    return try self.scale(by: multiplier, measurementSystemMethod: .numericQuantity)
                case .usVolume, .metricVolume:
                    return try self.scale(by: multiplier, measurementSystemMethod: .usVolume)
                case .usWeight, .metricWeight:
                    return try self.scale(by: multiplier, measurementSystemMethod: .usWeight)
                }
            } else if measurementMethod! == .volume {
                return try self.scale(by: multiplier, measurementSystemMethod: .usVolume)
            } else if measurementMethod! == .weight {
                return try self.scale(by: multiplier, measurementSystemMethod: .usWeight)
            }
        } else if measurementSystem! == .metric {
            if measurementMethod == nil {
                switch measurementSystemMethod {
                case .numericQuantity:
                    return try self.scale(by: multiplier, measurementSystemMethod: .numericQuantity)
                case .usVolume, .metricVolume:
                    return try self.scale(by: multiplier, measurementSystemMethod: .metricVolume)
                case .usWeight, .metricWeight:
                    return try self.scale(by: multiplier, measurementSystemMethod: .metricWeight)
                }
            } else if measurementMethod! == .volume {
                return try self.scale(by: multiplier, measurementSystemMethod: .metricVolume)
            } else if measurementMethod! == .weight {
                return try self.scale(by: multiplier, measurementSystemMethod: .metricWeight)
            }
        }
        
        return measurement
    }
    
    /// Wrapper for scale(by:measurementSystem:measurementMethod)
    public func scale(with parameters: ScaleParameters) throws -> MiseEnPlace.Measurement {
        return try self.scale(by: parameters.multiplier, measurementSystem: parameters.measurementSystem, measurementMethod: parameters.measurementMethod)
    }
}

fileprivate struct EachConvertable: Convertable {
    var measurement: MiseEnPlace.Measurement
    var ratio: Ratio
    var eachMeasurement: MiseEnPlace.Measurement?
    
    init?(convertable: Convertable) {
        guard let em = convertable.eachMeasurement else {
            return nil
        }
        
        self.measurement = MiseEnPlace.Measurement(amount: convertable.measurement.amount * em.amount, unit: em.unit)
        self.ratio = convertable.ratio
    }
}
