import Foundation

public extension Double {
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
