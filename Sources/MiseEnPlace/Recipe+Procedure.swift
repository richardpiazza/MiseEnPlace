import Foundation

public extension Recipe {
    /// An ordered list of procedure elements.
    var procedure: [ProcedureElement] {
        return procedureElements.sorted(by: { $0.sequence < $1.sequence })
    }
    
    // Assigns the next sequence number to the formula element.
    @discardableResult
    mutating func appendProcedureElement(_ element: ProcedureElement) -> ProcedureElement {
        var procedureElement = element
        procedureElement.sequence = procedure.count
        procedureElements.append(procedureElement)
        return procedureElement
    }
    
    /// Adjusts the sequencing of procedure elements.
    ///
    /// - parameters:
    ///   - from: The set of indices for elements that should be resequenced.
    ///   - to: The index where the elements should be placed.
    /// - returns: A collection of all elements that had a `sequence` change by this operation.
    @discardableResult
    mutating func moveProcedureElements(from: IndexSet, to: Int) -> [ProcedureElement] {
        guard !from.isEmpty else {
            return []
        }
        
        guard let minIndex = from.min() else {
            return []
        }
        
        guard let maxIndex = from.max() else {
            return []
        }
        
        var modifiedElements: [ProcedureElement] = []
        var modifiedProcedure = self.procedure
        
        if to < minIndex {
            var elements: [ProcedureElement] = []
            for index in from.reversed() {
                elements.append(modifiedProcedure.remove(at: index))
            }
            
            for element in elements {
                modifiedProcedure.insert(element, at: to)
            }
            
            for index in 0..<modifiedProcedure.count {
                modifiedProcedure[index].sequence = index
            }
            
            for (index, element) in procedureElements.enumerated() {
                if let sequence = modifiedProcedure.first(where:  { $0.id == element.id })?.sequence {
                    if element.sequence != sequence {
                        procedureElements[index].sequence = sequence
                        modifiedElements.append(procedureElements[index])
                    }
                }
            }
            
        } else if to > maxIndex {
            var elements: [ProcedureElement] = []
            for index in from.reversed() {
                elements.append(modifiedProcedure[index])
            }
            
            for element in elements {
                modifiedProcedure.insert(element, at: to)
            }
            
            for index in from.reversed() {
                modifiedProcedure.remove(at: index)
            }
            
            for index in 0..<modifiedProcedure.count {
                modifiedProcedure[index].sequence = index
            }
            
            for (index, element) in procedureElements.enumerated() {
                if let sequence = modifiedProcedure.first(where:  { $0.id == element.id })?.sequence {
                    if element.sequence != sequence {
                        procedureElements[index].sequence = sequence
                        modifiedElements.append(procedureElements[index])
                    }
                }
            }
        }
        
        return modifiedElements
    }
    
    /// Removes the procedure elements at the specified indices, re-sequencing as necessary.
    ///
    /// - parameters:
    ///   - at: The set of indices for elements that should be removed.
    /// - returns: Elements that were removed or had a `sequence` change as part of the operation.
    @discardableResult
    mutating func deleteProcedureElements(at: IndexSet) -> (removed: [ProcedureElement], modified: [ProcedureElement]) {
        guard !at.isEmpty else {
            return ([], [])
        }
        
        var removedElements: [ProcedureElement] = []
        var modifiedElements: [ProcedureElement] = []
        var modifiedProcedure = self.procedure
        
        for index in at.reversed() {
            let element = modifiedProcedure.remove(at: index)
            removedElements.insert(element, at: 0)
            if let formulaIndex = procedureElements.firstIndex(where: { $0.id == element.id }) {
                procedureElements.remove(at: formulaIndex)
            }
        }
        
        for index in 0..<modifiedProcedure.count {
            modifiedProcedure[index].sequence = index
        }
        
        for (index, element) in procedureElements.enumerated() {
            if let sequence = modifiedProcedure.first(where:  { $0.id == element.id })?.sequence {
                if element.sequence != sequence {
                    procedureElements[index].sequence = sequence
                    modifiedElements.append(procedureElements[index])
                }
            }
        }
        
        return (removedElements, modifiedElements)
    }
    
    @available(*, deprecated)
    internal mutating func updateSequence(_ element: ProcedureElement, sequence: Int) {
        var e = element
        e.sequence = sequence
        
        guard let index = procedureElements.firstIndex(where: { $0.uuid == element.uuid }) else {
            return
        }
        
        procedureElements.remove(at: index)
        procedureElements.insert(e, at: index)
    }
    
    @available(*, deprecated, renamed: "appendProcedureElement()")
    mutating func insertProcedureElement(_ element: ProcedureElement) {
        appendProcedureElement(element)
    }
    
    /// Adjusts the sequence numbers of all elements following the specified element.
    @available(*, deprecated, renamed: "deleteProcedureElements(at:)")
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
    @available(*, deprecated, renamed: "moveProcedureElements(from:to:)")
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
