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
    /// Translates the measurement to a different unit. Neither the `unit` nor specified `destinationUnit` can be .asNeeded.
    ///
    /// - parameter destinationUnit: The unit to convert to.
    /// - throws: `MiseEnPlaceError`
    func amount(for destinationUnit: MeasurementUnit) throws -> Double {
        guard unit != .asNeeded else {
            throw MiseEnPlaceError.asNeededConversion
        }
        
        if let ingredient = self.ingredient {
            guard destinationUnit != .asNeeded else {
                throw MiseEnPlaceError.asNeededConversion
            }
            
            guard amount > 0.0 else {
                throw MiseEnPlaceError.measurementAmount(method: nil)
            }
            
            if (unit == .each || destinationUnit == .each) && !ingredient.quantification.unit.isQuantifiable {
                throw MiseEnPlaceError.quantifiableConversion
            }
            
            switch (unit.measurementSystemMethod, destinationUnit.measurementSystemMethod) {
            case (.numericQuantity, .numericQuantity):
                return amount
            case (.numericQuantity, .usVolume), (.numericQuantity, .usWeight), (.numericQuantity, .metricVolume), (.numericQuantity, .metricWeight):
                let quantifiableMeasurement = ingredient.quantification
                let equivalentMeasurement = Quantification(amount: quantifiableMeasurement.amount * amount, unit: quantifiableMeasurement.unit)
                let multiplier = ingredient.multiplier(from: unit.measurementMethod, to: destinationUnit.measurementMethod)
                let equivalentAmount = try equivalentMeasurement.amount(for: destinationUnit, conversionMultiplier: multiplier)
                return equivalentAmount
            case (.usVolume, .numericQuantity), (.usWeight, .numericQuantity), (.metricVolume, .numericQuantity), (.metricWeight, .numericQuantity):
                let quantifiableMeasurement = ingredient.quantification
                let multiplier = ingredient.multiplier(from: unit.measurementMethod, to: destinationUnit.measurementMethod)
                let equivalentAmount = try quantification.amount(for: quantifiableMeasurement.unit, conversionMultiplier: multiplier)
                return equivalentAmount / quantifiableMeasurement.amount
            case (.usVolume, .usVolume), (.usWeight, .usWeight), (.metricVolume, .metricVolume), (.metricWeight, .metricWeight):
                return try quantification.amount(for: destinationUnit)
            default:
                let multiplier: Double
                if unit.measurementMethod == .volume && destinationUnit.measurementMethod == .weight {
                    multiplier = ingredient.multiplier(for: .volume)
                } else {
                    multiplier = ingredient.multiplier(for: .weight)
                }
                return try quantification.amount(for: destinationUnit, conversionMultiplier: multiplier)
            }
        } else if let recipe = self.recipe {
            guard unit != .asNeeded else {
                throw MiseEnPlaceError.asNeededConversion
            }
            
            guard amount > 0.0 else {
                throw MiseEnPlaceError.measurementAmount(method: nil)
            }
            
            if (unit == .each || destinationUnit == .each) && !recipe.quantification.unit.isQuantifiable {
                throw MiseEnPlaceError.quantifiableConversion
            }
            
            return recipe.totalAmount(for: destinationUnit)
        }
        
        throw MiseEnPlaceError.unhandledConversion
    }
    
    /// Scales the 'measured' amount of either the `ingredient` or `recipe`.
    ///
    /// - parameter multiplier:
    /// - parameter measurementSystem:
    /// - parameter measurementMethod:
    /// - throws: `MiseEnPlaceError`
    func scale(by multiplier: Double, measurementSystem: MeasurementSystem? = nil, measurementMethod: MeasurementMethod? = nil) throws -> Quantification {
        guard unit != .asNeeded else {
            throw MiseEnPlaceError.asNeededConversion
        }
        
        guard !amount.isNaN && amount > 0.0 else {
            throw MiseEnPlaceError.nanZeroConversion
        }
        
        if let ingredient = self.ingredient {
            switch (unit, measurementSystem, measurementMethod) {
            case (_, .none, .none), (.each, .numeric, .quantity):
                return Quantification(amount: amount * multiplier, unit: unit)
            case (_, .numeric, .quantity):
                guard ingredient.unit.isQuantifiable else {
                    throw MiseEnPlaceError.quantifiableConversion
                }
                
                let eachUnitTotalAmount = try amount(for: ingredient.eachQuantification.unit)
                let scaledEachTotalAmount = eachUnitTotalAmount / ingredient.eachQuantification.amount
                return Quantification(amount: scaledEachTotalAmount, unit: .each)
            case (.each, _, _):
                guard ingredient.unit.isQuantifiable else {
                    throw MiseEnPlaceError.quantifiableConversion
                }
                
                break
            default:
                break
            }
            
            if unit == .each {
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

internal extension FormulaElement {
//    func scale(by multiplier: Double, measurementSystem: MeasurementSystem? = nil, measurementMethod: MeasurementMethod? = nil) throws -> Quantification {
//        guard unit != .asNeeded else {
//            throw MiseEnPlaceError.asNeededConversion
//        }
//
//        guard !amount.isNaN && amount > 0.0 else {
//            throw MiseEnPlaceError.nanZeroConversion
//        }
//
//        if let ingredient = self.ingredient {
//            switch (unit, measurementSystem, measurementMethod) {
//            case (_, .none, .none):
//                let totalAmount = try amount(for: unit)
//                let totalMeasurement = Quantification(amount: totalAmount * amount, unit: unit)
//                return try totalMeasurement.normalizedMeasurement()
//            case (.each, .numeric, .quantity):
//                return Quantification(amount: amount * multiplier, unit: unit)
//            case (_, .numeric, .quantity):
//                guard ingredient.unit.isQuantifiable else {
//                    throw MiseEnPlaceError.quantifiableConversion
//                }
//
//                let eachQuantification = ingredient.eachQuantification
//                let unitQuantification = try amount(for: eachQuantification.unit)
//                return Quantification(amount: unitQuantification / eachQuantification.amount, unit: .each)
//            case (_, .us, .volume):
//                break
//            case (_, .us, .weight):
//                break
//            case (_, .metric, .volume):
//                break
//            case (_, .metric, .weight):
//                break
//            default:
//                break
//            }
//
//            if unit == .each {
//                guard ingredient.unit.isQuantifiable else {
//                    throw MiseEnPlaceError.quantifiableConversion
//                }
//
//                let quantifiableMeasurement = ingredient.quantification
//                let equivalentMeasurement = Quantification(amount: quantifiableMeasurement.amount * amount, unit: quantifiableMeasurement.unit)
//
//                return try equivalentMeasurement.normalizedMeasurement()
//            }
//
//            let totalAmount = try amount(for: unit)
//            let totalMeasurement = Quantification(amount: totalAmount * amount, unit: unit)
//
//            return try totalMeasurement.normalizedMeasurement()
//        } else if let recipe = self.recipe {
//            if unit == .each {
//                guard recipe.unit.isQuantifiable else {
//                    throw MiseEnPlaceError.quantifiableConversion
//                }
//
//                var totalMeasurement = recipe.totalQuantification
//                totalMeasurement.amount = totalMeasurement.amount * multiplier
//
//                return try totalMeasurement.normalizedMeasurement()
//            }
//
//            let totalAmount = recipe.totalAmount(for: unit)
//            let totalMeasurement = Quantification(amount: totalAmount * amount, unit: unit)
//
//            return try totalMeasurement.normalizedMeasurement()
//        }
//
//        throw MiseEnPlaceError.unhandledConversion
//    }
}
