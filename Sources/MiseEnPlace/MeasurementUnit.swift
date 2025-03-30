import Foundation

/// A representation of some unit of measure.
///
/// The `MeasurementUnit` enum is the heart of the MiseEnPlace framework along with `MeasurementSystem` and `MeasurementMethod` to which
/// the unit belongs. All of the logic for how and when to convert to other units and amounts is contained within.
///
/// - note: The rawValue is comprised of [`MeasurementSystem`][`MeasurementMethod`][##Unique]
public enum MeasurementUnit: Int, Equatable, CaseIterable {
    // numericQuantity
    case noUnit = 0

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
        [.pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon, .ounce, .pound, .milliliter, .liter, .gram, .kilogram]
    }

    /// Provides an array of `MeasurementUnit` enums that correspond to the provided `MeasurementSystemMethod` enum
    public static func measurementUnits(forMeasurementSystemMethod measurementSystemMethod: MeasurementSystemMethod) -> [MeasurementUnit] {
        switch measurementSystemMethod {
        case .numericQuantity: [.noUnit]
        case .usVolume: [.pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon]
        case .usWeight: [.ounce, .pound]
        case .metricVolume: [.milliliter, .liter]
        case .metricWeight: [.gram, .kilogram]
        }
    }

    public static func measurementUnits(forMeasurementMethod measurementMethod: MeasurementMethod) -> [MeasurementUnit] {
        switch measurementMethod {
        case .quantity: [.noUnit]
        case .volume: [.pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon, .milliliter, .liter]
        case .weight: [.ounce, .pound, .gram, .kilogram]
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
            self = .noUnit
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

    /// The raw values for quantity measurements changed from v4.0 to v4.1.
    /// Use this initializer when using 4.0 values.
    public init?(legacyRawValue: Int) {
        switch legacyRawValue {
        case 9000:
            self = .noUnit
        case 9001:
            self = .noUnit
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
        case .noUnit: ""
        case .pinch: "Pinch"
        case .dash: "Dash"
        case .teaspoon: "Teaspoon"
        case .tablespoon: "Tablespoon"
        case .fluidOunce: "Fluid Ounce"
        case .cup: "Cup"
        case .pint: "Pint"
        case .quart: "Quart"
        case .gallon: "Gallon"
        case .ounce: "Ounce"
        case .pound: "Pound"
        case .milliliter: "Milliliter"
        case .liter: "Liter"
        case .gram: "Gram"
        case .kilogram: "Kilogram"
        }
    }
}

public extension MeasurementUnit {
    @available(*, deprecated, renamed: "description")
    var name: String {
        description
    }

    var abbreviation: String {
        switch self {
        case .noUnit: ""
        case .pinch: "pn"
        case .dash: "ds"
        case .teaspoon: "tsp"
        case .tablespoon: "tbsp"
        case .fluidOunce: "fl oz"
        case .cup: "c"
        case .pint: "pt"
        case .quart: "qt"
        case .gallon: "gal"
        case .ounce: "oz"
        case .pound: "lb"
        case .milliliter: "mL"
        case .liter: "L"
        case .gram: "g"
        case .kilogram: "kg"
        }
    }

    func name(abbreviated: Bool) -> String {
        abbreviated ? abbreviation : description
    }

    var measurementSystem: MeasurementSystem {
        switch self {
        case .noUnit:
            .numeric
        case .pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon, .ounce, .pound:
            .us
        case .milliliter, .liter, .gram, .kilogram:
            .metric
        }
    }

    var measurementMethod: MeasurementMethod {
        switch self {
        case .noUnit:
            .quantity
        case .pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon, .milliliter, .liter:
            .volume
        case .ounce, .pound, .gram, .kilogram:
            .weight
        }
    }

    var measurementSystemMethod: MeasurementSystemMethod {
        switch self {
        case .noUnit:
            .numericQuantity
        case .pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon:
            .usVolume
        case .ounce, .pound:
            .usWeight
        case .milliliter, .liter:
            .metricVolume
        case .gram, .kilogram:
            .metricWeight
        }
    }

    var stepDownThreshold: Double {
        switch self {
        case .dash: 0.5
        case .teaspoon: 0.5
        case .tablespoon: 1
        case .fluidOunce: 1
        case .cup: 0.5
        case .pint: 1
        case .quart: 1
        case .gallon: 1
        case .pound: 1
        case .liter: 1
        case .kilogram: 1
        default: 0
        }
    }

    var stepUpThreshold: Double {
        switch self {
        case .pinch: 2.0
        case .dash: 2.0
        case .teaspoon: 4.5
        case .tablespoon: 3.5
        case .fluidOunce: 9.5
        case .cup: 3.0
        case .pint: 2.5
        case .quart: 4.5
        case .ounce: 16
        case .milliliter: 1250
        case .gram: 1250
        default: 0
        }
    }

    var stepDownMultiplier: Double {
        switch self {
        case .dash: Fraction.oneHalf.rawValue
        case .teaspoon: Fraction.oneEighth.rawValue
        case .tablespoon: Fraction.oneThird.rawValue
        case .fluidOunce: Fraction.oneHalf.rawValue
        case .cup: Fraction.oneEighth.rawValue
        case .pint: Fraction.oneHalf.rawValue
        case .quart: Fraction.oneHalf.rawValue
        case .gallon: Fraction.oneFourth.rawValue
        case .pound: Fraction.oneSixteenth.rawValue
        case .liter: Fraction.oneThousandth.rawValue
        case .kilogram: Fraction.oneThousandth.rawValue
        default: 0
        }
    }

    var stepUpMultiplier: Double {
        switch self {
        case .pinch: Fraction.oneHalf.rawValue
        case .dash: Fraction.oneEighth.rawValue
        case .teaspoon: Fraction.oneThird.rawValue
        case .tablespoon: Fraction.oneHalf.rawValue
        case .fluidOunce: Fraction.oneEighth.rawValue
        case .cup: Fraction.oneHalf.rawValue
        case .pint: Fraction.oneHalf.rawValue
        case .quart: Fraction.oneFourth.rawValue
        case .ounce: Fraction.oneSixteenth.rawValue
        case .milliliter: Fraction.oneThousandth.rawValue
        case .gram: Fraction.oneThousandth.rawValue
        default: 0
        }
    }

    var stepDownUnit: MeasurementUnit? {
        switch self {
        case .dash: .pinch
        case .teaspoon: .dash
        case .tablespoon: .teaspoon
        case .fluidOunce: .tablespoon
        case .cup: .fluidOunce
        case .pint: .cup
        case .quart: .pint
        case .gallon: .quart
        case .pound: .ounce
        case .liter: .milliliter
        case .kilogram: .gram
        default: nil
        }
    }

    var stepUpUnit: MeasurementUnit? {
        switch self {
        case .pinch: .dash
        case .dash: .teaspoon
        case .teaspoon: .tablespoon
        case .tablespoon: .fluidOunce
        case .fluidOunce: .cup
        case .cup: .pint
        case .pint: .quart
        case .quart: .gallon
        case .ounce: .pound
        case .milliliter: .liter
        case .gram: .kilogram
        default: nil
        }
    }

    var shouldRoundWhenTranslated: Bool {
        switch self {
        case .liter, .kilogram:
            false
        default:
            true
        }
    }

    var isQuantifiable: Bool {
        switch self {
        case .noUnit:
            false
        default:
            true
        }
    }
}
