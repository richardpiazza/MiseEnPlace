import Foundation

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
    func amount(for unit: MeasurementUnit) throws -> Double {
        guard self.unit != .asNeeded else {
            throw MiseEnPlaceError.asNeededConversion
        }
        
        if let ingredient = self.ingredient {
            guard unit != .asNeeded else {
                throw MiseEnPlaceError.asNeededConversion
            }
            
            guard self.amount > 0.0 else {
                throw MiseEnPlaceError.measurementAmount(method: nil)
            }
            
            if (self.unit == .each || unit == .each) && !ingredient.quantification.unit.isQuantifiable {
                throw MiseEnPlaceError.quantifiableConversion
            }
            
            switch (self.unit.measurementSystemMethod, unit.measurementSystemMethod) {
            case (.numericQuantity, .numericQuantity):
                return self.amount
            case (.numericQuantity, .usVolume), (.numericQuantity, .usWeight), (.numericQuantity, .metricVolume), (.numericQuantity, .metricWeight):
                let quantifiableMeasurement = ingredient.quantification
                let equivalentMeasurement = Quantification(amount: quantifiableMeasurement.amount * self.amount, unit: quantifiableMeasurement.unit)
                let multiplier = ingredient.multiplier(from: self.unit.measurementMethod, to: unit.measurementMethod)
                let equivalentAmount = try equivalentMeasurement.amount(for: unit, conversionMultiplier: multiplier)
                return equivalentAmount
            case (.usVolume, .numericQuantity), (.usWeight, .numericQuantity), (.metricVolume, .numericQuantity), (.metricWeight, .numericQuantity):
                let quantifiableMeasurement = ingredient.quantification
                let multiplier = ingredient.multiplier(from: self.unit.measurementMethod, to: unit.measurementMethod)
                let equivalentAmount = try quantification.amount(for: quantifiableMeasurement.unit, conversionMultiplier: multiplier)
                return equivalentAmount / quantifiableMeasurement.amount
            case (.usVolume, .usVolume), (.usWeight, .usWeight), (.metricVolume, .metricVolume), (.metricWeight, .metricWeight):
                return try quantification.amount(for: unit)
            default:
                let multiplier: Double
                if self.unit.measurementMethod == .volume && unit.measurementMethod == .weight {
                    multiplier = ingredient.multiplier(for: .volume)
                } else {
                    multiplier = ingredient.multiplier(for: .weight)
                }
                return try quantification.amount(for: unit, conversionMultiplier: multiplier)
            }
        } else if let recipe = self.recipe {
            guard unit != .asNeeded else {
                throw MiseEnPlaceError.asNeededConversion
            }
            
            guard self.amount > 0.0 else {
                throw MiseEnPlaceError.measurementAmount(method: nil)
            }
            
            if (self.unit == .each || unit == .each) && !recipe.quantification.unit.isQuantifiable {
                throw MiseEnPlaceError.quantifiableConversion
            }
            
            return recipe.totalAmount(for: unit)
        }
        
        throw MiseEnPlaceError.unhandledConversion
    }
}

internal extension FormulaElement {
    func scale(by multiplier: Double, measurementSystem: MeasurementSystem? = nil, measurementMethod: MeasurementMethod? = nil) throws -> Quantification {
        guard self.unit != .asNeeded else {
            throw MiseEnPlaceError.asNeededConversion
        }
        
        guard self.amount > 0.0 else {
            throw MiseEnPlaceError.measurementAmount(method: nil)
        }
        
        if let ingredient = self.ingredient {
            if self.unit == .each {
                guard ingredient.unit.isQuantifiable else {
                    throw MiseEnPlaceError.quantifiableConversion
                }
                
                let quantifiableMeasurement = ingredient.quantification
                let equivalentMeasurement = Quantification(amount: quantifiableMeasurement.amount * self.amount, unit: quantifiableMeasurement.unit)
                
                return try equivalentMeasurement.normalizedMeasurement()
            }
            
            let totalAmount = try amount(for: self.unit)
            let totalMeasurement = Quantification(amount: totalAmount * self.amount, unit: self.unit)
            
            return try totalMeasurement.normalizedMeasurement()
        } else if let recipe = self.recipe {
            if self.unit == .each {
                guard recipe.unit.isQuantifiable else {
                    throw MiseEnPlaceError.quantifiableConversion
                }
                
                var totalMeasurement = recipe.totalQuantification
                totalMeasurement.amount = totalMeasurement.amount * multiplier
                
                return try totalMeasurement.normalizedMeasurement()
            }
            
            let totalAmount = recipe.totalAmount(for: self.unit)
            let totalMeasurement = Quantification(amount: totalAmount * self.amount, unit: self.unit)
            
            return try totalMeasurement.normalizedMeasurement()
        }
        
        throw MiseEnPlaceError.unhandledConversion
    }
}
