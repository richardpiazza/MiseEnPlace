import Foundation

/// # Ingredient
///
/// Represents any raw material/ingredient used in cooking.
/// A `Ingredient` is one of the primary protocols for interacting with an
/// object graph utilizing the `MiseEnPlace` framework.
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
/// _Descriptive_
/// ```swift
/// var name: String? { get set }
/// var commentary: String? { get set }
/// var classification: String? { get set }
/// ```
///
/// _Multimedia_
/// ```swift
/// var imagePath: String? { get set }
/// ```
///
/// _Proportioned_
/// ```swift
/// var volume: Double { get set }
/// var weight: Double { get set }
/// ```
///
/// _Measured_
/// ```swift
/// var amount: Double { get set }
/// var unit: MeasurementUnit { get set }
/// ```
///
/// ## Notes:
///
/// - The `Measured` conformance on an `Ingredient` will represent an
/// _each_ measurement. i.e. What is the equivalent measurement for one (1)
/// of this `Ingredient`?
///
public protocol Ingredient: Unique, Descriptive, Multimedia, Proportioned, Measured {
    
}

public extension Ingredient {
    
}
