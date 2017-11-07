import Foundation

/// # Unique
///
/// Represents the needed information for determining uniqueness
/// among objects.
///
/// ## Requied Conformance
///
/// ```swift
/// // A unique string matching the UUID format
/// var uuid: String { get set }
///
/// // The date and time an object was first initialized
/// var creationDate: Date { get set }
///
/// // The date and time when an object was last modified
/// var modificationDate: Date { get set }
/// ```
///
public protocol Unique {
    // A unique string matching the UUID format
    var uuid: String { get set }
    // The date and time an object was first initialized
    var creationDate: Date { get set }
    // The date and time when an object was last modified
    var modificationDate: Date { get set }
}
