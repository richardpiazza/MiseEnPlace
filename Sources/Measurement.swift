import Foundation

/// # Measurement
///
/// A `Measured` amount and unit pairing.
///
/// ## Protocol Conformance
///
/// _Measured_
/// ```swift
/// var amount: Double { get set }
/// var unit: MeasurementUnit { get set }
/// ```
///
public struct Measurement: Measured {
    public var amount: Double = 0.0
    public var unit: MeasurementUnit = .each
    
    public init() {
    }
    
    public init(amount: Double, unit: MeasurementUnit) {
        self.amount = amount
        self.unit = unit
    }

    public init(measured: Measured) {
        self.amount = measured.amount
        self.unit = measured.unit
    }
}

public extension Measurement {
    /// Converts an amount from one `MeasurementUnit` to another `MeasurementUnit`
    /// within the same `MeasurementSystemMethod`
    ///
    /// - parameter unit: The `MeasurementUnit` to convert to.
    ///
    /// - throws: ConversionError.unhandled
    ///
    public func amount(for unit: MeasurementUnit) throws -> Double {
        let measurementUnits = MeasurementUnit.measurementUnits(forMeasurementSystemMethod: unit.measurementSystemMethod)
        guard measurementUnits.contains(self.unit) else {
            throw Error.unhandledConversion
        }
        
        var currentIndex = -1
        var goalIndex = -1
        
        for (index, mu) in measurementUnits.enumerated() {
            if mu == self.unit {
                currentIndex = index
            }
            if mu == unit {
                goalIndex = index
            }
        }
        
        guard currentIndex != goalIndex else {
            return self.amount
        }
        
        var stepDirection = 0
        var nextValue = self.amount
        
        if goalIndex - currentIndex > 0 {
            stepDirection = 1
            nextValue = self.amount * self.unit.stepUpMultiplier
        } else {
            stepDirection = -1
            nextValue = self.amount / self.unit.stepDownMultiplier
        }
        
        let nextIndex = currentIndex + stepDirection
        let nextUnit = measurementUnits[nextIndex]
        
        return try MiseEnPlace.Measurement(amount: nextValue, unit: nextUnit).amount(for: unit)
    }
    
    public func measurement(matching measurementSystem: MeasurementSystem, measurementMethod: MeasurementMethod) throws -> MiseEnPlace.Measurement {
        guard self.unit != .asNeeded else {
            throw Error.asNeededConversion
        }
        
        guard self.amount > 0.0 else {
            throw Error.measurementAmount(method: nil)
        }
        
        guard let msm = MeasurementSystemMethod.measurementSystemMethod(for: measurementSystem, measurementMethod: measurementMethod) else {
            throw Error.unhandledConversion
        }
        
        let units = Array(MeasurementUnit.measurementUnits(forMeasurementSystemMethod: msm).reversed())
        for unit in units {
            let unitAmount = try self.amount(for: unit)
            if unitAmount >= unit.stepDownThreshold {
                return MiseEnPlace.Measurement(amount: unitAmount, unit: unit)
            }
        }
        
        throw Error.unhandledConversion
    }
}

public extension Measurement {
    /// Returns this `Measurement` in terms of the current `MeasurementUnit` and
    /// the next smallest `MeasurementUnit` if needed.
    public var components: [MiseEnPlace.Measurement] {
        guard unit != .asNeeded && unit != .each else {
            return [self]
        }
        
        let decomposedAmount = modf(amount)
        if decomposedAmount.1 == 0.0 {
            return [self]
        }
        
        var components = [MiseEnPlace.Measurement]()
        
        switch unit {
        case .kilogram, .liter, .pound, .tablespoon, .teaspoon, .fluidOunce, .cup, .pint, .quart, .gallon:
            if decomposedAmount.0 != 0 {
                components.append(MiseEnPlace.Measurement(amount: decomposedAmount.0, unit: unit))
            }
            
            if let stepDownUnit = unit.stepDownUnit, decomposedAmount.1 < unit.stepDownThreshold {
                let measurement = MiseEnPlace.Measurement(amount: decomposedAmount.1, unit: unit)
                var stepDownMeasurementAmount = 0.0
                do {
                    stepDownMeasurementAmount = try measurement.amount(for: stepDownUnit)
                } catch {
                    print(error)
                }
                components.append(MiseEnPlace.Measurement(amount: stepDownMeasurementAmount, unit: stepDownUnit))
            } else {
                components.append(MiseEnPlace.Measurement(amount: decomposedAmount.1, unit: unit))
            }
        default:
            components.append(self)
        }
        
        return components
    }
    
    /// Returns a "human-readable" form of this `Measurement`.
    public var translation: String {
        return translation(abbreviated: MiseEnPlace.Configuration.abbreviateTranslations)
    }
    
    /// Returns a "human-readable" form of this `Measurement` with the option to 
    /// force abbreviations.
    public func translation(abbreviated: Bool) -> String {
        switch unit {
        case .asNeeded:
            return unit.name(abbreviated: abbreviated)
        case .gram, .kilogram, .milliliter, .liter:
            return metricTranslation(abbreviated: abbreviated)
        default:
            return fractionTranslation(abbreviated: abbreviated)
        }
    }
    
    /// Returns a "human-readable" form of the componentized `Measurement`.
    public var componentsTranslation: String {
        return componentsTranslation(abbreviated: MiseEnPlace.Configuration.abbreviateTranslations)
    }
    
    /// Returns a "human-readable" form of the componentized `Measurement` with the
    /// option to force abbreviations.
    public func componentsTranslation(abbreviated: Bool) -> String {
        guard unit != .asNeeded && unit != .each else {
            return translation(abbreviated: abbreviated)
        }
        
        var interpretation = ""
        var units = [MeasurementUnit]()
        
        let components = self.components
        for component in components {
            units.append(component.unit)
            
            if interpretation.isEmpty {
                interpretation = component.translation(abbreviated: abbreviated)
            } else {
                let interpretationExtension = " \(component.translation(abbreviated: abbreviated))"
                interpretation += interpretationExtension
            }
        }
        
        guard units.count > 1 else {
            return interpretation
        }
        
        let uniqueUnits = Array(Set(units))
        guard uniqueUnits.count == 1 else {
            return interpretation
        }
        
        guard let firstUnit = uniqueUnits.first else {
            return interpretation
        }
        
        let unitName = " \(firstUnit.name(abbreviated: abbreviated))"
        
        return interpretation.replacingOccurrencesExceptLast(unitName, with: "")
    }
    
    private func metricTranslation(abbreviated: Bool) -> String {
        let unitName = unit.name(abbreviated: abbreviated)
        
        let decomposedAmount = modf(amount)
        if decomposedAmount.0 < 10.0 {
            if decomposedAmount.1 == 0.0 {
                return "\(Int(amount)) \(unitName)"
            } else {
                guard let singleDecimal = Configuration.singleDecimalFormatter.string(from: NSNumber(value: amount)) else {
                    return "\(amount) \(unitName)"
                }
                
                return "\(singleDecimal) \(unitName)"
            }
        } else if decomposedAmount.0 < 100.0 {
            if unit.shouldRoundWhenTranslated {
                return "\(Int(round(amount))) \(unitName)"
            } else {
                return "\(Int(amount)) \(unitName)"
            }
        } else {
            if unit.shouldRoundWhenTranslated {
                return "\(Int(round(amount / 5) * 5)) \(unitName)"
            } else {
                return "\(Int(amount)) \(unitName)"
            }
        }
    }
    
    private func fractionTranslation(abbreviated: Bool) -> String {
        let unitName = unit.name(abbreviated: abbreviated)
        
        let decomposedAmount = modf(amount)
        guard decomposedAmount.1 > 0.0 else {
            return "\(Int(amount)) \(unitName)"
        }
        
        let intergral = Int(decomposedAmount.0)
        let fraction = Fraction(closestValue: decomposedAmount.1)
        
        switch fraction {
        case .one:
            return "\(Int(intergral + 1)) \(unitName)"
        case .zero:
            if intergral == 0 {
                guard let significantAmount = Configuration.significantDigitFormatter.string(from: NSNumber(value: amount)) else {
                    return "\(amount) \(unitName)"
                }
                
                return "\(significantAmount) \(unitName)"
            } else {
                return "\(intergral) \(unitName)"
            }
        default:
            if intergral == 0 {
                return "\(fraction.stringValue) \(unitName)"
            } else {
                return "\(intergral)\(fraction.stringValue) \(unitName)"
            }
        }
    }
}
