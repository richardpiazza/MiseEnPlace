import Foundation

/// **MiseEnPlace** Configuration Variables
public struct Configuration {
    
    /// Ways in which `MeasurementSystemMethod` conversions can take place
    public enum ConversionOrder {
        /// `MeasurementMethod` then `MeasurementSystem`.
        ///
        /// In the example converting from 'cup' to 'kilograms':
        /// * amount as US Volume
        /// * amount as US Weight
        /// * amount as Metric Weight
        case methodThanSystem
        /// `MeasurementSystem` then `MeasurementMethod`.
        ///
        /// In the example converting from 'cup' to 'kilograms':
        /// * amount as US Volume
        /// * amount as Metric Volume
        /// * amount as Metric Weight
        case systemThanMethod
    }
    
    /// The _loose_ number of 'grams' to use for converting to/from 'ounces'.
    internal static let looseGramsPerOunce: Double = 30.0
    /// The _precise_ number of 'grams' to use for converting to/from 'ounces'.
    internal static let preciseGramsPerOunce: Double = 28.349523
    /// The _loose_ number of 'milliliters' to use for converting to/from 'fluid ounces'.
    internal static let looseMillilitersPerFluidOunce: Double = 30.0
    /// The _precise_ number of 'milliliters' to use for converting to/from 'fluid ounces'.
    internal static let preciseMillilitersPerFluidOunce: Double = 29.573529
    
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
    
    public static var locale: Locale = Locale.current {
        didSet {
            singleDecimalFormatter.locale = locale
            significantDigitFormatter.locale = locale
        }
    }
    
    public static var metricPreferred: Bool {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            return locale.measurementSystem != .us
        } else {
            return locale.usesMetricSystem
        }
        #else
        return locale.usesMetricSystem
        #endif
    }
    
    /// Changes the default behavior of the `Quantification` translation functions.
    public static var abbreviateTranslations: Bool = false
    
    /// Replaces precise oz->g / floz->ml conversions with 30g/30ml respectively.
    public static var useLooseConversions: Bool = false
    
    /// The number of **milliliters** to use for converting to/from **fluid ounces**.
    public static var millilitersPerFluidOunce: Double {
        return (useLooseConversions) ? looseMillilitersPerFluidOunce : preciseMillilitersPerFluidOunce
    }
    
    /// The number of **grams** to use for converting to/from **ounces**.
    public static var gramsPerOunce: Double {
        return (useLooseConversions) ? looseGramsPerOunce : preciseGramsPerOunce
    }
    
    /// The method by which cross `MeasurementSystemMethod` conversions are performed. The default is `.methodThanSystem`.
    public static var conversionOrder: ConversionOrder = .methodThanSystem
}
