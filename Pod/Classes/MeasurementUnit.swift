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

public enum MeasurementUnit: Int {
    
    case AsNeeded = 9000
    case Each = 9001
    
    case Pinch = 1100
    case Dash = 1101
    case Teaspoon = 1102
    case Tablespoon = 1103
    case FluidOunce = 1104
    case Cup = 1105
    case Pint = 1106
    case Quart = 1107
    case Gallon = 1108
    
    case Ounce = 1200
    case Pound = 1201
    
    case Milliliter = 2100
    case Liter = 2101
    
    case Gram = 2200
    case Kilogram = 2201
    
    public static func allMeasurementUnits() -> [MeasurementUnit] {
        return [.AsNeeded, .Each, .Pinch, .Dash, .Teaspoon, .Tablespoon, .FluidOunce, .Cup, .Pint, .Quart, .Gallon, .Ounce, .Pound, .Milliliter, .Liter, .Gram, .Kilogram]
    }
    
    public static func quantifiableMeasurementUnits() -> [MeasurementUnit] {
        return [.Pinch, .Dash, .Teaspoon, .Tablespoon, .FluidOunce, .Cup, .Pint, .Quart, .Gallon, .Ounce, .Pound, .Milliliter, .Liter, .Gram, .Kilogram]
    }
    
    /// Provides an array of `MeasurementUnit` enums that correspond to the provided `MeasurementSystemMethod` enum
    public static func measurementUnits(forMeasurementSystemMethod measurementSystemMethod: MeasurementSystemMethod) -> [MeasurementUnit] {
        switch measurementSystemMethod {
        case .USVolume: return [.Pinch, .Dash, .Teaspoon, .Tablespoon, .FluidOunce, .Cup, .Pint, .Quart, .Gallon]
        case .USMass: return [.Ounce, .Pound]
        case .MetricVolume: return [.Milliliter, .Liter]
        case .MetricMass: return [.Gram, .Kilogram]
        }
    }
    
    public static func measurementUnits(forMeasurementMethod measurementMethod: MeasurementMethod) -> [MeasurementUnit] {
        switch measurementMethod {
        case .Volume: return [.Pinch, .Dash, .Teaspoon, .Tablespoon, .FluidOunce, .Cup, .Pint, .Quart, .Gallon, .Milliliter, .Liter]
        case .Mass: return [.Ounce, .Pound, .Gram, .Kilogram]
        }
    }
    
    public var name: String {
        switch self {
        case .AsNeeded: return "As Needed"
        case .Each: return "Each"
        case .Pinch: return "Pinch"
        case .Dash: return "Dash"
        case .Teaspoon: return "Teaspoon"
        case .Tablespoon: return "Tablespoon"
        case .FluidOunce: return "Fluid Ounce"
        case .Cup: return "Cup"
        case .Pint: return "Pint"
        case .Quart: return "Quart"
        case .Gallon: return "Gallon"
        case .Ounce: return "Ounce"
        case .Pound: return "Pound"
        case .Milliliter: return "Milliliter"
        case .Liter: return "Liter"
        case .Gram: return "Gram"
        case .Kilogram: return "Kilogram"
        }
    }
    
    public var abbreviation: String {
        switch self {
        case .AsNeeded: return "…"
        case .Each: return "№"
        case .Pinch: return "pn"
        case .Dash: return "ds"
        case .Teaspoon: return "tsp"
        case .Tablespoon: return "tbsp"
        case .FluidOunce: return "fl oz"
        case .Cup: return "c"
        case .Pint: return "pt"
        case .Quart: return "qt"
        case .Gallon: return "gal"
        case .Ounce: return "oz"
        case .Pound: return "lb"
        case .Milliliter: return "mL"
        case .Liter: return "L"
        case .Gram: return "g"
        case .Kilogram: return "kg"
        }
    }
    
    public var measurementSystem: MeasurementSystem? {
        switch self {
        case .Pinch: return .US
        case .Dash: return .US
        case .Teaspoon: return .US
        case .Tablespoon: return .US
        case .FluidOunce: return .US
        case .Cup: return .US
        case .Pint: return .US
        case .Quart: return .US
        case .Gallon: return .US
        case .Ounce: return .US
        case .Pound: return .US
        case .Milliliter: return .Metric
        case .Liter: return .Metric
        case .Gram: return .Metric
        case .Kilogram: return .Metric
        default: return nil
        }
    }
    
    public var measurementMethod: MeasurementMethod? {
        switch self {
        case .Pinch: return .Volume
        case .Dash: return .Volume
        case .Teaspoon: return .Volume
        case .Tablespoon: return .Volume
        case .FluidOunce: return .Volume
        case .Cup: return .Volume
        case .Pint: return .Volume
        case .Quart: return .Volume
        case .Gallon: return .Volume
        case .Ounce: return .Mass
        case .Pound: return .Mass
        case .Milliliter: return .Volume
        case .Liter: return .Volume
        case .Gram: return .Mass
        case .Kilogram: return .Mass
        default: return nil
        }
    }
    
    public var measurementSystemMethod: MeasurementSystemMethod? {
        switch self {
        case .Pinch: return .USVolume
        case .Dash: return .USVolume
        case .Teaspoon: return .USVolume
        case .Tablespoon: return .USVolume
        case .FluidOunce: return .USVolume
        case .Cup: return .USVolume
        case .Pint: return .USVolume
        case .Quart: return .USVolume
        case .Gallon: return .USVolume
        case .Ounce: return .USMass
        case .Pound: return .USMass
        case .Milliliter: return .MetricVolume
        case .Liter: return .MetricVolume
        case .Gram: return .MetricMass
        case .Kilogram: return .MetricMass
        default: return nil
        }
    }
    
    public var stepDownThreshold: Float {
        switch self {
        case .Dash: return 0.5
        case .Teaspoon: return 0.5
        case .Tablespoon: return 1
        case .FluidOunce: return 1
        case .Cup: return 1
        case .Pint: return 1
        case .Quart: return 1
        case .Gallon: return 1
        case .Pound: return 1
        case .Liter: return 1
        case .Kilogram: return 1
        default: return 0
        }
    }
    
    public var stepUpThreshold: Float {
        switch self {
        case .Pinch: return 2.0
        case .Dash: return 2.0
        case .Teaspoon: return 4.5
        case .Tablespoon: return 3.5
        case .FluidOunce: return 9.5
        case .Cup: return 2.5
        case .Pint: return 2.5
        case .Quart: return 4.5
        case .Ounce: return 16
        case .Milliliter: return 1250
        case .Gram: return 1250
        default: return 0
        }
    }
    
    public var stepDownMultiplier: Float {
        switch self {
        case .Dash: return OneHalf
        case .Teaspoon: return OneEighth
        case .Tablespoon: return OneThird
        case .FluidOunce: return OneHalf
        case .Cup: return OneEighth
        case .Pint: return OneHalf
        case .Quart: return OneHalf
        case .Gallon: return OneFourth
        case .Pound: return OneSixteenth
        case .Liter: return OneThousandth
        case .Kilogram: return OneThousandth
        default: return 0
        }
    }
    
    public var stepUpMultiplier: Float {
        switch self {
        case .Pinch: return OneHalf
        case .Dash: return OneEighth
        case .Teaspoon: return OneThird
        case .Tablespoon: return OneHalf
        case .FluidOunce: return OneEighth
        case .Cup: return OneHalf
        case .Pint: return OneHalf
        case .Quart: return OneFourth
        case .Ounce: return OneSixteenth
        case .Milliliter: return OneThousandth
        case .Gram: return OneThousandth
        default: return 0
        }
    }
    
    public var shouldRoundWhenInterpreted: Bool {
        switch self {
        case .Liter: return false
        case .Kilogram: return false
        default: return true
        }
    }
}
