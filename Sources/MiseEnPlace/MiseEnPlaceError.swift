import Foundation

public enum MiseEnPlaceError: Error, LocalizedError {
    case quantificationNotQuantified
    case quantificationAsNeeded
    case quantifiableConversion
    case nanZeroConversion
    case unhandledConversion
    case measurementAmount(method: MeasurementMethod?)
    case measurementUnit(method: MeasurementMethod?)
    
    public var errorDescription: String? {
        switch self {
        case .quantificationNotQuantified: return "A `Quantification` is specified as 'not-quantified'."
        case .quantificationAsNeeded: return "A `Quantification` is specified as 'as-needed'."
        case .quantifiableConversion: return "The specified ingredient has an invalid 'each' measurement."
        case .nanZeroConversion: return "The conversion amount is NaN (Not a Number) or Zero."
        case .unhandledConversion: return "Conversion is not supported at this time."
        case .measurementAmount(let method):
            if let m = method, m == .volume {
                return "Volume measurement requires a positive non-zero amount."
            } else if let m = method, m == .weight {
                return "Weight measurement requires a positive non-zero amount."
            } else {
                return "Measurement amount must be a positive non-zero amount."
            }
        case .measurementUnit(let method):
            if let m = method, m == .volume {
                return "Volume measurement requires a unit `MeasurementMethod` of type .volume."
            } else if let m = method, m == .weight {
                return "Weight measurement requires a unit `MeasurementMethod` of type .weight."
            } else {
                return "Measurement unit must be specified."
            }
        }
    }
}

public extension MiseEnPlaceError {
    @available(*, deprecated, renamed: "quantificationNotQuantified")
    static var quantifiactionNotQuantified: Self { quantificationNotQuantified }
    
    @available(*, deprecated, renamed: "quantificationAsNeeded")
    static var quantifiactionAsNeeded: Self { quantificationAsNeeded }
}
