import Foundation

/// An amount and unit pairing.
public struct Quantification: Equatable, CustomStringConvertible {

    public var amount: Double
    public var unit: MeasurementUnit

    public init(
        amount: Double = 0.0,
        unit: MeasurementUnit = .noUnit
    ) {
        self.amount = amount
        self.unit = unit
    }

    public init(_ quantifiable: Quantifiable) {
        amount = quantifiable.amount
        unit = quantifiable.unit
    }

    @available(*, deprecated, renamed: "init(_:)")
    public init(quantifiable: Quantifiable) {
        amount = quantifiable.amount
        unit = quantifiable.unit
    }

    public var description: String {
        translation(abbreviated: Configuration.abbreviateTranslations)
    }
}

public extension Quantification {
    /// A representation usable for when a `Quantification` must be expressed,
    /// but the intent is to express the implicit lack-of-quantification.
    static let notQuantified: Quantification = .init(amount: 0.0, unit: .noUnit)

    /// A representation usable for when a `Quantification` must be expressed,
    /// but the amount is explicitly un-quantifiable.
    static let asNeeded: Quantification = .init(amount: -1.0, unit: .noUnit)

    /// A measurement typical of a 'small' portion size
    static var small: Quantification {
        Configuration.metricPreferred ? Quantification(amount: 100.0, unit: .gram) : Quantification(amount: 1.0, unit: .ounce)
    }

    /// A measurement typical of a 'large' portion size
    static var large: Quantification {
        Configuration.metricPreferred ? Quantification(amount: 1.0, unit: .kilogram) : Quantification(amount: 1.0, unit: .pound)
    }

    /// A measurement pair the represents a '1:1' ratio of volume to weight.
    static var equalRatio: (volume: Quantification, weight: Quantification) {
        if Configuration.metricPreferred {
            (Quantification(amount: 1.0, unit: .liter), Quantification(amount: 1000.0, unit: .gram))
        } else {
            (Quantification(amount: 1.0, unit: .cup), Quantification(amount: 8.0, unit: .ounce))
        }
    }
}

public extension Quantification {
    /// Converts an amount from one `MeasurementUnit` to another `MeasurementUnit` within the same `MeasurementSystemMethod`.
    ///
    /// This is a recursive algorithm
    ///
    /// - parameter unit: The `MeasurementUnit` to convert to.
    /// - parameter ratio: A multiplier used to convert between measurement systems & methods.
    /// - throws: `MiseEnPlaceError`
    func amount(for destinationUnit: MeasurementUnit, ratio: Ratio? = nil) throws -> Double {
        guard !amount.isNaN, !amount.isInfinite, amount > 0.0 else {
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

        guard let ratio else {
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
    func normalizedQuantification() throws -> Quantification {
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
        guard unit != .noUnit else {
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
    @available(*, deprecated, renamed: "description")
    var translation: String {
        description
    }

    /// Returns a "human-readable" form of this `Measurement` with the option to
    /// force abbreviations.
    func translation(abbreviated: Bool) -> String {
        if self == .notQuantified {
            return ""
        } else if self == .asNeeded {
            return "As Needed"
        }

        switch unit {
        case .noUnit:
            if Configuration.metricPreferred {
                return metricTranslation(abbreviated: abbreviated)
            } else {
                return fractionTranslation(abbreviated: abbreviated)
            }
        case .gram, .kilogram, .milliliter, .liter:
            return metricTranslation(abbreviated: abbreviated)
        default:
            return fractionTranslation(abbreviated: abbreviated)
        }
    }

    /// Returns a "human-readable" form of the componentized `Measurement`.
    var componentsTranslation: String {
        componentsTranslation(abbreviated: Configuration.abbreviateTranslations)
    }

    /// Returns a "human-readable" form of the componentized `Measurement` with the
    /// option to force abbreviations.
    func componentsTranslation(abbreviated: Bool) -> String {
        guard unit != .noUnit else {
            return translation(abbreviated: abbreviated)
        }

        var interpretation = ""
        var units = [MeasurementUnit]()

        let components = components
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

    func with(amount: Double) -> Quantification {
        Quantification(amount: amount, unit: unit)
    }

    func with(unit: MeasurementUnit) -> Quantification {
        Quantification(amount: amount, unit: unit)
    }
}

extension Quantification {
    /// Re-quantifies this `Quantification` in terms of another `MeasurementSystemMethod`.
    ///
    /// Recursive algorithm. The output from the re-quantification may not be in the final unit desired. See `convertAmount(to:)` for more information.
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
        guard !amount.isNaN, !amount.isInfinite, amount > 0.0 else {
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
        guard !amount.isNaN, !amount.isInfinite else {
            return "?"
        }

        let amountValue: String

        let decomposedAmount = modf(amount)
        if decomposedAmount.0 < 10.0 {
            if decomposedAmount.1 == 0.0 {
                amountValue = "\(Int(amount))"
            } else {
                if let singleDecimal = Configuration.singleDecimalFormatter.string(from: NSNumber(value: amount)) {
                    amountValue = "\(singleDecimal)"
                } else {
                    amountValue = "\(amount)"
                }
            }
        } else if decomposedAmount.0 < 100.0 {
            if unit.shouldRoundWhenTranslated {
                amountValue = "\(Int(round(amount)))"
            } else {
                amountValue = "\(Int(amount))"
            }
        } else {
            if unit.shouldRoundWhenTranslated {
                amountValue = "\(Int(round(amount / 5) * 5))"
            } else {
                amountValue = "\(Int(amount))"
            }
        }

        switch unit {
        case .noUnit:
            return amountValue
        default:
            return "\(amountValue) \(unit.name(abbreviated: abbreviated))"
        }
    }

    func fractionTranslation(abbreviated: Bool) -> String {
        guard !amount.isNaN, !amount.isInfinite else {
            return "?"
        }

        let amountValue: String

        let decomposedAmount = modf(amount)
        if decomposedAmount.1 == 0.0 {
            amountValue = "\(Int(amount))"
        } else {
            let integral = Int(decomposedAmount.0)
            let fraction = Fraction(proximateValue: decomposedAmount.1)

            switch fraction {
            case .one:
                amountValue = "\(Int(integral + 1))"
            case .zero:
                if integral == 0 {
                    if let significantAmount = Configuration.significantDigitFormatter.string(from: NSNumber(value: amount)) {
                        amountValue = "\(significantAmount)"
                    } else {
                        amountValue = "\(amount)"
                    }
                } else {
                    amountValue = "\(integral)"
                }
            default:
                if integral == 0 {
                    amountValue = "\(fraction.description)"
                } else {
                    amountValue = "\(integral)\(fraction.description)"
                }
            }
        }

        switch unit {
        case .noUnit:
            return amountValue
        default:
            return "\(amountValue) \(unit.name(abbreviated: abbreviated))"
        }
    }
}
