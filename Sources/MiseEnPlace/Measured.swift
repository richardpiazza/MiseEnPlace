public enum Measured {
    case ingredient(Ingredient)
    case recipe(Recipe)
}

public extension Measured {
    var ingredient: Ingredient? {
        if case let .ingredient(value) = self {
            return value
        }
        
        return nil
    }
    
    var recipe: Recipe? {
        if case let .recipe(value) = self {
            return value
        }
        
        return nil
    }
}
