import Foundation

/// Needed parameters in order to represent a `Measurement`.
///
/// ## Requied Conformance
///
/// ```swift
/// // The numerical value of the measurement.
/// var amount: Double? { get set }
///
/// // The unit of which the amount is representative.
/// var unit: MeasurementUnit? { get set }
/// ```
///
public protocol Quantifiable {
    var amount: Double { get set }
    var unit: MeasurementUnit { get set }
}

public extension Quantifiable {
    var quantification: Quantification {
        return Quantification(amount: amount, unit: unit)
    }
}
