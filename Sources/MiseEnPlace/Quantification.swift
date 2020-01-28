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
    /// A measurement typical of a 'small' portion size
    static var small: Quantification {
        return Configuration.locale.usesMetricSystem ? Quantification(amount: 100.0, unit: .gram) : Quantification(amount: 1.0, unit: .ounce)
    }

    /// A measurement typical of a 'large' portion size
    static var large: Quantification {
        return Configuration.locale.usesMetricSystem ? Quantification(amount: 1.0, unit: .kilogram) : Quantification(amount: 1.0, unit: .pound)
    }
}

public extension Quantification {
    /// Converts an amount from one `MeasurementUnit` to another `MeasurementUnit` within the same `MeasurementSystemMethod`.
    ///
    /// This is a recursive algorithm
    ///
    /// - parameter unit: The `MeasurementUnit` to convert to.
    /// - parameter ratio: A multipler used to convert between measurement systems & methods.
    /// - throws: `MiseEnPlaceError`
    func amount(for destinationUnit: MeasurementUnit, ratio: Ratio? = nil) throws -> Double {
        guard !amount.isNaN && amount > 0.0 else {
            throw MiseEnPlaceError.nanZeroConversion
        }
        
        guard unit.measurementSystemMethod != .numericQuantity else {
            throw MiseEnPlaceError.measurementUnit(method: nil)
        }
        
        guard destinationUnit.measurementSystemMethod != .numericQuantity else {
            throw MiseEnPlaceError.measurementUnit(method: nil)
        }
        
        if unit.measurementSystemMethod == destinationUnit.measurementSystemMethod {
            return try convertAmount(to: destinationUnit)
        }
        
        guard let ratio = ratio else {
            throw MiseEnPlaceError.measurementUnit(method: nil)
        }
        
        let quantification = try requantify(in: destinationUnit.measurementSystemMethod, ratio: ratio)
        return try quantification.convertAmount(to: destinationUnit)
    }
    
    /// Calculates the best matching measurement amount and unit that matches the
    /// current `unit` `MeasurementSystemMethod`.
    ///
    /// - throws: Error.measurementAmount(), Error.measurementUnit(), Error.unhandledConversion
    ///
    func normalizedMeasurement() throws -> Quantification {
        guard amount > 0.0 else {
            throw MiseEnPlaceError.measurementAmount(method: nil)
        }
        
        guard unit.measurementSystemMethod != .numericQuantity else {
            throw MiseEnPlaceError.measurementUnit(method: nil)
        }
        
        let units = Array(MeasurementUnit.measurementUnits(forMeasurementSystemMethod: unit.measurementSystemMethod).reversed())
        for u in units {
            let unitAmount = try amount(for: u)
            if unitAmount >= u.stepDownThreshold {
                return Quantification(amount: unitAmount, unit: u)
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

internal extension Quantification {
    /// Re-quantifies this `Quantification` in terms of another `MeasurementSytemMethod`.
    ///
    /// Recursive algorithm. The output from the requantification may not be in the final unit desired. See `convertAmount(to:)` for more infromation.
    ///
    /// - parameter destinationMeasurementSystemMethod: The output `MeasurementSystemMethod`
    /// - parameter ratio: Ratio used during measurement method calculations (i.e. weight > volume / volume > weight)
    /// - parameter methodFirst: [default true] Determines the order of operations. Wether `MeasurementMethod` or `MeasurementSystem`
    ///                             calculations are performed before the other.
    /// - throws: `MiseEnPlaceError`
    func requantify(in destinationMeasurementSystemMethod: MeasurementSystemMethod, ratio: Ratio) throws -> Quantification {
        guard unit.measurementSystemMethod != destinationMeasurementSystemMethod else {
            return self
        }
        
        switch (unit.measurementSystemMethod, destinationMeasurementSystemMethod) {
        case (.usVolume, .usWeight):
            let fluidOunce = try convertAmount(to: .fluidOunce)
            let ounce = fluidOunce * ratio.multiplier(converting: .volume, to: .weight)
            return Quantification(amount: ounce, unit: .ounce)
        case (.usVolume, .metricVolume):
            let fluidOunce = try convertAmount(to: .fluidOunce)
            let milliliter = fluidOunce * Configuration.millilitersPerFluidOunce
            return Quantification(amount: milliliter, unit: .milliliter)
        case (.usVolume, .metricWeight):
            switch Configuration.conversionOrder {
            case .methodThanSystem:
                let fluidOunce = try convertAmount(to: .fluidOunce)
                let ounce = fluidOunce * ratio.multiplier(converting: .volume, to: .weight)
                return try Quantification(amount: ounce, unit: .ounce).requantify(in: destinationMeasurementSystemMethod, ratio: ratio)
            case .systemThanMethod:
                let fluidOunce = try convertAmount(to: .fluidOunce)
                let milliliter = fluidOunce * Configuration.millilitersPerFluidOunce
                return try Quantification(amount: milliliter, unit: .milliliter).requantify(in: destinationMeasurementSystemMethod, ratio: ratio)
            }
        case (.usWeight, .usVolume):
            let ounce = try convertAmount(to: .ounce)
            let fluidOunce = ounce * ratio.multiplier(converting: .weight, to: .volume)
            return Quantification(amount: fluidOunce, unit: .fluidOunce)
        case (.usWeight, .metricVolume):
            switch Configuration.conversionOrder {
            case .methodThanSystem:
                let ounce = try convertAmount(to: .ounce)
                let fluidOunce = ounce * ratio.multiplier(converting: .weight, to: .volume)
                return try Quantification(amount: fluidOunce, unit: .fluidOunce).requantify(in: destinationMeasurementSystemMethod, ratio: ratio)
            case .systemThanMethod:
                let ounce = try convertAmount(to: .ounce)
                let gram = ounce * Configuration.gramsPerOunce
                return try Quantification(amount: gram, unit: .gram).requantify(in: destinationMeasurementSystemMethod, ratio: ratio)
            }
        case (.usWeight, .metricWeight):
            let ounce = try convertAmount(to: .ounce)
            let gram = ounce * Configuration.gramsPerOunce
            return Quantification(amount: gram, unit: .gram)
        case (.metricVolume, .metricWeight):
            let milliliter = try convertAmount(to: .milliliter)
            let gram = milliliter * ratio.multiplier(converting: .volume, to: .weight)
            return Quantification(amount: gram, unit: .gram)
        case (.metricVolume, .usVolume):
            let milliliter = try convertAmount(to: .milliliter)
            let fluidOunce = milliliter / Configuration.millilitersPerFluidOunce
            return Quantification(amount: fluidOunce, unit: .fluidOunce)
        case (.metricVolume, .usWeight):
            switch Configuration.conversionOrder {
            case .methodThanSystem:
                let milliliter = try convertAmount(to: .milliliter)
                let gram = milliliter * ratio.multiplier(converting: .volume, to: .weight)
                return try Quantification(amount: gram, unit: .gram).requantify(in: destinationMeasurementSystemMethod, ratio: ratio)
            case .systemThanMethod:
                let milliliter = try convertAmount(to: .milliliter)
                let fluidOunce = milliliter / Configuration.millilitersPerFluidOunce
                return try Quantification(amount: fluidOunce, unit: .fluidOunce).requantify(in: destinationMeasurementSystemMethod, ratio: ratio)
            }
        case (.metricWeight, .metricVolume):
            let gram = try convertAmount(to: .gram)
            let milliliter = gram * ratio.multiplier(converting: .weight, to: .volume)
            return Quantification(amount: milliliter, unit: .milliliter)
        case (.metricWeight, .usVolume):
            switch Configuration.conversionOrder {
            case .methodThanSystem:
                let gram = try convertAmount(to: .gram)
                let milliliter = gram * ratio.multiplier(converting: .weight, to: .volume)
                return try Quantification(amount: milliliter, unit: .milliliter).requantify(in: destinationMeasurementSystemMethod, ratio: ratio)
            case .systemThanMethod:
                let gram = try convertAmount(to: .gram)
                let ounce = gram / Configuration.gramsPerOunce
                return try Quantification(amount: ounce, unit: .ounce).requantify(in: destinationMeasurementSystemMethod, ratio: ratio)
            }
        case (.metricWeight, .usWeight):
            let gram = try convertAmount(to: .gram)
            let ounce = gram / Configuration.gramsPerOunce
            return Quantification(amount: ounce, unit: .ounce)
        default:
            break
        }
        
        throw MiseEnPlaceError.measurementUnit(method: nil)
    }
}

private extension Quantification {
    /// Converts the amount to another `MeasurementUnit` within the same `MeasurementSystemMethod`.
    ///
    /// - parameter unit: The `MeasurementUnit` to convert to.
    /// - throws: `MiseEnPlaceError`
    func convertAmount(to destinationUnit: MeasurementUnit) throws -> Double {
        guard !amount.isNaN && amount > 0.0 else {
            throw MiseEnPlaceError.nanZeroConversion
        }
        
        guard unit.measurementSystemMethod == destinationUnit.measurementSystemMethod else {
            throw MiseEnPlaceError.unhandledConversion
        }
        
        var currentIndex = -1
        var goalIndex = -1
        
        let measurementUnits = MeasurementUnit.measurementUnits(forMeasurementSystemMethod: destinationUnit.measurementSystemMethod)
        
        for (index, measurementUnit) in measurementUnits.enumerated() {
            if measurementUnit == unit {
                currentIndex = index
            }
            if measurementUnit == destinationUnit {
                goalIndex = index
            }
        }
        
        guard currentIndex != goalIndex else {
            return amount
        }
        
        var stepDirection = 0
        var nextValue = amount
        
        if goalIndex - currentIndex > 0 {
            stepDirection = 1
            nextValue = amount * unit.stepUpMultiplier
        } else {
            stepDirection = -1
            nextValue = amount / unit.stepDownMultiplier
        }
        
        let nextIndex = currentIndex + stepDirection
        let nextUnit = measurementUnits[nextIndex]
        
        return try Quantification(amount: nextValue, unit: nextUnit).convertAmount(to: destinationUnit)
    }
    
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
