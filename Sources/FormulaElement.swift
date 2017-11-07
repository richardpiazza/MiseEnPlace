import Foundation

/// # FormulaElement
///
/// A measurement as it relates to an `Ingredient` or `Recipe`.
/// Could also be thought of as a 'MeasuredIngredient' or 'MeasuredRecipe'
/// Either the `ingredient` or `recipe` variable should be assigned.
///
/// ## Requied Conformance
///
/// ```swift
/// // The `Recipe` that uses this as part of it's `formulaElements`.
/// var inverseRecipe: Recipe? { get set }
///
/// // The `Ingredient` this measurement relates to.
/// var ingredient: Ingredient? { get set }
///
/// // The `Recipe` this measurement relates to.
/// var recipe: Recipe? { get set }
/// ```
///
/// ## Protocol Conformance
///
/// _Unique_
/// ```swift
/// var uuid: String { get set }
/// var creationDate: Date { get set }
/// var modificationDate: Date { get set }
/// ```
///
/// _Sequenced_
/// ```swift
/// var sequence: Int { get set }
/// ```
///
/// _Measured_
/// ```swift
/// var amount: Double { get set }
/// var unit: MeasurementUnit { get set }
/// ```
///
public protocol FormulaElement: Unique, Sequenced, Measured {
    var inverseRecipe: Recipe? { get set }
    var ingredient: Ingredient? { get set }
    var recipe: Recipe? { get set }
}

public extension FormulaElement {
    /// Translates the measurement to a different unit.
    /// Neither the self.unit nor specified unit can be .asNeeded.
    ///
    /// - parameter unit: The unit to convert to.
    ///
    /// - throws: Error.asNeededConversion, Error.measurementAmount(), Error.quantifiableConversion, Error.unhandledConversion
    public func amount(for unit: MeasurementUnit) throws -> Double {
        guard self.unit != .asNeeded else {
            return 0.0
        }
        
        if let _ = self.ingredient {
            return try self.ingredientAmount(for: unit)
        } else if let _ = self.recipe {
            return try self.recipeAmount(for: unit)
        }
        
        throw Error.unhandledConversion
    }
    
    private func ingredientAmount(for unit: MeasurementUnit) throws -> Double {
        guard self.unit != .asNeeded || unit != .asNeeded else {
            throw Error.asNeededConversion
        }
        
        guard self.amount > 0.0 else {
            throw Error.measurementAmount(method: nil)
        }
        
        guard let ingredient = self.ingredient else {
            throw Error.unhandledConversion
        }
        
        if (self.unit == .each || unit == .each) && !ingredient.measurement.unit.isQuantifiable {
            throw Error.quantifiableConversion
        }
        
        switch (self.unit.measurementSystemMethod, unit.measurementSystemMethod) {
        case (.numericQuantity, .numericQuantity):
            return self.amount
        case (.numericQuantity, .usVolume), (.numericQuantity, .usWeight), (.numericQuantity, .metricVolume), (.numericQuantity, .metricWeight):
            let quantifiableMeasurement = ingredient.measurement
            let equivalentMeasurement = MiseEnPlace.Measurement(amount: quantifiableMeasurement.amount * self.amount, unit: quantifiableMeasurement.unit)
            return try equivalentMeasurement.amount(for: unit)
        case (.usVolume, .numericQuantity), (.usWeight, .numericQuantity), (.metricVolume, .numericQuantity), (.metricWeight, .numericQuantity):
            let quantifiableMeasurement = ingredient.measurement
            let equivalentAmount = try self.ingredientAmount(for: quantifiableMeasurement.unit)
            return self.amount / equivalentAmount
        case (.usVolume, .usVolume), (.usWeight, .usWeight), (.metricVolume, .metricVolume), (.metricWeight, .metricWeight):
            return try self.measurement.amount(for: unit)
        default:
            break
        }
        
        switch self.unit.measurementSystemMethod {
        case .usVolume:
            let fluidOunce = try self.measurement.amount(for: .fluidOunce)
            let ounce = fluidOunce * ingredient.multiplier(for: self.unit.measurementMethod)
            let milliliter = fluidOunce * Configuration.fluidOunceMilliliter
            let gram = ounce * Configuration.ounceGram
            
            switch unit.measurementSystemMethod {
            case .usWeight:
                return try MiseEnPlace.Measurement(amount: ounce, unit: .ounce).amount(for: unit)
            case .metricVolume:
                return try MiseEnPlace.Measurement(amount: milliliter, unit: .milliliter).amount(for: unit)
            case .metricWeight:
                return try MiseEnPlace.Measurement(amount: gram, unit: .gram).amount(for: unit)
            default:
                break
            }
        case .usWeight:
            let ounce = try self.measurement.amount(for: .ounce)
            let fluidOunce = ounce * ingredient.multiplier(for: unit.measurementMethod)
            let milliliter = fluidOunce * Configuration.fluidOunceMilliliter
            let gram = ounce * Configuration.ounceGram
            
            switch unit.measurementSystemMethod {
            case .usVolume:
                return try MiseEnPlace.Measurement(amount: fluidOunce, unit: .fluidOunce).amount(for: unit)
            case .metricVolume:
                return try MiseEnPlace.Measurement(amount: milliliter, unit: .milliliter).amount(for: unit)
            case .metricWeight:
                return try MiseEnPlace.Measurement(amount: gram, unit: .gram).amount(for: unit)
            default:
                break
            }
        case .metricVolume:
            let milliliter = try self.measurement.amount(for: .milliliter)
            let gram = milliliter * ingredient.multiplier(for: unit.measurementMethod)
            let fluidOunce = milliliter / Configuration.fluidOunceMilliliter
            let ounce = gram / Configuration.ounceGram
            
            switch unit.measurementSystemMethod {
            case .metricWeight:
                return try MiseEnPlace.Measurement(amount: gram, unit: .gram).amount(for: unit)
            case .usVolume:
                return try MiseEnPlace.Measurement(amount: fluidOunce, unit: .fluidOunce).amount(for: unit)
            case .usWeight:
                return try MiseEnPlace.Measurement(amount: ounce, unit: .ounce).amount(for: unit)
            default:
                break
            }
        case .metricWeight:
            let gram = try self.measurement.amount(for: .gram)
            let milliliter = gram * ingredient.multiplier(for: unit.measurementMethod)
            let fluidOunce = milliliter / Configuration.fluidOunceMilliliter
            let ounce = gram / Configuration.ounceGram
            
            switch unit.measurementSystemMethod {
            case .metricVolume:
                return try MiseEnPlace.Measurement(amount: milliliter, unit: .milliliter).amount(for: unit)
            case .usVolume:
                return try MiseEnPlace.Measurement(amount: fluidOunce, unit: .fluidOunce).amount(for: unit)
            case .usWeight:
                return try MiseEnPlace.Measurement(amount: ounce, unit: .ounce).amount(for: unit)
            default:
                break
            }
        default:
            break
        }
        
        throw Error.unhandledConversion
    }
    
    private func recipeAmount(for unit: MeasurementUnit) throws -> Double {
        guard self.unit != .asNeeded || unit != .asNeeded else {
            throw Error.asNeededConversion
        }
        
        guard self.amount > 0.0 else {
            throw Error.measurementAmount(method: nil)
        }
        
        guard let recipe = self.recipe else {
            throw Error.unhandledConversion
        }
        
        if (self.unit == .each || unit == .each) && !recipe.measurement.unit.isQuantifiable {
            throw Error.quantifiableConversion
        }
        
        return recipe.totalAmount(for: unit)
    }
}

internal extension FormulaElement {
    internal func scale(by multiplier: Double, measurementSystem: MeasurementSystem? = nil, measurementMethod: MeasurementMethod? = nil) throws -> MiseEnPlace.Measurement {
        
        
        throw Error.unhandledConversion
    }
    
    private func scaleIngredient(by multiplier: Double, measurementSystem: MeasurementSystem? = nil, measurementMethod: MeasurementMethod? = nil) throws -> MiseEnPlace.Measurement {
        guard self.unit != .asNeeded || unit != .asNeeded else {
            throw Error.asNeededConversion
        }
        
        guard self.amount > 0.0 else {
            throw Error.measurementAmount(method: nil)
        }
        
        guard let ingredient = self.ingredient else {
            throw Error.unhandledConversion
        }
        
        if (self.unit == .each || unit == .each) && !ingredient.measurement.unit.isQuantifiable {
            throw Error.quantifiableConversion
        }
        
        throw Error.unhandledConversion
    }
    
    private func scaleRecipe(by multiplier: Double, measurementSystem: MeasurementSystem? = nil, measurementMethod: MeasurementMethod? = nil) throws -> MiseEnPlace.Measurement {
        guard self.unit != .asNeeded || unit != .asNeeded else {
            throw Error.asNeededConversion
        }
        
        guard self.amount > 0.0 else {
            throw Error.measurementAmount(method: nil)
        }
        
        guard let recipe = self.recipe else {
            throw Error.unhandledConversion
        }
        
        if (self.unit == .each || unit == .each) && !recipe.measurement.unit.isQuantifiable {
            throw Error.quantifiableConversion
        }
        
        
        
        throw Error.unhandledConversion
    }
}
