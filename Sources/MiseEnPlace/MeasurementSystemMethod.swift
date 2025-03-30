import Foundation

/// The `MeasurementSystemMethod` represents the ways `MeasurementMethod`s and
/// `MeasurementSystem`s can be combined.
public enum MeasurementSystemMethod: Int {
    case numericQuantity = 00
    case usVolume = 11
    case usWeight = 12
    case metricVolume = 21
    case metricWeight = 22

    public static func measurementSystemMethod(for measurementSystem: MeasurementSystem, measurementMethod: MeasurementMethod) -> MeasurementSystemMethod? {
        switch (measurementSystem, measurementMethod) {
        case (.numeric, .quantity):
            .numericQuantity
        case (.us, .volume):
            .usVolume
        case (.us, .weight):
            .usWeight
        case (.metric, .volume):
            .metricVolume
        case (.metric, .weight):
            .metricWeight
        default:
            nil
        }
    }
}
