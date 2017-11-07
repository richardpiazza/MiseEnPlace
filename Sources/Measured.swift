import Foundation

/// # Measured
///
/// Needed parameters in order to represent a `CookingMeasurement`.
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
    public var measurement: MiseEnPlace.Measurement {
        return MiseEnPlace.Measurement(amount: self.amount, unit: self.unit)
    }
}
