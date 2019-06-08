import Foundation

/// A single structure that represents all parameters needed for a scaling operation.
@available(*, deprecated)
public struct ScaleParameters {
    public var multiplier: Double = 1.0
    public var measurementSystem: MeasurementSystem?
    public var measurementMethod: MeasurementMethod?
    
    public init() {
        
    }
    
    public init(multiplier: Double, measurementSystem: MeasurementSystem? = nil, measurementMethod: MeasurementMethod? = nil) {
        self.multiplier = multiplier
        self.measurementSystem = measurementSystem
        self.measurementMethod = measurementMethod
    }
}
