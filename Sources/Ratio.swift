import Foundation

/// # Ratio
///
/// The relation between volume and weight
///
public struct Ratio: Proportioned {
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
            throw Error.measurementAmount(method: .volume)
        }
        
        guard volume.unit.measurementMethod == .volume else {
            throw Error.measurementUnit(method: .volume)
        }
        
        guard weight.amount > 0.0 else {
            throw Error.measurementAmount(method: .weight)
        }
        
        guard weight.unit.measurementMethod == .weight else {
            throw Error.measurementUnit(method: .weight)
        }
        
        var volumeMeasuredIngredient = RatioElement()
        volumeMeasuredIngredient.amount = volume.amount
        volumeMeasuredIngredient.unit = volume.unit
        
        var weightMeasuredIngredient = RatioElement()
        weightMeasuredIngredient.amount = weight.amount
        weightMeasuredIngredient.unit = weight.unit
        
        let volumeAmount = 0.0 //try volumeMeasuredIngredient.convert(to: .fluidOunce).amount
        let weightAmount = 0.0 //try weightMeasuredIngredient.convert(to: .ounce).amount
        
        guard volumeAmount != 0.0 && weightAmount != 0.0 else {
            throw Error.unhandledConversion
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

