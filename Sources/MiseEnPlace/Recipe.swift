import Foundation

/// Represents a compilation of `Ingredient`s or other `Recipe`s.
///
/// A `Recipe` is one of the primary protocols for interacting with an object graph utilizing the **MiseEnPlace** framework.
///
/// ## Required Conformance
///
/// ```swift
/// // References to the elements that make up this `Recipe`s formula.
/// var formulaElements: [FormulaElement] { get set }
///
/// // References to the elements that make up this `Recipe`s procedure.
/// var procedureElements: [ProcedureElement] { get set }
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
/// `Descriptive`
/// ```swift
/// var name: String? { get set }
/// var commentary: String? { get set }
/// var classification: String? { get set }
/// ```
///
/// `Multimedia`
/// ```swift
/// var imageData: Data? { get set }
/// var imagePath: String? { get set }
/// ```
///
/// `Quantifiable`
/// ```swift
/// var amount: Double { get set }
/// var unit: MeasurementUnit { get set }
/// ```
///
/// ## Notes:
///
/// - The `Quantifiable` conformance on a `Recipe` will represent the
/// _portion_ measurement. i.e. What is the equivalent measurement for one (1)
/// portion of this `Recipe`?
///
public protocol Recipe: Unique, Descriptive, Multimedia, Quantifiable {
    var formulaElements: [FormulaElement] { get set }
    var procedureElements: [ProcedureElement] { get set }
}

public extension Recipe {
    var portion: Quantification {
        get {
            quantification
        }
        set(newValue) {
            quantification = newValue
        }
    }
}

// MARK: - Amount

public extension Recipe {
    /// Calculates the total mass for this formula in a give unit.
    func totalAmount(for unit: MeasurementUnit) -> Double {
        var amount: Double = 0.0
        
        let elements = self.formula
        for element in elements {
            if let value = try? element.amount(for: unit) {
                amount += value
            }
        }
        
        return amount
    }
    
    /// The total mass of this formula in the portions unit.
    var totalQuantification: Quantification {
        let total = self.totalAmount(for: self.unit)
        return Quantification(amount: total, unit: self.unit)
    }
}

// MARK: - Yield

public extension Recipe {
    /// Calculates the total number of portions (yield).
    var yield: Double {
        return totalQuantification.amount / amount
    }
    
    /// A 'Fractioned String' output of the `yield`.
    var yieldString: String {
        return "\(yield.fractionedString) portions"
    }
    
    /// A combined string: Total Measurement amount, Yield
    var yieldTranslation: String {
        return "\(totalQuantification.componentsTranslation), \(yieldString)"
    }
    
    /// A combined string: Total Measurement amount, Yield
    ///
    /// The `totalQuantification` is first _normalized_ using the current `unit` `MeasurementSystemMethod`.
    var yieldTranslationNormalized: String {
        do {
            let translation = try totalQuantification.normalizedQuantification().componentsTranslation
            return "\(translation), \(yieldString)"
        } catch {
            return yieldTranslation
        }
    }
}

// MARK: - Scaling

public extension Recipe {
    func scale(by multiplier: Double, measurementSystem: MeasurementSystem? = nil, measurementMethod: MeasurementMethod? = nil) throws -> [FormulaElement] {
        let elements = self.formula
        
        if multiplier == 1.0 && measurementSystem == nil && measurementMethod == nil {
            return elements
        } else if multiplier == 1.0 && measurementSystem == self.unit.measurementSystem && measurementMethod == self.unit.measurementMethod {
            return elements
        }
        
        var formulaElements = [FormulaElement]()
        
        try elements.forEach { (element) in
            let measurement = try element.scale(by: multiplier, measurementSystem: measurementSystem, measurementMethod: measurementMethod)
            var formulaElement = element
            formulaElement.amount = measurement.amount
            formulaElement.unit = measurement.unit
            formulaElements.append(formulaElement)
        }
        
        return formulaElements
    }
    
    func scale(by multiplier: Double, measurementSystemMethod: MeasurementSystemMethod) throws -> [FormulaElement] {
        switch measurementSystemMethod {
        case .numericQuantity:
            return try self.scale(by: multiplier, measurementSystem: .numeric, measurementMethod: .quantity)
        case .usVolume:
            return try self.scale(by: multiplier, measurementSystem: .us, measurementMethod: .volume)
        case .usWeight:
            return try self.scale(by: multiplier, measurementSystem: .us, measurementMethod: .weight)
        case .metricVolume:
            return try self.scale(by: multiplier, measurementSystem: .metric, measurementMethod: .volume)
        case .metricWeight:
            return try self.scale(by: multiplier, measurementSystem: .metric, measurementMethod: .weight)
        }
    }
}
