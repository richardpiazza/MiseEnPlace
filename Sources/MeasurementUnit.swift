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
    
    public var measurementSystem: MeasurementSystem? {
        switch self {
        case .pinch: return .us
        case .dash: return .us
        case .teaspoon: return .us
        case .tablespoon: return .us
        case .fluidOunce: return .us
        case .cup: return .us
        case .pint: return .us
        case .quart: return .us
        case .gallon: return .us
        case .ounce: return .us
        case .pound: return .us
        case .milliliter: return .metric
        case .liter: return .metric
        case .gram: return .metric
        case .kilogram: return .metric
        default: return nil
        }
    }
    
    public var measurementMethod: MeasurementMethod? {
        switch self {
        case .pinch: return .volume
        case .dash: return .volume
        case .teaspoon: return .volume
        case .tablespoon: return .volume
        case .fluidOunce: return .volume
        case .cup: return .volume
        case .pint: return .volume
        case .quart: return .volume
        case .gallon: return .volume
        case .ounce: return .mass
        case .pound: return .mass
        case .milliliter: return .volume
        case .liter: return .volume
        case .gram: return .mass
        case .kilogram: return .mass
        default: return nil
        }
    }
    
    public var measurementSystemMethod: MeasurementSystemMethod? {
        switch self {
        case .pinch: return .usVolume
        case .dash: return .usVolume
        case .teaspoon: return .usVolume
        case .tablespoon: return .usVolume
        case .fluidOunce: return .usVolume
        case .cup: return .usVolume
        case .pint: return .usVolume
        case .quart: return .usVolume
        case .gallon: return .usVolume
        case .ounce: return .usMass
        case .pound: return .usMass
        case .milliliter: return .metricVolume
        case .liter: return .metricVolume
        case .gram: return .metricMass
        case .kilogram: return .metricMass
        default: return nil
        }
    }
    
    public var stepDownThreshold: Float {
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
    
    public var stepUpThreshold: Float {
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
    
    public var stepDownMultiplier: Float {
        switch self {
        case .dash: return Constants.OneHalf
        case .teaspoon: return Constants.OneEighth
        case .tablespoon: return Constants.OneThird
        case .fluidOunce: return Constants.OneHalf
        case .cup: return Constants.OneEighth
        case .pint: return Constants.OneHalf
        case .quart: return Constants.OneHalf
        case .gallon: return Constants.OneFourth
        case .pound: return Constants.OneSixteenth
        case .liter: return Constants.OneThousandth
        case .kilogram: return Constants.OneThousandth
        default: return 0
        }
    }
    
    public var stepUpMultiplier: Float {
        switch self {
        case .pinch: return Constants.OneHalf
        case .dash: return Constants.OneEighth
        case .teaspoon: return Constants.OneThird
        case .tablespoon: return Constants.OneHalf
        case .fluidOunce: return Constants.OneEighth
        case .cup: return Constants.OneHalf
        case .pint: return Constants.OneHalf
        case .quart: return Constants.OneFourth
        case .ounce: return Constants.OneSixteenth
        case .milliliter: return Constants.OneThousandth
        case .gram: return Constants.OneThousandth
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
    
    public var shouldRoundWhenInterpreted: Bool {
        switch self {
        case .liter: return false
        case .kilogram: return false
        default: return true
        }
    }
}
