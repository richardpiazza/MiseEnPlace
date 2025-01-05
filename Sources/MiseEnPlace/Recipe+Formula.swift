import Foundation

public extension Recipe {
    /// An ordered list of formula elements ('Measured Ingredient'/'Measured Recipe').
    var formula: [FormulaElement] {
        return formulaElements.sorted(by: { $0.sequence < $1.sequence })
    }
    
    /// Assigns the next sequence number to the formula element.
    @discardableResult
    mutating func appendFormulaElement(_ element: FormulaElement) -> FormulaElement {
        var formulaElement = element
        formulaElement.sequence = formula.count
        formulaElements.append(formulaElement)
        return formulaElement
    }
    
    /// Adjusts the sequencing of formula elements.
    ///
    /// - parameters:
    ///   - from: The set of indices for elements that should be resequenced.
    ///   - to: The index where the elements should be placed.
    /// - returns: A collection of all elements that had a `sequence` change by this operation.
    @discardableResult
    mutating func moveFormulaElements(from: IndexSet, to: Int) -> [FormulaElement] {
        guard !from.isEmpty else {
            return []
        }
        
        guard let minIndex = from.min() else {
            return []
        }
        
        guard let maxIndex = from.max() else {
            return []
        }
        
        var modifiedElements: [FormulaElement] = []
        var modifiedFormula = self.formula
        
        if to < minIndex {
            var elements: [FormulaElement] = []
            for index in from.reversed() {
                elements.append(modifiedFormula.remove(at: index))
            }
            
            for element in elements {
                modifiedFormula.insert(element, at: to)
            }
            
            for index in 0..<modifiedFormula.count {
                modifiedFormula[index].sequence = index
            }
            
            for (index, element) in formulaElements.enumerated() {
                if let sequence = modifiedFormula.first(where:  { $0.uuid == element.uuid })?.sequence {
                    if element.sequence != sequence {
                        formulaElements[index].sequence = sequence
                        modifiedElements.append(formulaElements[index])
                    }
                }
            }
            
        } else if to > maxIndex {
            var elements: [FormulaElement] = []
            for index in from.reversed() {
                elements.append(modifiedFormula[index])
            }
            
            for element in elements {
                modifiedFormula.insert(element, at: to)
            }
            
            for index in from.reversed() {
                modifiedFormula.remove(at: index)
            }
            
            for index in 0..<modifiedFormula.count {
                modifiedFormula[index].sequence = index
            }
            
            for (index, element) in formulaElements.enumerated() {
                if let sequence = modifiedFormula.first(where:  { $0.uuid == element.uuid })?.sequence {
                    if element.sequence != sequence {
                        formulaElements[index].sequence = sequence
                        modifiedElements.append(formulaElements[index])
                    }
                }
            }
        }
        
        return modifiedElements
    }
    
    /// Removes the formula elements at the specified indices, re-sequencing as necessary.
    ///
    /// - parameters:
    ///   - at: The set of indices for elements that should be removed.
    /// - returns: Elements that were removed or had a `sequence` change as part of the operation.
    @discardableResult
    mutating func deleteFormulaElements(at: IndexSet) -> (removed: [FormulaElement], modified: [FormulaElement]) {
        guard !at.isEmpty else {
            return ([], [])
        }
        
        var removedElements: [FormulaElement] = []
        var modifiedElements: [FormulaElement] = []
        var modifiedFormula = self.formula
        
        for index in at.reversed() {
            let element = modifiedFormula.remove(at: index)
            removedElements.insert(element, at: 0)
            if let formulaIndex = formulaElements.firstIndex(where: { $0.uuid == element.uuid }) {
                formulaElements.remove(at: formulaIndex)
            }
        }
        
        for index in 0..<modifiedFormula.count {
            modifiedFormula[index].sequence = index
        }
        
        for (index, element) in formulaElements.enumerated() {
            if let sequence = modifiedFormula.first(where:  { $0.uuid == element.uuid })?.sequence {
                if element.sequence != sequence {
                    formulaElements[index].sequence = sequence
                    modifiedElements.append(formulaElements[index])
                }
            }
        }
        
        return (removedElements, modifiedElements)
    }
    
    @available(*, deprecated)
    internal mutating func updateSequence(_ element: FormulaElement, sequence: Int) {
        var formulaElement = element
        formulaElement.sequence = sequence
        
        guard let index = formulaElements.firstIndex(where: { $0.uuid == formulaElement.uuid }) else {
            return
        }
        
        formulaElements.remove(at: index)
        formulaElements.insert(formulaElement, at: index)
    }
    
    @available(*, deprecated, renamed: "appendFormulaElement()")
    mutating func insertFormulaElement(_ element: FormulaElement) {
        appendFormulaElement(element)
    }
    
    /// Adjusts the sequence numbers of all elements following the specified element.
    @available(*, deprecated, renamed: "deleteFormulaElements(at:)")
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
    @available(*, deprecated, renamed: "moveFormulaElements(from:to:)")
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
