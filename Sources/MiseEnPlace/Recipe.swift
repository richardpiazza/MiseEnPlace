import Foundation

/// Represents a compilation of `Ingredient`s or other `Recipe`s.
/// A `Recipe` is one of the primary protocols for interacting with an
/// object graph utilizing the `MiseEnPlace` framework.
///
/// ## Requied Conformance
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
        return Quantification(amount: amount, unit: unit)
    }
}

// MARK: - Amount

public extension Recipe {
    /// Calculates the total mass for this formula in a give unit.
    func totalAmount(for unit: MeasurementUnit) -> Double {
        var amount: Double = 0.0
        
        let elements = self.formula
        for element in elements {
            do {
                let a = try element.amount(for: unit)
                amount += a
            } catch {
                print(error)
            }
        }
        
        return amount
    }
    
    /// The total mass of this formula in the portions unit.
    var totalQuantification: Quantification {
        let total = self.totalAmount(for: self.unit)
        return Quantification(amount: total, unit: self.unit)
    }
    
    /// The total mass of this formula in the portions unit.
    @available(*, deprecated, renamed: "totalQuantification")
    var totalMeasurement: Quantification {
        return totalQuantification
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

// MARK: - Formula

public extension Recipe {
    /// An ordered list of formula elements (MeasuredIngredient/MeasuredRecipe).
    var formula: [FormulaElement] {
        return formulaElements.sorted(by: { $0.sequence < $1.sequence })
    }
    
    /// Assigns the next sequence number to the formula element.
    mutating func insertFormulaElement(_ element: FormulaElement) {
        var formulaElement = element
        formulaElement.sequence = formula.count
        
        formulaElements.append(formulaElement)
    }
    
    internal mutating func updateSequence(_ element: FormulaElement, sequence: Int) {
        var formulaElement = element
        formulaElement.sequence = sequence
        
        guard let index = formulaElements.firstIndex(where: { $0.id == formulaElement.id }) else {
            return
        }
        
        formulaElements.remove(at: index)
        formulaElements.insert(formulaElement, at: index)
    }
    
    /// Adjusts the sequence numbers of all elements following the specified element.
    mutating func removeFormulaElement(_ element: FormulaElement) {
        guard let index = formula.firstIndex(where: { $0.uuid == element.uuid }) else {
            return
        }
        
        for (idx, element) in formula.enumerated() {
            guard idx > index else {
                continue
            }
            
            let newSequence = idx - 1
            updateSequence(element, sequence: newSequence)
        }
        
        formulaElements.remove(at: index)
    }
    
    /// Adjusts the sequencing of elements affected by a move operation.
    ///
    /// - returns: A range of indices that have been affected by this operation
    @discardableResult
    mutating func moveFormulaElement(_ element: FormulaElement, fromIndex: Int, toIndex: Int) -> [Int] {
        var indices: [Int] = []
        
        guard fromIndex != toIndex else {
            return indices
        }
        
        let elements = self.formula
        
        if toIndex < fromIndex {
            for i in toIndex..<fromIndex {
                indices.append(i)
                let formulaElement = elements[i]
                let newSequence = i + 1
                
                updateSequence(formulaElement, sequence: newSequence)
            }
        } else {
            for i in fromIndex.advanced(by: 1)...toIndex {
                indices.append(i)
                let formulaElement = elements[i]
                let newSequence = i - 1
                
                updateSequence(formulaElement, sequence: newSequence)
            }
        }
        
        updateSequence(element, sequence: toIndex)
        indices.append(fromIndex)
        
        return indices
    }
}

// MARK: - Procedure

public extension Recipe {
    /// An ordered list of procedure elements.
    var procedure: [ProcedureElement] {
        return procedureElements.sorted(by: { $0.sequence < $1.sequence })
    }
    
    // Assigns the next sequence number to the formula element.
    mutating func insertProcedureElement(_ element: ProcedureElement) {
        var procedureElement = element
        procedureElement.sequence = procedure.count
        
        procedureElements.append(procedureElement)
    }
    
    internal mutating func updateSequence(_ element: ProcedureElement, sequence: Int) {
        var e = element
        e.sequence = sequence
        
        guard let index = procedureElements.firstIndex(where: { $0.uuid == element.uuid }) else {
            return
        }
        
        procedureElements.remove(at: index)
        procedureElements.insert(e, at: index)
    }
    
    /// Adjusts the sequence numbers of all elements following the specified element.
    mutating func removeProcedureElement(_ element: ProcedureElement) {
        guard let index = procedure.firstIndex(where: { $0.uuid == element.uuid }) else {
            return
        }
        
        for (idx, element) in procedure.enumerated() {
            guard idx > index else {
                continue
            }
            
            let newSequence = idx - 1
            updateSequence(element, sequence: newSequence)
        }
        
        procedureElements.remove(at: index)
    }
    
    /// Adjusts the sequencing of elements affected by a move operation.
    ///
    /// - returns: A range of indices that have been affected by this operation
    @discardableResult
    mutating func moveProcedureElement(_ element: ProcedureElement, fromIndex: Int, toIndex: Int) -> [Int] {
        var indices: [Int] = []
        
        guard fromIndex != toIndex else {
            return indices
        }
        
        let elements = self.procedure
        
        if toIndex < fromIndex {
            for i in toIndex..<fromIndex {
                indices.append(i)
                let e = elements[i]
                let newSequence = i + 1
                
                updateSequence(e, sequence: newSequence)
            }
        } else {
            for i in fromIndex.advanced(by: 1)...toIndex {
                indices.append(i)
                let e = elements[i]
                let newSequence = i - 1
                
                updateSequence(e, sequence: newSequence)
            }
        }
        
        updateSequence(element, sequence: toIndex)
        indices.append(fromIndex)
        
        return indices
    }
    
    /// A concatenation of all procedure element commentaries.
    var procedureSummary: String {
        var text: String = ""
        
        let elements = self.procedureElements
        for element in elements {
            guard let commentary = element.commentary else {
                continue
            }
            if text == "" {
                text.append(commentary)
            } else {
                #if canImport(ObjectiveC)
                text.append(String(format: "\n%@", commentary))
                #else
                commentary.withCString {
                    text.append(String(format: "\n%s", $0))
                }
                #endif
            }
        }
        
        return text
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
