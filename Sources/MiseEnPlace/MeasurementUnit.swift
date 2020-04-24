import Foundation

/// A representation of some unit of measure.
///
/// The `MeasurementUnit` enum is the heart of the MiseEnPlace framework along with `MeasurementSystem` and `MeasurementMethod` to which
/// the unit belongs. All of the logic for how and when to convert to other units and amounts is contained within.
///
/// - note: The rawValue is comprised of [`MeasurementSystem`][`MeasurementMethod`][##Unique]
public enum MeasurementUnit: Int, CaseIterable {
    // numericQuantity
    /// A specialized condition in which no unit should be used
    case noUnit = -1
    /// A specialized condition in which there is no quantifiable measurement
    case asNeeded = 0
    /// A specialized condition in which there is a quantifiable measurement associated with the concept of _each_ item.
    case each = 1
    
    // usVolume
    case pinch = 1100
    case dash = 1101
    case teaspoon = 1102
    case tablespoon = 1103
    case fluidOunce = 1104
    case cup = 1105
    case pint = 1106
    case quart = 1107
    case gallon = 1108
    
    // usWeight
    case ounce = 1200
    case pound = 1201
    
    // metricVolume
    case milliliter = 2100
    case liter = 2101
    
    // metricWeight
    case gram = 2200
    case kilogram = 2201
    
    public static var quantifiableMeasurementUnits: [MeasurementUnit] {
        return [.pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon, .ounce, .pound, .milliliter, .liter, .gram, .kilogram]
    }
    
    /// Provides an array of `MeasurementUnit` enums that correspond to the provided `MeasurementSystemMethod` enum
    public static func measurementUnits(forMeasurementSystemMethod measurementSystemMethod: MeasurementSystemMethod) -> [MeasurementUnit] {
        switch measurementSystemMethod {
        case .numericQuantity: return [.asNeeded, .each]
        case .usVolume: return [.pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon]
        case .usWeight: return [.ounce, .pound]
        case .metricVolume: return [.milliliter, .liter]
        case .metricWeight: return [.gram, .kilogram]
        }
    }
    
    public static func measurementUnits(forMeasurementMethod measurementMethod: MeasurementMethod) -> [MeasurementUnit] {
        switch measurementMethod {
        case .quantity: return [.asNeeded, .each]
        case .volume: return [.pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon, .milliliter, .liter]
        case .weight: return [.ounce, .pound, .gram, .kilogram]
        }
    }
    
    public init?(stringValue: String) {
        for unit in MeasurementUnit.allCases {
            if unit.description == stringValue {
                self = unit
                return
            }
        }
        
        switch stringValue {
        case "Quantity":
            self = .each
        case "FluidOunce":
            self = .fluidOunce
        case "Mililitre":
            self = .milliliter
        case "Litre":
            self = .liter
        default:
            return nil
        }
    }
    
    /// The raw values for quantity measurements changes from v4.0 to v4.1.
    /// Use this initializer when using 4.0 values.
    public init?(legacyRawValue: Int) {
        switch legacyRawValue {
        case 9000:
            self = .asNeeded
        case 9001:
            self = .each
        default:
            if let legacy = MeasurementUnit(rawValue: legacyRawValue) {
                self = legacy
            } else {
                return nil
            }
        }
    }
}

extension MeasurementUnit: CustomStringConvertible {
    public var description: String {
        switch self {
        case .noUnit: return "No Unit"
        case .asNeeded: return "As Needed"
        case .each: return "Each"
        case .pinch: return "Pinch"
        case .dash: return "Dash"
        case .teaspoon: return "Teaspoon"
        case .tablespoon: return "Tablespoon"
        case .fluidOunce: return "Fluid Ounce"
        case .cup: return "Cup"
        case .pint: return "Pint"
        case .quart: return "Quart"
        case .gallon: return "Gallon"
        case .ounce: return "Ounce"
        case .pound: return "Pound"
        case .milliliter: return "Milliliter"
        case .liter: return "Liter"
        case .gram: return "Gram"
        case .kilogram: return "Kilogram"
        }
    }
}

extension MeasurementUnit {
    @available(*, deprecated, renamed: "description")
    public var name: String {
        return description
    }
    
    public var abbreviation: String {
        switch self {
        case .noUnit: return "-"
        case .asNeeded: return "…"
        case .each: return "№"
        case .pinch: return "pn"
        case .dash: return "ds"
        case .teaspoon: return "tsp"
        case .tablespoon: return "tbsp"
        case .fluidOunce: return "fl oz"
        case .cup: return "c"
        case .pint: return "pt"
        case .quart: return "qt"
        case .gallon: return "gal"
        case .ounce: return "oz"
        case .pound: return "lb"
        case .milliliter: return "mL"
        case .liter: return "L"
        case .gram: return "g"
        case .kilogram: return "kg"
        }
    }
    
    public func name(abbreviated: Bool) -> String {
        return (abbreviated) ? abbreviation : description
    }
    
    public var measurementSystem: MeasurementSystem {
        switch self {
        case .noUnit, .asNeeded, .each:
            return .numeric
        case .pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon, .ounce, .pound:
            return .us
        case .milliliter, .liter, .gram, .kilogram:
            return .metric
        }
    }
    
    public var measurementMethod: MeasurementMethod {
        switch self {
        case .noUnit, .asNeeded, .each:
            return .quantity
        case .pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon, .milliliter, .liter:
            return .volume
        case .ounce, .pound, .gram, .kilogram:
            return .weight
        }
    }
    
    public var measurementSystemMethod: MeasurementSystemMethod {
        switch self {
        case .noUnit, .asNeeded, .each:
            return .numericQuantity
        case .pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon:
            return .usVolume
        case .ounce, .pound:
            return .usWeight
        case .milliliter, .liter:
            return .metricVolume
        case .gram, .kilogram:
            return .metricWeight
        }
    }
    
    public var stepDownThreshold: Double {
        switch self {
        case .dash: return 0.5
        case .teaspoon: return 0.5
        case .tablespoon: return 1
        case .fluidOunce: return 1
        case .cup: return 0.5
        case .pint: return 1
        case .quart: return 1
        case .gallon: return 1
        case .pound: return 1
        case .liter: return 1
        case .kilogram: return 1
        default: return 0
        }
    }
    
    public var stepUpThreshold: Double {
        switch self {
        case .pinch: return 2.0
        case .dash: return 2.0
        case .teaspoon: return 4.5
        case .tablespoon: return 3.5
        case .fluidOunce: return 9.5
        case .cup: return 3.0
        case .pint: return 2.5
        case .quart: return 4.5
        case .ounce: return 16
        case .milliliter: return 1250
        case .gram: return 1250
        default: return 0
        }
    }
    
    public var stepDownMultiplier: Double {
        switch self {
        case .dash: return Fraction.oneHalf.rawValue
        case .teaspoon: return Fraction.oneEighth.rawValue
        case .tablespoon: return Fraction.oneThird.rawValue
        case .fluidOunce: return Fraction.oneHalf.rawValue
        case .cup: return Fraction.oneEighth.rawValue
        case .pint: return Fraction.oneHalf.rawValue
        case .quart: return Fraction.oneHalf.rawValue
        case .gallon: return Fraction.oneFourth.rawValue
        case .pound: return Fraction.oneSixteenth.rawValue
        case .liter: return Fraction.oneThousandth.rawValue
        case .kilogram: return Fraction.oneThousandth.rawValue
        default: return 0
        }
    }
    
    public var stepUpMultiplier: Double {
        switch self {
        case .pinch: return Fraction.oneHalf.rawValue
        case .dash: return Fraction.oneEighth.rawValue
        case .teaspoon: return Fraction.oneThird.rawValue
        case .tablespoon: return Fraction.oneHalf.rawValue
        case .fluidOunce: return Fraction.oneEighth.rawValue
        case .cup: return Fraction.oneHalf.rawValue
        case .pint: return Fraction.oneHalf.rawValue
        case .quart: return Fraction.oneFourth.rawValue
        case .ounce: return Fraction.oneSixteenth.rawValue
        case .milliliter: return Fraction.oneThousandth.rawValue
        case .gram: return Fraction.oneThousandth.rawValue
        default: return 0
        }
    }
    
    public var stepDownUnit: MeasurementUnit? {
        switch self {
        case .dash: return .pinch
        case .teaspoon: return .dash
        case .tablespoon: return .teaspoon
        case .fluidOunce: return .tablespoon
        case .cup: return .fluidOunce
        case .pint: return .cup
        case .quart: return .pint
        case .gallon: return .quart
        case .pound: return .ounce
        case .liter: return .milliliter
        case .kilogram: return .gram
        default: return nil
        }
    }
    
    public var stepUpUnit: MeasurementUnit? {
        switch self {
        case .pinch: return .dash
        case .dash: return .teaspoon
        case .teaspoon: return .tablespoon
        case .tablespoon: return .fluidOunce
        case .fluidOunce: return .cup
        case .cup: return .pint
        case .pint: return .quart
        case .quart: return .gallon
        case .ounce: return .pound
        case .milliliter: return .liter
        case .gram: return .kilogram
        default: return nil
        }
    }
    
    public var shouldRoundWhenTranslated: Bool {
        switch self {
        case .liter, .kilogram:
            return false
        default:
            return true
        }
    }
    
    public var isQuantifiable: Bool {
        switch self {
        case .noUnit, .asNeeded, .each:
            return false
        default:
            return true
        }
    }
}
