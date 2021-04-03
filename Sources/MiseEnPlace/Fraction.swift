import Foundation

/// Enumeration of commonly used fractions in cooking.
public enum Fraction: Double, CaseIterable, CustomStringConvertible {
    /// 0⁄1
    case zero = 0.0
    /// ⅟1000
    case oneThousandth = 0.001
    /// ⅟16
    case oneSixteenth = 0.0625
    /// ⅛
    case oneEighth = 0.125
    /// ⅙
    case oneSixth = 0.1666
    /// ¼
    case oneFourth = 0.25
    /// ⅓
    case oneThird = 0.3333
    /// ½
    case oneHalf = 0.5
    /// ⅝
    case fiveEighths = 0.625
    /// ⅔
    case twoThirds = 0.6666
    /// ¾
    case threeFourths = 0.75
    /// ⅞
    case sevenEighths = 0.875
    /// 1⁄1
    case one = 1.0
    
    /// Fractions that are commonly used.
    public static var commonFractions: [Fraction] {
        return allCases.filter({ $0.isCommon })
    }
    
    /// Fractions that are representable by a unicode symbol.
    public static var unicodeRepresentableFractions: [Fraction] {
        return allCases.filter({ $0.isUnicodeRepresentable })
    }
    
    /// Initialize a `Fraction` using the provided value allowing for a 0.001 tolerance.
    public init?(approximateValue value: RawValue) {
        if let fraction = Fraction(rawValue: value) {
            self = fraction
            return
        }
        
        for fraction in Fraction.allCases {
            if fraction.isApproximatelyEqual(to: value) {
                self = fraction
                return
            }
        }
        
        return nil
    }
    
    /// Initializes the `Fraction` using the closest matching value.
    ///
    /// The collection of cases is enumerated in reverse, so the largest possible match is set.
    ///
    /// There are some special conditions when using this initializer:
    /// * Values greater than 7/8 (0.875) will always report as `.one`
    /// * Values less than 1/8 (0.125) will always report as `.zero`
    public init(proximateValue value: RawValue) {
        if let fraction = Fraction(rawValue: value) {
            self = fraction
            return
        }
        
        if let fraction = Fraction(approximateValue: value) {
            switch fraction {
            case .zero, .oneThousandth, .oneSixteenth:
                self = .zero
            default:
                self = fraction
            }
            return
        }
        
        if value < Fraction.oneEighth.rawValue {
            self = .zero
            return
        }
        
        if value > Fraction.sevenEighths.rawValue {
            self = .one
            return
        }
        
        for fraction in Fraction.allCases.reversed() {
            guard let previous = fraction.previous else {
                continue
            }
            
            // half way to the 'previous' fraction
            let threshold = fraction.rawValue - ((fraction.rawValue - previous.rawValue) / 2.0)
            if value >= threshold {
                self = fraction
                return
            }
        }
        
        self = .zero
    }
    
    /// The unicode symbol (or empty string) for known fraction values.
    public var description: String {
        switch self {
        case .zero, .one: return ""
        case .oneThousandth: return "\u{215F}1000"
        case .oneSixteenth: return "\u{215F}16"
        case .oneEighth: return "⅛"
        case .oneSixth: return "⅙"
        case .oneFourth: return "¼"
        case .oneThird: return "⅓"
        case .oneHalf: return "½"
        case .fiveEighths: return "⅝"
        case .twoThirds: return "⅔"
        case .threeFourths: return "¾"
        case .sevenEighths: return "⅞"
        }
    }
    
    /// Indicates if this `Fraction` is commonly used (in cooking)
    public var isCommon: Bool {
        switch self {
        case .oneEighth, .oneFourth, .oneThird, .oneHalf, .twoThirds, .threeFourths:
            return true
        default:
            return false
        }
    }
    
    /// Indicates if this `Fraction` has a unicode symbol associated with it
    public var isUnicodeRepresentable: Bool {
        switch self {
        case .oneEighth, .oneSixth, .oneFourth, .oneThird, .oneHalf, .fiveEighths, .twoThirds, .threeFourths, .sevenEighths:
            return true
        default:
            return false
        }
    }
}

private extension Fraction {
    /// The fraction at `allCases` index - 1.
    var previous: Fraction? {
        guard let index = Fraction.allCases.firstIndex(of: self), index > 0 else {
            return nil
        }
        
        return Fraction.allCases[index - 1]
    }
    
    /// The fraction at `allCases` index + 1.
    var next: Fraction? {
        guard let index = Fraction.allCases.firstIndex(of: self), index < (Fraction.allCases.count - 1) else {
            return nil
        }
        
        return Fraction.allCases[index + 1]
    }
    
    /// Compares the 'rawValue' to the provided value at a precision of 0.001
    func isApproximatelyEqual(to: RawValue) -> Bool {
        return abs(rawValue.distance(to: to)) <= Fraction.oneThousandth.rawValue
    }
}
