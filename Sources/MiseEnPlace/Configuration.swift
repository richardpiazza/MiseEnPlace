import Foundation

/// _MiseEnPlace_ Congifuration Variables
public struct Configuration {
    
    internal static let looseOunceGram: Double = 30.0
    internal static let preciseOunceGram: Double = 28.349523
    internal static let looseFluidOunceMilliliter: Double = 30.0
    internal static let preciseFluidOunceMilliliter: Double = 29.573529
    
    internal static var singleDecimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.locale = self.locale
        return formatter
    }
    
    internal static var significantDigitFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true
        formatter.maximumSignificantDigits = 2
        formatter.locale = self.locale
        return formatter
    }
    
    public static var locale: Locale = Locale.current
    
    /// Changes the default behavior of the `Measurement` translation functions.
    public static var abbreviateTranslations: Bool = false
    
    /// Replaces precise oz->g / floz->ml conversions with 30g/30ml respectively.
    public static var useLooseConversions: Bool = false
    
    /// Multiplier for volume conversion: fluid ounces to milliliters.
    public static var fluidOunceMilliliter: Double {
        return (useLooseConversions) ? looseFluidOunceMilliliter : preciseFluidOunceMilliliter
    }
    
    /// Multiplier for weight conversions: ounces to grams.
    public static var ounceGram: Double {
        return (useLooseConversions) ? looseOunceGram : preciseOunceGram
    }
    
    /// A measurement typical of a 'small' portion size
    public static var smallMeasurement: Quantification {
        if locale.usesMetricSystem {
            return Quantification(amount: 100.0, unit: .gram)
        }

        return Quantification(amount: 1.0, unit: .ounce)
    }

    /// A measurement typical of a 'large' portion size
    public static var largeMeasurement: Quantification {
        if locale.usesMetricSystem {
            return Quantification(amount: 1.0, unit: .kilogram)
        }

        return Quantification(amount: 1.0, unit: .pound)
    }
}
