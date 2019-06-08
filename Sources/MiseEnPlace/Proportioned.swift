import Foundation

/// Parameters needed to understand the volume:weight ratio of a
/// given object. One value should always be equal to 1.0 with the
/// other value being less than, equal to, or greater than 1.0.
///
/// ## Requied Conformance
///
/// ```swift
/// // The proportional volume.
/// var volume: Double { get set }
///
/// // The proportional weight.
/// var weight: Double { get set }
/// ```
///
public protocol Proportioned {
    var volume: Double { get set }
    var weight: Double { get set }
}

public extension Proportioned {
    /// Multiplier value to use when converting from `fromMethod` to `toMethod`
    func multiplier(from fromMethod: MeasurementMethod, to toMethod: MeasurementMethod) -> Double {
        switch (fromMethod, toMethod) {
        case (.volume, .weight):
            return volume / weight
        case (.weight, .volume):
            return weight / volume
        default:
            return 1.0
        }
    }
    
    /// Multiplier to use when converting measurements within the context
    /// of s singal `Measured` element.
    func multiplier(for method: MeasurementMethod) -> Double {
        switch method {
        case .volume:
            return weight / volume
        case .weight:
            return volume / weight
        default:
            return 1.0
        }
    }
}
