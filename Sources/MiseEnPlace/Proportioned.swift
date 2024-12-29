import Foundation

/// Parameters needed to understand the _volume:weight_ ratio of a given object.
///
/// One value should always be equal to 1.0 with the other value being less than, equal to, or greater than 1.0.
///
/// ## Required Conformance
///
/// ```swift
/// /// The proportional volume.
/// var volume: Double { get set }
///
/// /// The proportional weight.
/// var weight: Double { get set }
/// ```
///
public protocol Proportioned {
    /// The proportional volume.
    var volume: Double { get set }
    /// The proportional weight.
    var weight: Double { get set }
}

public extension Proportioned {
    var ratio: Ratio {
        get {
            Ratio(volume: volume, weight: weight)
        }
        set(newValue) {
            volume = newValue.volume
            weight = newValue.weight
        }
    }
}
