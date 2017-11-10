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
            throw Error.asNeededConversion
        }
        
        if let _ = self.ingredient {
            return try self.ingredientAmount(for: unit)
        } else if let _ = self.recipe {
            return try self.recipeAmount(for: unit)
        }
        
        throw Error.unhandledConversion
    }
    
    private func ingredientAmount(for unit: MeasurementUnit) throws -> Double {
        guard self.unit != .asNeeded && unit != .asNeeded else {
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
            let multiplier = ingredient.multiplier(for: unit.measurementMethod)
            return try equivalentMeasurement.amount(for: unit, conversionMultiplier: multiplier)
        case (.usVolume, .numericQuantity), (.usWeight, .numericQuantity), (.metricVolume, .numericQuantity), (.metricWeight, .numericQuantity):
            let quantifiableMeasurement = ingredient.measurement
            let equivalentAmount = try self.ingredientAmount(for: quantifiableMeasurement.unit)
            return equivalentAmount / quantifiableMeasurement.amount
        case (.usVolume, .usVolume), (.usWeight, .usWeight), (.metricVolume, .metricVolume), (.metricWeight, .metricWeight):
            return try self.measurement.amount(for: unit)
        default:
            let multiplier: Double
            if self.unit.measurementMethod == .volume && unit.measurementMethod == .weight {
                multiplier = ingredient.multiplier(for: .volume)
            } else {
                multiplier = ingredient.multiplier(for: .weight)
            }
            return try self.measurement.amount(for: unit, conversionMultiplier: multiplier)
        }
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
        if let _ = self.ingredient {
            return try self.scaleIngredient(by: multiplier, measurementSystem: measurementSystem, measurementMethod: measurementMethod)
        } else if let _ = self.recipe {
            return try self.scaleRecipe(by: multiplier, measurementSystem: measurementSystem, measurementMethod: measurementMethod)
        }
        
        throw Error.unhandledConversion
    }
    
    private func scaleIngredient(by multiplier: Double, measurementSystem: MeasurementSystem? = nil, measurementMethod: MeasurementMethod? = nil) throws -> MiseEnPlace.Measurement {
        guard self.unit != .asNeeded else {
            throw Error.asNeededConversion
        }
        
        guard self.amount > 0.0 else {
            throw Error.measurementAmount(method: nil)
        }
        
        guard let ingredient = self.ingredient else {
            throw Error.unhandledConversion
        }
        
        if self.unit == .each {
            guard ingredient.unit.isQuantifiable else {
                throw Error.quantifiableConversion
            }
            
            let quantifiableMeasurement = ingredient.measurement
            let equivalentMeasurement = MiseEnPlace.Measurement(amount: quantifiableMeasurement.amount * self.amount, unit: quantifiableMeasurement.unit)
            
            let ms = measurementSystem ?? equivalentMeasurement.unit.measurementSystem
            let mm = measurementMethod ?? equivalentMeasurement.unit.measurementMethod
            
            return try equivalentMeasurement.normalizedMeasurement()
        }
        
        let totalAmount = try ingredientAmount(for: self.unit)
        let totalMeasurement = MiseEnPlace.Measurement(amount: totalAmount * self.amount, unit: self.unit)
        
        return try totalMeasurement.normalizedMeasurement()
    }
    
    private func scaleRecipe(by multiplier: Double, measurementSystem: MeasurementSystem? = nil, measurementMethod: MeasurementMethod? = nil) throws -> MiseEnPlace.Measurement {
        guard self.unit != .asNeeded else {
            throw Error.asNeededConversion
        }
        
        guard self.amount > 0.0 else {
            throw Error.measurementAmount(method: nil)
        }
        
        guard let recipe = self.recipe else {
            throw Error.unhandledConversion
        }
        
        if self.unit == .each {
            guard recipe.unit.isQuantifiable else {
                throw Error.quantifiableConversion
            }
            
            var totalMeasurement = recipe.totalMeasurement
            totalMeasurement.amount = totalMeasurement.amount * multiplier
            
            let ms = measurementSystem ?? totalMeasurement.unit.measurementSystem
            let mm = measurementMethod ?? totalMeasurement.unit.measurementMethod
            
            return try totalMeasurement.normalizedMeasurement()
        }
        
        let totalAmount = recipe.totalAmount(for: self.unit)
        let totalMeasurement = MiseEnPlace.Measurement(amount: totalAmount * self.amount, unit: self.unit)
        
        return try totalMeasurement.normalizedMeasurement()
    }
}
