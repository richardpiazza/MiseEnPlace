import Foundation

/// Similar to the `MeasurementMethod` the `MeasurementSystem` enum represents the 
/// types of unit systems that can be used.
public enum MeasurementSystem: Int {
    case numeric = 0
    case us = 1
    case metric = 2
}
