import Foundation

/// A measurement as it relates to an `Ingredient` or `Recipe`.
///
/// ## Required Conformance
///
/// ```swift
/// // The `Recipe` that uses this as part of it's `formulaElements`.
/// var inverseRecipe: Recipe? { get set }
///
/// // The `Ingredient` or `Recipe` to which this measurement relates.
/// var measured: Measured { get set }
/// ```
///
/// ## Protocol Conformance
///
/// `Unique`
/// ```swift
/// var uuid: String { get set }
/// var creationDate: Date { get set }
/// var modificationDate: Date { get set }
/// ```
///
/// `Sequenced`
/// ```swift
/// var sequence: Int { get set }
/// ```
///
/// `Quantifiable`
/// ```swift
/// var amount: Double { get set }
/// var unit: MeasurementUnit { get set }
/// ```
///
public protocol FormulaElement: Unique, Sequenced, Quantifiable {
    var inverseRecipe: Recipe? { get set }
    var measured: Measured { get set }
}

public extension FormulaElement {
    @available(*, deprecated, renamed: "measured")
    var ingredient: Ingredient? {
        get {
            if case let .ingredient(value) = measured {
                return value
            } else {
                return nil
            }
        }
        set {
            if let value = newValue {
                measured = .ingredient(value)
            }
        }
    }
    
    @available(*, deprecated, renamed: "measured")
    var recipe: Recipe? {
        get {
            if case let .recipe(value) = measured {
                return value
            } else {
                return nil
            }
        }
        set {
            if let value = newValue {
                measured = .recipe(value)
            }
        }
    }
}

public extension FormulaElement {
    /// The name for the referenced `Ingredient` or `Recipe`
    var name: String? {
        switch measured {
        case .ingredient(let ingredient): return ingredient.name
        case .recipe(let recipe): return recipe.name
        }
    }
    
    /// Indicates when this `FormulaElement` references an `Ingredient`
    var isMeasuredIngredient: Bool { measured.ingredient != nil }
    
    /// Indicates when this `FormulaElement` references an `Recipe`
    var isMeasuredRecipe: Bool { measured.recipe != nil }
    
    /// Translates the measurement to a different unit.
    ///
    /// If attempting to convert from/to a '.noUnit' `MeasurementUnit`, and error will be thrown.
    ///
    /// - parameter destinationUnit: The unit to convert to.
    /// - throws: `MiseEnPlaceError`
    func amount(for destinationUnit: MeasurementUnit) throws -> Double {
        guard unit != .noUnit else {
            throw MiseEnPlaceError.unhandledConversion
        }
        
        guard destinationUnit != .noUnit else {
            throw MiseEnPlaceError.unhandledConversion
        }
        
        guard amount > 0.0 else {
            throw MiseEnPlaceError.measurementAmount(method: nil)
        }
        
        switch measured {
        case .ingredient(let ingredient):
            switch (unit.measurementSystemMethod, destinationUnit.measurementSystemMethod) {
            case (.numericQuantity, .numericQuantity):
                return amount
            case (.numericQuantity, .usVolume), (.numericQuantity, .usWeight), (.numericQuantity, .metricVolume), (.numericQuantity, .metricWeight):
                let quantifiableMeasurement = ingredient.quantification
                let equivalentMeasurement = Quantification(amount: quantifiableMeasurement.amount * amount, unit: quantifiableMeasurement.unit)
                let equivalentAmount = try equivalentMeasurement.amount(for: destinationUnit, ratio: ingredient.ratio)
                return equivalentAmount
            case (.usVolume, .numericQuantity), (.usWeight, .numericQuantity), (.metricVolume, .numericQuantity), (.metricWeight, .numericQuantity):
                let quantifiableMeasurement = ingredient.quantification
                let equivalentAmount = try quantification.amount(for: quantifiableMeasurement.unit, ratio: ingredient.ratio)
                return equivalentAmount / quantifiableMeasurement.amount
            case (.usVolume, .usVolume), (.usWeight, .usWeight), (.metricVolume, .metricVolume), (.metricWeight, .metricWeight):
                return try quantification.amount(for: destinationUnit)
            default:
                return try quantification.amount(for: destinationUnit, ratio: ingredient.ratio)
            }
        case .recipe(let recipe):
            let measuredAmount = recipe.totalAmount(for: unit)
            let percent = amount / measuredAmount
            
            let destinationAmount = recipe.totalAmount(for: destinationUnit)
            return destinationAmount * percent
        }
    }
    
    /// Scales the 'measured' amount of either the `ingredient` or `recipe`.
    ///
    /// - parameter multiplier:
    /// - parameter measurementSystem:
    /// - parameter measurementMethod:
    /// - throws: `MiseEnPlaceError`
    func scale(by multiplier: Double, measurementSystem: MeasurementSystem? = nil, measurementMethod: MeasurementMethod? = nil) throws -> Quantification {
        if quantification == .notQuantified || quantification == .asNeeded {
            return quantification
        }
        
        guard (!amount.isNaN && !amount.isInfinite) && amount > 0.0 else {
            throw MiseEnPlaceError.nanZeroConversion
        }
        
        if unit == .noUnit && measurementSystem == nil && measurementMethod == nil {
            return quantification.with(amount: amount * multiplier)
        }
        
        switch measured {
        case .ingredient(let ingredient):
            let scaledQuantification: Quantification
            
            switch (unit, measurementSystem, measurementMethod) {
            case (_, .none, .none), (.noUnit, .numeric, .quantity):
                return Quantification(amount: amount * multiplier, unit: unit)
            case (_, .numeric, .quantity):
                guard ingredient.unit.isQuantifiable else {
                    throw MiseEnPlaceError.quantifiableConversion
                }
                
                let eachUnitTotalAmount = try amount(for: ingredient.eachQuantification.unit)
                let scaledEachTotalAmount = eachUnitTotalAmount / ingredient.eachQuantification.amount
                return Quantification(amount: scaledEachTotalAmount, unit: .noUnit)
            case (.noUnit, _, _):
                guard ingredient.unit.isQuantifiable else {
                    throw MiseEnPlaceError.quantifiableConversion
                }
                
                let quantifiableMeasurement = ingredient.quantification
                scaledQuantification = Quantification(amount: quantifiableMeasurement.amount * amount, unit: quantifiableMeasurement.unit)
            default:
                let totalAmount = try amount(for: unit)
                scaledQuantification = Quantification(amount: totalAmount * multiplier, unit: unit)
            }
            
            let ms = measurementSystem ?? scaledQuantification.unit.measurementSystem
            let mm = measurementMethod ?? scaledQuantification.unit.measurementMethod
            
            guard let measurementSystemMethod = MeasurementSystemMethod.measurementSystemMethod(for: ms, measurementMethod: mm) else {
                return try scaledQuantification.normalizedQuantification()
            }
            
            let translatedQuantification = try scaledQuantification.quantification.requantify(in: measurementSystemMethod, ratio: ingredient.ratio)
            return try translatedQuantification.normalizedQuantification()
        case .recipe(let recipe):
            let scaledQuantification: Quantification
            
            if unit == .noUnit {
                guard recipe.unit.isQuantifiable else {
                    throw MiseEnPlaceError.quantifiableConversion
                }
                
                var totalMeasurement = recipe.totalQuantification
                totalMeasurement.amount = totalMeasurement.amount * multiplier
                
                scaledQuantification = totalMeasurement
            } else {
                let totalAmount = recipe.totalAmount(for: unit)
                let percent = amount / totalAmount
                scaledQuantification = Quantification(amount: (totalAmount * percent * multiplier), unit: unit)
            }
            
            let ms = measurementSystem ?? scaledQuantification.unit.measurementSystem
            let mm = measurementMethod ?? scaledQuantification.unit.measurementMethod
            
            guard let measurementSystemMethod = MeasurementSystemMethod.measurementSystemMethod(for: ms, measurementMethod: mm) else {
                return try scaledQuantification.normalizedQuantification()
            }
            
            let translatedQuantification = try scaledQuantification.quantification.requantify(in: measurementSystemMethod, ratio: .oneToOne)
            return try translatedQuantification.normalizedQuantification()
        }
    }
}
