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
public protocol Measured {
    var amount: Double { get set }
    var unit: MeasurementUnit { get set }
}

public extension Measured {
    var quantification: Quantification {
        return Quantification(amount: amount, unit: unit)
    }
    
    @available(*, deprecated, renamed: "quantification")
    var measurement: Quantification {
        return quantification
    }
}
