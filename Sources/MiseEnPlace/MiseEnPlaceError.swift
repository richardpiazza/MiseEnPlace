import Foundation

public enum MiseEnPlaceError: Swift.Error, LocalizedError {
    case asNeededConversion
    case quantifiableConversion
    case unhandledConversion
    case measurementAmount(method: MeasurementMethod?)
    case measurementUnit(method: MeasurementMethod?)
    
    public var errorDescription: String? {
        switch self {
        case .asNeededConversion: return "Conversion to/from MeasurementUnit .asNeeded is not supported."
        case .quantifiableConversion: return "The specified ingredient has an invalid 'each' measurement."
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
