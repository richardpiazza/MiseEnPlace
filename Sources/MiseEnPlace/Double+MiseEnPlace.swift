import Foundation

public extension Double {
    /// Rounds to the number of decimal-places specified
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    /// An interpreted representation of the value, composed of the
    /// integral and fraction as needed.
    var fractionedString: String {
        guard self.isNaN == false && self.isInfinite == false else {
            return "0"
        }
        
        let decomposedAmount = modf(self)
        
        guard decomposedAmount.1 > 0.0 else {
            return "\(Int(decomposedAmount.0))"
        }
        
        let integral = Int(decomposedAmount.0)
        let fraction = Fraction(proximateValue: decomposedAmount.1)
        
        switch fraction {
        case .zero:
            return "\(integral)"
        case .one:
            return "\(Int(integral + 1))"
        default:
            if integral == 0 {
                return "\(fraction.description)"
            } else {
                return "\(integral)\(fraction.description)"
            }
        }
    }
}
