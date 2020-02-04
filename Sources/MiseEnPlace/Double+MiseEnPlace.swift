import Foundation

public extension Double {
    /// Rounds to the number of decimal-places specifed
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    /// An interpreted representation of the value, composed of the
    /// intergral and fraction as needed.
    var fractionedString: String {
        guard self.isNaN == false else {
            return "0"
        }
        
        let decomposedAmount = modf(self)
        
        guard decomposedAmount.1 > 0.0 else {
            return "\(Int(decomposedAmount.0))"
        }
        
        let intergral = Int(decomposedAmount.0)
        let fraction = Fraction(proximateValue: decomposedAmount.1)
        
        switch fraction {
        case .zero:
            return "\(intergral)"
        case .one:
            return "\(Int(intergral + 1))"
        default:
            if intergral == 0 {
                return "\(fraction.description)"
            } else {
                return "\(intergral)\(fraction.description)"
            }
        }
    }
}

public extension Double {
    @available(*, deprecated, message: "Intended for testing; use `XCTestEqual(_:_:accuracy:)`")
    func equals(_ value: Double, precision: Int) -> Bool {
        if self == value {
            return true
        }
        
        switch (precision) {
        case 0: return Int(self) == Int(value)
        case 1: return fabs(self - value) < 0.1
        case 2: return fabs(self - value) < 0.01
        case 3: return fabs(self - value) < 0.001
        case 4: return fabs(self - value) < 0.0001
        case 5: return fabs(self - value) < 0.00001
        case 6: return fabs(self - value) < 0.000001
        default: return false
        }
    }
    
    /// Converts an amount from one `MeasurementUnit` to another `MeasurementUnit`
    /// within the same `MeasurementSystemMethod`
    @available(*, deprecated, message: "")
    func convert(from fromUnit: MeasurementUnit, to toUnit: MeasurementUnit) -> Double {
        let measurementUnits = MeasurementUnit.measurementUnits(forMeasurementSystemMethod: toUnit.measurementSystemMethod)
        guard measurementUnits.contains(fromUnit) else {
            return 0.0
        }
        
        var currentIndex = -1
        var goalIndex = -1
        
        for (index, unit) in measurementUnits.enumerated() {
            if unit == fromUnit {
                currentIndex = index
            }
            if unit == toUnit {
                goalIndex = index
            }
        }
        
        guard currentIndex != goalIndex else {
            return self
        }
        
        var stepDirection = 0
        var nextValue = self
        
        if goalIndex - currentIndex > 0 {
            stepDirection = 1
            nextValue = self * fromUnit.stepUpMultiplier
        } else {
            stepDirection = -1
            nextValue = self / fromUnit.stepDownMultiplier
        }
        
        let nextIndex = currentIndex + stepDirection
        let nextUnit = measurementUnits[nextIndex]
        
        return nextValue.convert(from: nextUnit, to: toUnit)
    }
}
