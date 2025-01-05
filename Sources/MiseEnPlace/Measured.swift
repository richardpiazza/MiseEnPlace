/// Limited subset of _any_ item that can be _measured_ (quantified amount)
public enum Measured {
    case ingredient(Ingredient)
    case recipe(Recipe)
}

public extension Measured {
    var ingredient: Ingredient? {
        guard case let .ingredient(value) = self else {
            return nil
        }
        
        return value
    }
    
    var recipe: Recipe? {
        guard case let .recipe(value) = self else {
            return nil
        }
        
        return value
    }
}
