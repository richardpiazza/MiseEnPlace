import Foundation

/// Represents any raw material/ingredient used in cooking.
///
/// A `Ingredient` is one of the primary protocols for interacting with an object graph utilizing the **MiseEnPlace** framework.
///
/// ## Required Conformance
///
/// *none*
///
/// ## Protocol Conformance
///
/// _Unique_
/// ```swift
/// var uuid: UUID { get set }
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
/// var imageData: Data? { get set }
/// var imagePath: String? { get set }
/// ```
///
/// _Proportioned_
/// ```swift
/// var volume: Double { get set }
/// var weight: Double { get set }
/// ```
///
/// _Quantifiable_
/// ```swift
/// var amount: Double { get set }
/// var unit: MeasurementUnit { get set }
/// ```
///
/// - note: The `Quantifiable` conformance on an `Ingredient` will represent an _each_ measurement.
/// i.e. *What is the equivalent measurement for one (1) of this item?*
///
/// ## Example
///
/// ```swift
/// struct FoodStuff: Ingredient {
///     var uuid: UUID = UUID()
///     var creationDate: Date = Date()
///     var modificationDate: Date = Date()
///     var name: String? = "Whole Milk"
///     var commentary: String? = "The mammary lactations from a bovine."
///     var classification: String? = "Dairy, Milk, Cow, Whole/Full Fat"
///     var imagePath: String?
///     var volume: Double = 1.0
///     var weight: Double = 1.0
///     var amount: Double = 1.0
///     var unit: MeasurementUnit = .gallon
/// }
/// ```
public protocol Ingredient: Unique, Descriptive, Multimedia, Proportioned, Quantifiable {
    
}

public extension Ingredient {
    /// `Quantification` that represents to which one (1) of this item is approximately equivalent.
    ///
    /// For example: 1 egg ≅ 50 grams
    var eachQuantification: Quantification {
        get {
            quantification
        }
        set(newValue) {
            quantification = newValue
        }
    }
}
