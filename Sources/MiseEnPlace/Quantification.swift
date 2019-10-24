import Foundation

/// An amount and unit pairing.
///
/// ## Protocol Conformance
///
/// `Quantifiable`
/// ```swift
/// var amount: Double { get set }
/// var unit: MeasurementUnit { get set }
/// ```
///
public struct Quantification: Quantifiable, Equatable {
    
    public var amount: Double = 0.0
    public var unit: MeasurementUnit = .each
    
    public init() {
    }
    
    public init(amount: Double, unit: MeasurementUnit) {
        self.amount = amount
        self.unit = unit
    }
    
    public init(quantifiable: Quantifiable) {
        self.amount = quantifiable.amount
        self.unit = quantifiable.unit
    }
    
    public static func == (lhs: Quantification, rhs: Quantification) -> Bool {
        guard lhs.amount == rhs.amount else {
            return false
        }
        
        guard lhs.unit == rhs.unit else {
            return false
        }
        
        return true
    }
}

public extension Quantification {
    /// Converts an amount from one `MeasurementUnit` to another `MeasurementUnit`
    /// within the same `MeasurementSystemMethod`
    ///
    /// - parameter unit: The `MeasurementUnit` to convert to.
    /// - parameter conversionMultiplier: A multipler used to convert between measurement systems & methods.
    ///
    /// - throws: Error.measurementAmount(), Error.measurementUnit()
    ///
    func amount(for unit: MeasurementUnit, conversionMultiplier: Double? = nil) throws -> Double {
        guard self.amount > 0.0 else {
            throw MiseEnPlaceError.measurementAmount(method: nil)
        }
        
        guard self.unit.measurementSystemMethod != .numericQuantity else {
            throw MiseEnPlaceError.measurementUnit(method: nil)
        }
        
        guard unit.measurementSystemMethod != .numericQuantity else {
            throw MiseEnPlaceError.measurementUnit(method: nil)
        }
        
        guard self.unit.measurementSystemMethod == unit.measurementSystemMethod else {
            guard let multiplier = conversionMultiplier else {
                throw MiseEnPlaceError.measurementUnit(method: nil)
            }
            
            // Translate to the desired unit
            // First: `MeasurementSystem`
            // Than: `MeasurementMethod`
            
            switch self.unit.measurementSystemMethod {
            case .usVolume:
                let fluidOunce = try quantification.amount(for: .fluidOunce)
                
                switch unit.measurementSystemMethod {
                case .usWeight:
                    let ounce = fluidOunce * multiplier
                    return try Quantification(amount: ounce, unit: .ounce).amount(for: unit)
                case .metricVolume:
                    let milliliter = fluidOunce * Configuration.fluidOunceMilliliter
                    return try Quantification(amount: milliliter, unit: .milliliter).amount(for: unit)
                case .metricWeight:
                    let milliliter = fluidOunce * Configuration.fluidOunceMilliliter
                    let gram = milliliter * multiplier
                    return try Quantification(amount: gram, unit: .gram).amount(for: unit)
                default:
                    break
                }
            case .usWeight:
                let ounce = try quantification.amount(for: .ounce)
                
                switch unit.measurementSystemMethod {
                case .usVolume:
                    let fluidOunce = ounce * multiplier
                    return try Quantification(amount: fluidOunce, unit: .fluidOunce).amount(for: unit)
                case .metricVolume:
                    let gram = ounce * Configuration.ounceGram
                    let milliliter = gram * multiplier
                    return try Quantification(amount: milliliter, unit: .milliliter).amount(for: unit)
                case .metricWeight:
                    let gram = ounce * Configuration.ounceGram
                    return try Quantification(amount: gram, unit: .gram).amount(for: unit)
                default:
                    break
                }
            case .metricVolume:
                let milliliter = try quantification.amount(for: .milliliter)
                
                switch unit.measurementSystemMethod {
                case .metricWeight:
                    let gram = milliliter * multiplier // * ?? /
                    return try Quantification(amount: gram, unit: .gram).amount(for: unit)
                case .usVolume:
                    let fluidOunce = milliliter / Configuration.fluidOunceMilliliter
                    return try Quantification(amount: fluidOunce, unit: .fluidOunce).amount(for: unit)
                case .usWeight:
                    let fluidOunce = milliliter / Configuration.fluidOunceMilliliter
                    let ounce = fluidOunce * multiplier
                    return try Quantification(amount: ounce, unit: .ounce).amount(for: unit)
                default:
                    break
                }
            case .metricWeight:
                let gram = try quantification.amount(for: .gram)
                
                switch unit.measurementSystemMethod {
                case .metricVolume:
                    let milliliter = gram * multiplier // * ?? /
                    return try Quantification(amount: milliliter, unit: .milliliter).amount(for: unit)
                case .usVolume:
                    let ounce = gram / Configuration.ounceGram
                    let fluidOunce = ounce * multiplier
                    return try Quantification(amount: fluidOunce, unit: .fluidOunce).amount(for: unit)
                case .usWeight:
                    let ounce = gram / Configuration.ounceGram
                    return try Quantification(amount: ounce, unit: .ounce).amount(for: unit)
                default:
                    break
                }
            default:
                break
            }
            
            throw MiseEnPlaceError.measurementUnit(method: nil)
        }
        
        var currentIndex = -1
        var goalIndex = -1
        
        let measurementUnits = MeasurementUnit.measurementUnits(forMeasurementSystemMethod: unit.measurementSystemMethod)
        
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
        
        return try Quantification(amount: nextValue, unit: nextUnit).amount(for: unit)
    }
    
    /// Calculates the best matching measurement amount and unit that matches the
    /// current `unit` `MeasurementSystemMethod`.
    ///
    /// - throws: Error.measurementAmount(), Error.measurementUnit(), Error.unhandledConversion
    ///
    func normalizedMeasurement() throws -> Quantification {
        guard self.amount > 0.0 else {
            throw MiseEnPlaceError.measurementAmount(method: nil)
        }
        
        guard self.unit.measurementSystemMethod != .numericQuantity else {
            throw MiseEnPlaceError.measurementUnit(method: nil)
        }
        
        let units = Array(MeasurementUnit.measurementUnits(forMeasurementSystemMethod: self.unit.measurementSystemMethod).reversed())
        for unit in units {
            let unitAmount = try self.amount(for: unit)
            if unitAmount >= unit.stepDownThreshold {
                return Quantification(amount: unitAmount, unit: unit)
            }
        }
        
        throw MiseEnPlaceError.unhandledConversion
    }
    
    /// Returns this `Measurement` in terms of the current `MeasurementUnit` and
    /// the next smallest `MeasurementUnit` if needed.
    var components: [Quantification] {
        guard unit != .asNeeded && unit != .each else {
            return [self]
        }
        
        let decomposedAmount = modf(amount)
        if decomposedAmount.1 == 0.0 {
            return [self]
        }
        
        var components = [Quantification]()
        
        switch unit {
        case .kilogram, .liter, .pound, .tablespoon, .teaspoon, .fluidOunce, .cup, .pint, .quart, .gallon:
            if decomposedAmount.0 != 0.0 {
                components.append(Quantification(amount: decomposedAmount.0, unit: unit))
            }
            
            if let stepDownUnit = unit.stepDownUnit, decomposedAmount.1 < unit.stepDownThreshold {
                let measurement = Quantification(amount: decomposedAmount.1, unit: unit)
                var stepDownMeasurementAmount = 0.0
                do {
                    stepDownMeasurementAmount = try measurement.amount(for: stepDownUnit)
                } catch {
                    print(error)
                }
                components.append(Quantification(amount: stepDownMeasurementAmount, unit: stepDownUnit))
            } else {
                components.append(Quantification(amount: decomposedAmount.1, unit: unit))
            }
        default:
            components.append(self)
        }
        
        return components
    }
    
    /// Returns a "human-readable" form of this `Measurement`.
    var translation: String {
        return translation(abbreviated: Configuration.abbreviateTranslations)
    }
    
    /// Returns a "human-readable" form of this `Measurement` with the option to
    /// force abbreviations.
    func translation(abbreviated: Bool) -> String {
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
    var componentsTranslation: String {
        return componentsTranslation(abbreviated: Configuration.abbreviateTranslations)
    }
    
    /// Returns a "human-readable" form of the componentized `Measurement` with the
    /// option to force abbreviations.
    func componentsTranslation(abbreviated: Bool) -> String {
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
}

private extension Quantification {
    func metricTranslation(abbreviated: Bool) -> String {
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
    
    func fractionTranslation(abbreviated: Bool) -> String {
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