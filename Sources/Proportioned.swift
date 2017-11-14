import Foundation

/// # Proportioned
///
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
    public func multiplier(from fromMethod: MeasurementMethod, to toMethod: MeasurementMethod) -> Double {
        switch (fromMethod, toMethod) {
        case (.volume, .weight):
            return self.volume / self.weight
        case (.weight, .volume):
            return self.weight / self.volume
        default:
            return 1.0
        }
    }
    
    public func multiplier(for method: MeasurementMethod) -> Double {
        switch method {
        case .volume:
            return self.weight / self.volume
        case .weight:
            return self.volume / self.weight
        default:
            return 1.0
        }
    }
}
