import Foundation

/// The relation between volume and weight
public struct Ratio: Equatable, CustomStringConvertible {
    
    /// A common/default ratio where volume is equivalent to weight
    public static let oneToOne: Ratio = Ratio(volume: 1.0, weight: 1.0)
    /// A common/default ratio where volume is twice the measurement in weight
    public static let twoToOne: Ratio = Ratio(volume: 2.0, weight: 1.0)
    /// A common/default ratio where weight is twice the measurement in volume
    public static let oneToTwo: Ratio = Ratio(volume: 1.0, weight: 2.0)
    
    public var volume: Double
    public var weight: Double
    
    public init(
        volume: Double = 1.0,
        weight: Double = 1.0
    ) {
        self.volume = volume
        self.weight = weight
    }
    
    public init(_ proportioned: Proportioned) {
        self.volume = proportioned.volume
        self.weight = proportioned.weight
    }
    
    /// A string representation of this ratio in the format of **{volume}:{weight}**
    ///
    /// For Example: _1:1_.
    public var description: String {
        let v = significantDigitFormatter.string(for: volume) ?? String(describing: volume)
        let w = significantDigitFormatter.string(for: weight) ?? String(describing: weight)
        
        #if canImport(ObjectiveC)
        return String(format: "%@:%@", v, w)
        #else
        let vC: CVarArg? = v.withCString { return $0 }
        let wC: CVarArg? = w.withCString { return $0 }
        
        if let cV = vC, let cW = wC {
            return String(format: "%s:%s", cV, cW)
        } else {
            return "\(v):\(w)"
        }
        #endif
    }
    
    /// Conversion factor used when going from one `MeasurementMethod` to another `MeasurementMethod`.
    public func multiplier(converting from: MeasurementMethod, to: MeasurementMethod) -> Double {
        switch (from, to) {
        case (.volume, .weight):
            return weight / volume
        case (.weight, .volume):
            return volume / weight
        default:
            return 1.0
        }
    }
    
    public static func makeRatio(volume: Quantification, weight: Quantification) throws -> Ratio {
        guard volume.amount > 0.0 else {
            throw MiseEnPlaceError.measurementAmount(method: .volume)
        }
        
        guard volume.unit.measurementMethod == .volume else {
            throw MiseEnPlaceError.measurementUnit(method: .volume)
        }
        
        guard weight.amount > 0.0 else {
            throw MiseEnPlaceError.measurementAmount(method: .weight)
        }
        
        guard weight.unit.measurementMethod == .weight else {
            throw MiseEnPlaceError.measurementUnit(method: .weight)
        }
        
        var volumeMeasuredIngredient = AnyFormulaElement(
            measured: .ingredient(AnyIngredient())
        )
        volumeMeasuredIngredient.amount = volume.amount
        volumeMeasuredIngredient.unit = volume.unit
        
        var weightMeasuredIngredient = AnyFormulaElement(
            measured: .ingredient(AnyIngredient())
        )
        weightMeasuredIngredient.amount = weight.amount
        weightMeasuredIngredient.unit = weight.unit
        
        let volumeAmount: Double
        let weightAmount: Double
        
        if Configuration.metricPreferred {
            volumeAmount = try volumeMeasuredIngredient.amount(for: .milliliter)
            weightAmount = try weightMeasuredIngredient.amount(for: .gram)
        } else {
            volumeAmount = try volumeMeasuredIngredient.amount(for: .fluidOunce)
            weightAmount = try weightMeasuredIngredient.amount(for: .ounce)
        }
        
        guard volumeAmount != 0.0 && weightAmount != 0.0 else {
            throw MiseEnPlaceError.unhandledConversion
        }
        
        var ratioVolume = volumeAmount
        var ratioWeight = weightAmount
        
        if volumeAmount >= weightAmount {
            ratioVolume = ratioVolume / ratioWeight
            ratioWeight = ratioWeight / ratioWeight
        } else {
            ratioWeight = ratioWeight / ratioVolume
            ratioVolume = ratioVolume / ratioVolume
        }
        
        return Ratio(volume: ratioVolume, weight: ratioWeight)
    }
}

fileprivate var significantDigitFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.usesSignificantDigits = true
    formatter.maximumSignificantDigits = 3
    return formatter
}()
