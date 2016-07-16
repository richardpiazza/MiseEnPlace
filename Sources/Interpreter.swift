//===----------------------------------------------------------------------===//
//
// Interpreter.swift
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

public let SevenEighths: Float = 0.875
public let SevenEighthsSymbol: String = "⅞"

public let ThreeFourths: Float = 0.75
public let ThreeFourthsDecimalBoundary: Float = 0.708333
public let ThreeFourthsSymbol: String = "¾"

public let TwoThirds: Float = 0.666666
public let TwoThirdsDecimalBoundary: Float = 0.645833
public let TwoThirdsSymbol: String = "⅔"

public let FiveEighths: Float = 0.625
public let FiveEighthsDecimalBoundary: Float = 0.5625
public let FiveEighthsSymbol: String = "⅝"

public let OneHalf: Float = 0.5
public let OneHalfDecimalBoundary: Float = 0.416666
public let OneHalfSymbol: String = "½"

public let OneThird: Float = 0.3333333
public let OneThirdDecimalBoundary: Float = 0.291666
public let OneThirdSymbol: String = "⅓"

public let OneFourth: Float = 0.25
public let OneFourthDecimalBoundary: Float = 0.208333
public let OneFourthSymbol: String = "¼"

public let OneSixth: Float = 0.166666
public let OneSixthSymbol: String = "⅙"

public let OneEighth: Float = 0.125
public let OneEighthSymbol: String = "⅛"

public let OneSixteenth: Float = 0.0625
public let OneThousandth: Float = 0.001

/// ## Interpreter
/// Provides functions needed to produce human-readable measurements.
public class Interpreter {
    
    /// Forces an abbreviated form of each `MeasurementUnit`
    public static var useAbbreviation: Bool = false
    
    /// Uses the `Componentize` and `Translate` functions to present a 
    /// human readable format of a `ScaleMeasure`
    public static func interpret(scaleMeasure: ScaleMeasure) -> String {
        return self.interpret(scaleMeasure, abbreviate: Interpreter.useAbbreviation)
    }
    
    /// Uses the `Componentize` and `Translate` functions to present a 
    /// human readable format of a `ScaleMeasure`.
    /// Passing a value for the abbreviate: parameter overrides default behavior 
    /// of the MeasurementUnit Configuration.
    public static func interpret(scaleMeasure: ScaleMeasure, abbreviate:Bool) -> String {
        let measurementUnit = scaleMeasure.unit
        
        if measurementUnit == .AsNeeded || measurementUnit == .Each {
            return self.translate(scaleMeasure, abbreviate:abbreviate)
        }
        
        var interpretation: String = ""
        
        let components = self.componentize(scaleMeasure)
        for component in components {
            if interpretation.isEmpty == true {
                interpretation = self.translate(component, abbreviate:abbreviate)
            } else {
                let extend = " " + self.translate(component, abbreviate: abbreviate)
                interpretation += extend
            }
        }
        
        return interpretation
    }
    
    /// Returns a human readable string from a `ScaleMeasure` amount and unit.
    public static func translate(scaleMeasure: ScaleMeasure) -> String {
        return self.translate(scaleMeasure, abbreviate: Interpreter.useAbbreviation)
    }
    
    /// Returns a human readable string from a `ScaleMeasure` amount and unit.
    /// Passing a value for the abbreviate: parameter overrides default behavior 
    /// of the MeasurementUnit Configuration.
    public static func translate(scaleMeasure: ScaleMeasure, abbreviate:Bool) -> String {
        let measurementUnit = scaleMeasure.unit
        
        switch measurementUnit {
        case .AsNeeded:
            return abbreviate ? measurementUnit.abbreviation : measurementUnit.name
        case .Gram, .Kilogram, .Milliliter, .Liter:
            return self.translateMetric(scaleMeasure, abbreviate:abbreviate)
        default:
            return self.translateFractional(scaleMeasure, abbreviate:abbreviate)
        }
    }
    
    private static func translateMetric(scaleMeasure: ScaleMeasure, abbreviate:Bool) -> String {
        let measurementUnit = scaleMeasure.unit
        let measurementAmount = scaleMeasure.amount
        let amountComponents = modf(measurementAmount)
        
        if amountComponents.0 < 10 {
            if amountComponents.1 == 0 {
                return "\(Int(measurementAmount)) " + (abbreviate ? measurementUnit.abbreviation : measurementUnit.name)
            } else {
                return "\(measurementAmount.oneDecimalValue) " + (abbreviate ? measurementUnit.abbreviation : measurementUnit.name)
            }
        } else if amountComponents.0 < 100 {
            if measurementUnit.shouldRoundWhenInterpreted {
                return "\(Int(roundf(measurementAmount))) " + (abbreviate ? measurementUnit.abbreviation : measurementUnit.name)
            } else {
                return "\(Int(measurementAmount)) " + (abbreviate ? measurementUnit.abbreviation : measurementUnit.name)
            }
        } else {
            if measurementUnit.shouldRoundWhenInterpreted {
                return "\(Int(roundf(measurementAmount / 5) * 5)) " + (abbreviate ? measurementUnit.abbreviation : measurementUnit.name)
            } else {
                return "\(Int(measurementAmount)) " + (abbreviate ? measurementUnit.abbreviation : measurementUnit.name)
            }
        }
    }
    
    private static func translateFractional(scaleMeasure: ScaleMeasure, abbreviate:Bool) -> String {
        let measurementUnit = scaleMeasure.unit
        let measurementAmount = scaleMeasure.amount
        let amountComponents = modf(measurementAmount)
        
        if amountComponents.1 == 0 {
            return "\(Int(measurementAmount)) " + (abbreviate ? measurementUnit.abbreviation : measurementUnit.name)
        }
        
        var translatedAmount: Int = Int(amountComponents.0)
        let nearestFraction = self.nearestKnownFraction(amountComponents.1)
        if nearestFraction == 1 {
            translatedAmount = translatedAmount + 1
            return "\(translatedAmount) " + (abbreviate ? measurementUnit.abbreviation : measurementUnit.name)
        } else if nearestFraction == 0 {
            if translatedAmount == 0 {
                return "\(measurementAmount) " + (abbreviate ? measurementUnit.abbreviation : measurementUnit.name)
            } else {
                return "\(translatedAmount)" + " " + (abbreviate ? measurementUnit.abbreviation : measurementUnit.name)
            }
        } else {
            let fractionSymbol = self.symbolForFraction(nearestFraction)
            if translatedAmount == 0 {
                return fractionSymbol + " " + (abbreviate ? measurementUnit.abbreviation : measurementUnit.name)
            } else {
                return "\(translatedAmount)" + fractionSymbol + " " + (abbreviate ? measurementUnit.abbreviation : measurementUnit.name)
            }
        }
    }
    
    /// Returns a `[ScaleMeasure]` of up to size 2 with the passed `ScaleMeasure` 
    /// unit and the next smallest unit if needed.
    public static func componentize(scaleMeasure: ScaleMeasure) -> [ScaleMeasure] {
        let measurementUnit = scaleMeasure.unit
        
        if measurementUnit == .AsNeeded {
            return [scaleMeasure]
        } else if measurementUnit == .Each {
            return [scaleMeasure]
        }
        
        let amountComponents = modf(scaleMeasure.amount)
        if amountComponents.1 == 0 {
            return [scaleMeasure]
        }
        
        var components: [ScaleMeasure] = [ScaleMeasure]()
        
        switch measurementUnit {
        case .Kilogram:
            if amountComponents.0 != 0 {
                components.append((amountComponents.0, measurementUnit))
            }
            let gram = Converter.convert(amountComponents.1, fromMeasurementUnit: .Kilogram, toMeasurementUnit: .Gram)
            components.append((gram, .Gram))
        case .Liter:
            if amountComponents.0 != 0 {
                components.append((amountComponents.0, measurementUnit))
            }
            let milliliter = Converter.convert(amountComponents.1, fromMeasurementUnit: .Liter, toMeasurementUnit: .Milliliter)
            components.append((milliliter, .Milliliter))
        case .Pound:
            if amountComponents.0 != 0 {
                components.append((amountComponents.0, measurementUnit))
            }
            let ounce = Converter.convert(amountComponents.1, fromMeasurementUnit: .Pound, toMeasurementUnit: .Ounce)
            components.append((ounce, .Ounce))
        case .Tablespoon:
            if amountComponents.0 != 0 {
                components.append((amountComponents.0, measurementUnit))
            }
            let teaspoon = Converter.convert(amountComponents.1, fromMeasurementUnit: .Tablespoon, toMeasurementUnit: .Teaspoon)
            components.append((teaspoon, .Teaspoon))
        case .FluidOunce:
            if amountComponents.0 != 0 {
                components.append((amountComponents.0, measurementUnit))
            }
            let tablespoon = Converter.convert(amountComponents.1, fromMeasurementUnit: .FluidOunce, toMeasurementUnit: .Tablespoon)
            components.append((tablespoon, .Tablespoon))
        case .Cup:
            if amountComponents.0 != 0 {
                components.append((amountComponents.0, measurementUnit))
            }
            let fluidOunce = Converter.convert(amountComponents.1, fromMeasurementUnit: .Cup, toMeasurementUnit: .FluidOunce)
            components.append((fluidOunce, .FluidOunce))
        case .Pint:
            if amountComponents.0 != 0 {
                components.append((amountComponents.0, measurementUnit))
            }
            let cup = Converter.convert(amountComponents.1, fromMeasurementUnit: .Pint, toMeasurementUnit: .Cup)
            components.append((cup, .Cup))
        case .Quart:
            if amountComponents.0 != 0 {
                components.append((amountComponents.0, measurementUnit))
            }
            let pint = Converter.convert(amountComponents.1, fromMeasurementUnit: .Quart, toMeasurementUnit: .Pint)
            components.append((pint, .Pint))
        case .Gallon:
            if amountComponents.0 != 0 {
                components.append((amountComponents.0, measurementUnit))
            }
            let quart = Converter.convert(amountComponents.1, fromMeasurementUnit: .Gallon, toMeasurementUnit: .Quart)
            components.append((quart, .Quart))
        default:
            components.append((scaleMeasure.amount, measurementUnit))
        }
        
        return components
    }
    
    /// Rounds a provided fraction to a more common fraction
    public static func nearestKnownFraction(decimal: Float) -> Float {
        
        if decimal >= SevenEighths {
            return 1.0
        } else if decimal >= ThreeFourthsDecimalBoundary {
            return ThreeFourths
        } else if decimal >= TwoThirdsDecimalBoundary {
            return TwoThirds
        } else if decimal >= FiveEighthsDecimalBoundary {
            return FiveEighths
        } else if decimal >= OneHalfDecimalBoundary {
            return OneHalf
        } else if decimal >= OneThirdDecimalBoundary {
            return OneThird
        } else if decimal >= OneFourthDecimalBoundary {
            return OneFourth
        }
        
        return 0.0
    }
    
    /// Returns the unicode symbol as a `String` for a common fraction.
    public static func symbolForFraction(fraction: Float) -> String {
        if fraction == SevenEighths || fraction.twoDecimalValue == SevenEighths.twoDecimalValue {
            return SevenEighthsSymbol
        } else if fraction == ThreeFourths || fraction.twoDecimalValue == ThreeFourths.twoDecimalValue {
            return ThreeFourthsSymbol
        } else if fraction == TwoThirds || fraction.twoDecimalValue == TwoThirds.twoDecimalValue {
            return TwoThirdsSymbol
        } else if fraction == FiveEighths || fraction.twoDecimalValue == FiveEighths.twoDecimalValue {
            return FiveEighthsSymbol
        } else if fraction == OneHalf || fraction.twoDecimalValue == OneHalf.twoDecimalValue {
            return OneHalfSymbol
        } else if fraction == OneThird || fraction.twoDecimalValue == OneThird.twoDecimalValue {
            return OneThirdSymbol
        } else if fraction == OneFourth || fraction.twoDecimalValue == OneFourth.twoDecimalValue {
            return OneFourthSymbol
        }
        
        return ""
    }
}
