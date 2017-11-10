import Foundation

public extension Double {
    
    public func equals(_ value: Double, precision: Int) -> Bool {
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
    
    public func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    public var fractionedString: String {
        guard self.isNaN == false else {
            return "0"
        }
        
        let decomposedAmount = modf(self)
        
        guard decomposedAmount.1 > 0.0 else {
            return "\(Int(decomposedAmount.0))"
        }
        
        let intergral = Int(decomposedAmount.0)
        let fraction = Fraction(closestValue: decomposedAmount.1)
        
        switch fraction {
        case .zero:
            return "\(intergral)"
        case .one:
            return "\(Int(intergral + 1))"
        default:
            if intergral == 0 {
                return "\(fraction.stringValue)"
            } else {
                return "\(intergral)\(fraction.stringValue)"
            }
        }
    }
}
