import Foundation

/// The relation between volume and weight
public struct Ratio {
    
    /// A common/default ratio where volume is equivalent to weight
    public static let oneToOne: Ratio = Ratio(volume: 1.0, weight: 1.0)
    /// A common/default ratio where volume is twice the measurement in weight
    public static let twoToOne: Ratio = Ratio(volume: 2.0, weight: 1.0)
    /// A common/default ratio where weight is twice the measurement in volume
    public static let oneToTwo: Ratio = Ratio(volume: 1.0, weight: 2.0)
    
    public var volume: Double = 1.0
    public var weight: Double = 1.0
    
    public init() {
        
    }
    
    public init(volume: Double, weight: Double) {
        self.volume = volume
        self.weight = weight
    }
    
    /// Conversion factor to used when going from one `MeasurementMethod` to another `MeasurementMethod`.
    public func multiplier(converting from: MeasurementMethod, to: MeasurementMethod) -> Double {
        switch (from, to) {
        case (.volume, .weight):
            return volume / weight
        case (.weight, .volume):
            return weight / volume
        default:
            return 1.0
        }
    }
    
    fileprivate struct RatioIngredient: Ingredient {
        var uuid: UUID = UUID()
        var creationDate: Date = Date()
        var modificationDate: Date = Date()
        var name: String?
        var commentary: String?
        var classification: String?
        var imagePath: String?
        var volume: Double = 1.0
        var weight: Double = 1.0
        var amount: Double = 0.0
        var unit: MeasurementUnit = .each
    }
    
    fileprivate struct RatioMeasuredIngredient: FormulaElement {
        var uuid: UUID = UUID()
        var creationDate: Date = Date()
        var modificationDate: Date = Date()
        var sequence: Int = 0
        var amount: Double = 0.0
        var unit: MeasurementUnit = .each
        var inverseRecipe: Recipe?
        var ingredient: Ingredient? = RatioIngredient()
        var recipe: Recipe?
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
        
        var volumeMeasuredIngredient = RatioMeasuredIngredient()
        volumeMeasuredIngredient.amount = volume.amount
        volumeMeasuredIngredient.unit = volume.unit
        
        var weightMeasuredIngredient = RatioMeasuredIngredient()
        weightMeasuredIngredient.amount = weight.amount
        weightMeasuredIngredient.unit = weight.unit
        
        let volumeAmount = try volumeMeasuredIngredient.amount(for: .fluidOunce)
        let weightAmount = try weightMeasuredIngredient.amount(for: .ounce)
        
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
    
    @available(*, deprecated, message: "Use `makeRatio(volume:weight:)`.")
    public static func makeRatio(volumeConvertable: Convertable, weightConvertable: Convertable) -> Ratio {
        let volume = volumeConvertable.amount(for: .fluidOunce)
        let weight = weightConvertable.amount(for: .ounce)
        
        guard volume != 0.0 && weight != 0.0 else {
            return Ratio(volume: volume, weight: weight)
        }
        
        var ratioVolume = volume
        var ratioWeight = weight
        
        if volume >= weight {
            ratioVolume = ratioVolume / ratioWeight
            ratioWeight = ratioWeight / ratioWeight
        } else {
            ratioWeight = ratioWeight / ratioVolume
            ratioVolume = ratioVolume / ratioVolume
        }
        
        return Ratio(volume: ratioVolume, weight: ratioWeight)
    }
}
