//===----------------------------------------------------------------------===//
//
// MeasurementUnit.swift
//
// Copyright (c) 2015 Richard Piazza
// https://github.com/richardpiazza/MiseEnPlace
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//===----------------------------------------------------------------------===//

import Foundation

/// ## MeasurementUnit
/// The `MeasurementUnit` enum is the heart of the MiseEnPlace framework. This enum 
/// represents some unit of measure, along with `MeasurementSystem` and `MeasurementMethod`
/// that it belongs to.
/// All of the logic for how and when to convert to other units and amounts is 
/// contained within the enum.
public enum MeasurementUnit: Int {
    
    case asNeeded = 9000
    case each = 9001
    
    case pinch = 1100
    case dash = 1101
    case teaspoon = 1102
    case tablespoon = 1103
    case fluidOunce = 1104
    case cup = 1105
    case pint = 1106
    case quart = 1107
    case gallon = 1108
    
    case ounce = 1200
    case pound = 1201
    
    case milliliter = 2100
    case liter = 2101
    
    case gram = 2200
    case kilogram = 2201
    
    public static func allMeasurementUnits() -> [MeasurementUnit] {
        return [.asNeeded, .each, .pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon, .ounce, .pound, .milliliter, .liter, .gram, .kilogram]
    }
    
    public static func quantifiableMeasurementUnits() -> [MeasurementUnit] {
        return [.pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon, .ounce, .pound, .milliliter, .liter, .gram, .kilogram]
    }
    
    /// Provides an array of `MeasurementUnit` enums that correspond to the provided `MeasurementSystemMethod` enum
    public static func measurementUnits(forMeasurementSystemMethod measurementSystemMethod: MeasurementSystemMethod) -> [MeasurementUnit] {
        switch measurementSystemMethod {
        case .usVolume: return [.pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon]
        case .usMass: return [.ounce, .pound]
        case .metricVolume: return [.milliliter, .liter]
        case .metricMass: return [.gram, .kilogram]
        }
    }
    
    public static func measurementUnits(forMeasurementMethod measurementMethod: MeasurementMethod) -> [MeasurementUnit] {
        switch measurementMethod {
        case .volume: return [.pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon, .milliliter, .liter]
        case .mass: return [.ounce, .pound, .gram, .kilogram]
        }
    }
    
    public init?(stringValue: String) {
        for unit in MeasurementUnit.allMeasurementUnits() {
            if unit.name == stringValue {
                self = unit
                return
            }
        }
        
        switch stringValue {
        case "Quanity":
            self = .each
            return
        case "FluidOunce":
            self = .fluidOunce
            return
        case "Mililitre":
            self = .milliliter
            return
        case "Litre":
            self = .liter
            return
        default:
            return nil
        }
    }
    
    public var name: String {
        switch self {
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
    
    public var abbreviation: String {
        switch self {
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
        return (abbreviated) ? abbreviation : name
    }
    
    public var measurementSystem: MeasurementSystem? {
        switch self {
        case .asNeeded, .each:
            return nil
        case .pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon, .ounce, .pound:
            return .us
        case .milliliter, .liter, .gram, .kilogram:
            return .metric
        }
    }
    
    public var measurementMethod: MeasurementMethod? {
        switch self {
        case .asNeeded, .each:
            return nil
        case .pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon, .milliliter, .liter:
            return .volume
        case .ounce, .pound, .gram, .kilogram:
            return .mass
        }
    }
    
    public var measurementSystemMethod: MeasurementSystemMethod? {
        switch self {
        case .asNeeded, .each:
            return nil
        case .pinch, .dash, .teaspoon, .tablespoon, .fluidOunce, .cup, .pint, .quart, .gallon:
            return .usVolume
        case .ounce, .pound:
            return .usMass
        case .milliliter, .liter:
            return .metricVolume
        case .gram, .kilogram:
            return .metricMass
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
        case .dash: return Fractions.oneHalf
        case .teaspoon: return Fractions.oneEighth
        case .tablespoon: return Fractions.oneThird
        case .fluidOunce: return Fractions.oneHalf
        case .cup: return Fractions.oneEighth
        case .pint: return Fractions.oneHalf
        case .quart: return Fractions.oneHalf
        case .gallon: return Fractions.oneFourth
        case .pound: return Fractions.oneSixteenth
        case .liter: return Fractions.oneThousandth
        case .kilogram: return Fractions.oneThousandth
        default: return 0
        }
    }
    
    public var stepUpMultiplier: Double {
        switch self {
        case .pinch: return Fractions.oneHalf
        case .dash: return Fractions.oneEighth
        case .teaspoon: return Fractions.oneThird
        case .tablespoon: return Fractions.oneHalf
        case .fluidOunce: return Fractions.oneEighth
        case .cup: return Fractions.oneHalf
        case .pint: return Fractions.oneHalf
        case .quart: return Fractions.oneFourth
        case .ounce: return Fractions.oneSixteenth
        case .milliliter: return Fractions.oneThousandth
        case .gram: return Fractions.oneThousandth
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
        case .liter: return false
        case .kilogram: return false
        default: return true
        }
    }
}
