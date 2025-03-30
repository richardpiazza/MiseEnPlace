import Foundation

public extension Double {
    /// Rounds to the number of decimal-places specified
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    /// A representation of the instance in terms of a _whole_ number and `Fraction`.
    ///
    /// For example:
    /// * `1.25` = `(1, .oneFourth)`
    /// * `8.0` = `(8, nil)`
    /// * `8.999` = `(9, nil)`
    func floatingPoint() -> (whole: Int, fraction: Fraction?) {
        guard !isNaN else {
            return (0, nil)
        }

        guard !isInfinite else {
            return (0, nil)
        }

        let decomposedAmount = modf(self)
        let whole = Int(decomposedAmount.0)

        guard decomposedAmount.1 > 0.0 else {
            return (whole, nil)
        }

        let fraction = Fraction(proximateValue: decomposedAmount.1)

        return (whole, fraction)
    }

    /// An interpreted representation of the value, composed of the integral and fraction as needed.
    var fractionedString: String {
        let components = floatingPoint()
        switch components.fraction {
        case .none:
            return components.whole.formatted(.number.precision(.fractionLength(0)))
        case .one:
            return (components.whole + 1).formatted(.number.precision(.fractionLength(0)))
        case .some(let fraction):
            if components.whole == 0 {
                return fraction.description
            } else {
                return components.whole.formatted(.number.precision(.fractionLength(0))) + fraction.description
            }
        }
    }
}
