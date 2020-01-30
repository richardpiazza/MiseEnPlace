import Foundation

/// Represents the needed information for determining uniqueness among objects.
///
/// Beyond just supplying a unique identifier, creation and modification dates aid in comparison.
///
/// ## Requied Conformance
///
/// ```swift
/// /// A unique identifier in the UUID format
/// var uuid: UUID { get set }
///
/// /// The date and time an object was first initialized
/// var creationDate: Date { get set }
///
/// /// The date and time when an object was last modified
/// var modificationDate: Date { get set }
/// ```
///
/// ## Example
///
/// ```swift
/// struct FoodStuff: Unique {
///     var uuid: UUID = UUID()
///     var creationDate: Date = Date()
///     var modificationDate: Date = Date()
/// }
/// ```
public protocol Unique {
    /// A unique identifier in the UUID format
    var uuid: UUID { get set }
    /// The date and time an object was first initialized
    var creationDate: Date { get set }
    /// The date and time when an object was last modified
    var modificationDate: Date { get set }
}

public extension Unique {
    /// Provideds conformance to the `Identifiable` protocol.
    var id: UUID {
        return uuid
    }
}
