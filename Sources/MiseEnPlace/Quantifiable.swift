import Foundation

/// Needed parameters in order to represent a `Measurement`.
///
/// ## Required Conformance
///
/// ```swift
/// /// The numerical value of the measurement.
/// var amount: Double? { get set }
///
/// /// The unit of which the amount is representative.
/// var unit: MeasurementUnit? { get set }
/// ```
///
public protocol Quantifiable {
    /// The numerical value of the measurement.
    var amount: Double { get set }
    /// The unit of which the amount is representative.
    var unit: MeasurementUnit { get set }
}

public extension Quantifiable {
    var quantification: Quantification {
        get {
            Quantification(amount: amount, unit: unit)
        }
        set(newValue) {
            amount = newValue.amount
            unit = newValue.unit
        }
    }
}
