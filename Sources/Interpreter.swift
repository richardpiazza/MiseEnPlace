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
        var units: [MeasurementUnit] = []
        let components = self.componentize(scaleMeasure)
        for component in components {
            units.append(component.unit)
            
            if interpretation.isEmpty == true {
                interpretation = self.translate(component, abbreviate:abbreviate)
            } else {
                let extend = " " + self.translate(component, abbreviate: abbreviate)
                interpretation += extend
            }
        }
        
        guard units.count > 1 else {
            return interpretation
        }
        
        let uniques = Array(Set(units))
        guard uniques.count == 1 else {
            return interpretation
        }
        
        guard let unit = uniques.first else {
            return interpretation
        }
        
        let unitValue = (abbreviate) ? unit.abbreviation : unit.name
        
        return interpretation.replacingOccurrencesExceptLast(" \(unitValue)", with: "")
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
        case .Kilogram, .Liter, .Pound, .Tablespoon, .Teaspoon, .FluidOunce, .Cup, .Pint, .Quart, .Gallon:
            if amountComponents.0 != 0 {
                components.append(ScaleMeasure(amount: amountComponents.0, unit: measurementUnit))
            }
            
            if let stepDownUnit = measurementUnit.stepDownUnit where amountComponents.1 < measurementUnit.stepDownThreshold {
                let stepDownMeasure = Converter.convert(amountComponents.1, fromMeasurementUnit: measurementUnit, toMeasurementUnit: stepDownUnit)
                components.append(ScaleMeasure(amount: stepDownMeasure, unit: stepDownUnit))
            } else {
                components.append(ScaleMeasure(amount: amountComponents.1, unit: measurementUnit))
            }
            
        default:
            components.append(ScaleMeasure(amount: scaleMeasure.amount, unit: measurementUnit))
        }
        
        return components
    }
    
    /// Rounds a provided fraction to a more common fraction
    public static func nearestKnownFraction(decimal: Float) -> Float {
        
        if decimal >= Constants.SevenEighths {
            return 1.0
        } else if decimal >= Constants.ThreeFourthsDecimalBoundary {
            return Constants.ThreeFourths
        } else if decimal >= Constants.TwoThirdsDecimalBoundary {
            return Constants.TwoThirds
        } else if decimal >= Constants.FiveEighthsDecimalBoundary {
            return Constants.FiveEighths
        } else if decimal >= Constants.OneHalfDecimalBoundary {
            return Constants.OneHalf
        } else if decimal >= Constants.OneThirdDecimalBoundary {
            return Constants.OneThird
        } else if decimal >= Constants.OneFourthDecimalBoundary {
            return Constants.OneFourth
        }
        
        return 0.0
    }
    
    /// Returns the unicode symbol as a `String` for a common fraction.
    public static func symbolForFraction(fraction: Float) -> String {
        if fraction == Constants.SevenEighths || fraction.twoDecimalValue == Constants.SevenEighths.twoDecimalValue {
            return Constants.SevenEighthsSymbol
        } else if fraction == Constants.ThreeFourths || fraction.twoDecimalValue == Constants.ThreeFourths.twoDecimalValue {
            return Constants.ThreeFourthsSymbol
        } else if fraction == Constants.TwoThirds || fraction.twoDecimalValue == Constants.TwoThirds.twoDecimalValue {
            return Constants.TwoThirdsSymbol
        } else if fraction == Constants.FiveEighths || fraction.twoDecimalValue == Constants.FiveEighths.twoDecimalValue {
            return Constants.FiveEighthsSymbol
        } else if fraction == Constants.OneHalf || fraction.twoDecimalValue == Constants.OneHalf.twoDecimalValue {
            return Constants.OneHalfSymbol
        } else if fraction == Constants.OneThird || fraction.twoDecimalValue == Constants.OneThird.twoDecimalValue {
            return Constants.OneThirdSymbol
        } else if fraction == Constants.OneFourth || fraction.twoDecimalValue == Constants.OneFourth.twoDecimalValue {
            return Constants.OneFourthSymbol
        }
        
        return ""
    }
}
