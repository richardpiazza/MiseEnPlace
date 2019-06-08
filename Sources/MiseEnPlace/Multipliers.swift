import Foundation

public struct Multipliers {
    /// Replaces precise oz->g / floz->ml conversions with 30g/30ml respectively.
    @available(*, deprecated, renamed: "Configuration.useLooseConversions")
    public static var useLooseConversions: Bool = false
    @available(*, deprecated, renamed: "Configuration.looseOunceGram")
    public static let looseOunceGram: Double = 30.0
    @available(*, deprecated, renamed: "Configuration.preciseOunceGram")
    public static let preciseOunceGram: Double = 28.349523
    @available(*, deprecated, renamed: "Configuration.looseFluidOunceMilliliter")
    public static let looseFluidOunceMilliliter: Double = 30.0
    @available(*, deprecated, renamed: "Configuration.preciseFluidOunceMilliliter")
    public static let preciseFluidOunceMilliliter: Double = 29.573529
    
    @available(*, deprecated, renamed: "Configuration.fluidOunceMilliliter")
    public static var fluidOunceMilliliter: Double {
        return (useLooseConversions) ? looseFluidOunceMilliliter : preciseFluidOunceMilliliter
    }
    
    @available(*, deprecated, renamed: "Configuration.ounceGram")
    public static var ounceGram: Double {
        return (useLooseConversions) ? looseOunceGram : preciseOunceGram
    }
}
