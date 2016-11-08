//===----------------------------------------------------------------------===//
//
// Measurement.swift
//
// Copyright (c) 2016 Richard Piazza
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

/// ## Measurement
/// An amount/unit pairing
public struct CookingMeasurement {
    /// Changes the default behavior of the `Measurement` translation functions.
    public static var abbreviateTranslations: Bool = false
    
    fileprivate static var singleDecimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        return formatter
    }
    
    fileprivate static var significantDigitFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true
        formatter.maximumSignificantDigits = 2
        return formatter
    }
    
    public var amount: Double = 0.0
    public var unit: MeasurementUnit = .each
    
    public init() {
        
    }
    
    public init(amount: Double, unit: MeasurementUnit) {
        self.amount = amount
        self.unit = unit
    }
    
    /// Returns this `Measurement` in terms of the current `MeasurementUnit` and
    /// the next smallest `MeasurementUnit` if needed.
    public var components: [CookingMeasurement] {
        guard unit != .asNeeded && unit != .each else {
            return [self]
        }
        
        let decomposedAmount = modf(amount)
        if decomposedAmount.1 == 0.0 {
            return [self]
        }
        
        var components = [CookingMeasurement]()
        
        switch unit {
        case .kilogram, .liter, .pound, .tablespoon, .teaspoon, .fluidOunce, .cup, .pint, .quart, .gallon:
            if decomposedAmount.0 != 0 {
                components.append(CookingMeasurement(amount: decomposedAmount.0, unit: unit))
            }
            
            if let stepDownUnit = unit.stepDownUnit, decomposedAmount.1 < unit.stepDownThreshold {
                let stepDownMeasurement = decomposedAmount.1.convert(from: unit, to: stepDownUnit)
                components.append(CookingMeasurement(amount: stepDownMeasurement, unit: stepDownUnit))
            } else {
                components.append(CookingMeasurement(amount: decomposedAmount.1, unit: unit))
            }
        default:
            components.append(self)
        }
        
        return components
    }
    
    /// Returns a "human-readable" form of this `Measurement`.
    public var translation: String {
        return translation(abbreviated: CookingMeasurement.abbreviateTranslations)
    }
    
    /// Returns a "human-readable" form of this `Measurement` with the option to 
    /// force abbreviations.
    public func translation(abbreviated: Bool) -> String {
        switch unit {
        case .asNeeded:
            return unit.name(abbreviated: abbreviated)
        case .gram, .kilogram, .milliliter, .liter:
            return metricTranslation(abbreviated: abbreviated)
        default:
            return fractionTranslation(abbreviated: abbreviated)
        }
    }
    
    /// Returns a "human-readable" form of the componentized `Measurement`.
    public var componentsTranslation: String {
        return componentsTranslation(abbreviated: CookingMeasurement.abbreviateTranslations)
    }
    
    /// Returns a "human-readable" form of the componentized `Measurement` with the
    /// option to force abbreviations.
    public func componentsTranslation(abbreviated: Bool) -> String {
        guard unit != .asNeeded && unit != .each else {
            return translation(abbreviated: abbreviated)
        }
        
        var interpretation = ""
        var units = [MeasurementUnit]()
        
        let components = self.components
        for component in components {
            units.append(component.unit)
            
            if interpretation.isEmpty {
                interpretation = component.translation(abbreviated: abbreviated)
            } else {
                let interpretationExtension = " \(component.translation(abbreviated: abbreviated))"
                interpretation += interpretationExtension
            }
        }
        
        guard units.count > 1 else {
            return interpretation
        }
        
        let uniqueUnits = Array(Set(units))
        guard uniqueUnits.count == 1 else {
            return interpretation
        }
        
        guard let firstUnit = uniqueUnits.first else {
            return interpretation
        }
        
        let unitName = " \(firstUnit.name(abbreviated: abbreviated))"
        
        return interpretation.replacingOccurrencesExceptLast(unitName, with: "")
    }
    
    fileprivate func metricTranslation(abbreviated: Bool) -> String {
        let unitName = unit.name(abbreviated: abbreviated)
        
        let decomposedAmount = modf(amount)
        if decomposedAmount.0 < 10.0 {
            if decomposedAmount.1 == 0.0 {
                return "\(Int(amount)) \(unitName)"
            } else {
                guard let singleDecimal = type(of: self).singleDecimalFormatter.string(from: NSNumber(value: amount)) else {
                    return "\(amount) \(unitName)"
                }
                
                return "\(singleDecimal) \(unitName)"
            }
        } else if decomposedAmount.0 < 100.0 {
            if unit.shouldRoundWhenTranslated {
                return "\(Int(round(amount))) \(unitName)"
            } else {
                return "\(Int(amount)) \(unitName)"
            }
        } else {
            if unit.shouldRoundWhenTranslated {
                return "\(Int(round(amount / 5) * 5)) \(unitName)"
            } else {
                return "\(Int(amount)) \(unitName)"
            }
        }
    }
    
    fileprivate func fractionTranslation(abbreviated: Bool) -> String {
        let unitName = unit.name(abbreviated: abbreviated)
        
        let decomposedAmount = modf(amount)
        guard decomposedAmount.1 > 0.0 else {
            return "\(Int(amount)) \(unitName)"
        }
        
        let intergral = Int(decomposedAmount.0)
        let fraction = Fraction(closestValue: decomposedAmount.1)
        
        switch fraction {
        case .one:
            return "\(Int(intergral + 1)) \(unitName)"
        case .zero:
            if intergral == 0 {
                guard let significantAmount = type(of: self).significantDigitFormatter.string(from: NSNumber(value: amount)) else {
                    return "\(amount) \(unitName)"
                }
                
                return "\(significantAmount) \(unitName)"
            } else {
                return "\(intergral) \(unitName)"
            }
        default:
            if intergral == 0 {
                return "\(fraction.stringValue) \(unitName)"
            } else {
                return "\(intergral)\(fraction.stringValue) \(unitName)"
            }
        }
    }
}
