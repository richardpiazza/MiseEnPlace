import Foundation

/// # Descriptive
///
/// Parameters that describe and categorize an object.
///
/// ## Requied Conformance
///
/// ```swift
/// // The common, short, human-understandable text.
/// var name: String? { get set }
///
/// // The expanded description i.e. 'notes'
/// var commentary: String? { get set }
///
/// // The scientific or structured identity of the item.
/// var classification: String? { get set }
/// ```
///
/// For Example:
///
/// name = 'Whole Milk'
///
/// commentary = 'The mamary lactations from a bovine.'
///
/// classification = 'Dairy, Milk, Cow, Whole/Full Fat'
///
public protocol Descriptive {
    // The common, short, human-understandable text.
    var name: String? { get set }
    // The expanded description i.e. 'notes'
    var commentary: String? { get set }
    // The scientific or structured identity of the item.
    var classification: String? { get set }
}

public extension Descriptive {
    /// Returns the first character from `name` or "" (empty string).
    public var nameIndexCharacter: String {
        guard let name = self.name else {
            return ""
        }
        
        guard name.count > 0 else {
            return ""
        }
        
        let range = name.startIndex..<name.index(name.startIndex, offsetBy: 1)
        return name[range].uppercased()
    }
}
