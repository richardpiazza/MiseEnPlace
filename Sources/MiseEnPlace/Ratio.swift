import Foundation

/// ## Ratio
/// Holds the relation between volume and weight
public struct Ratio {
    public var volume: Double = 1.0
    public var weight: Double = 1.0
    
    public init() {
        
    }
    
    public init(volume: Double, weight: Double) {
        self.volume = volume
        self.weight = weight
    }
    
    fileprivate struct RatioIngredient: Ingredient {
        var uuid: String = UUID().uuidString
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
    
    fileprivate struct RatioElement: FormulaElement {
        var uuid: String = UUID().uuidString
        var creationDate: Date = Date()
        var modificationDate: Date = Date()
        var sequence: Int = 0
        var amount: Double = 0.0
        var unit: MeasurementUnit = .each
        var inverseRecipe: Recipe?
        var ingredient: Ingredient? = RatioIngredient()
        var recipe: Recipe?
    }
    
    public static func makeRatio(volume: MiseEnPlace.Measurement, weight: MiseEnPlace.Measurement) throws -> Ratio {
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
        
        var volumeMeasuredIngredient = RatioElement()
        volumeMeasuredIngredient.amount = volume.amount
        volumeMeasuredIngredient.unit = volume.unit
        
        var weightMeasuredIngredient = RatioElement()
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
