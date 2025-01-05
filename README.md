<p align="center">
    <img src="Resources/MiseEnPlace.png" width="1000" max-width="90%" alt="MiseEnPlace" />
</p>

<p align="center">A framework for converting and interpreting common measurements used in cooking.</p>

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Frichardpiazza%2FMiseEnPlace%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/richardpiazza/MiseEnPlace)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Frichardpiazza%2FMiseEnPlace%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/richardpiazza/MiseEnPlace)

## Usage

### Protocols

The framework consists of several protocols that define specific types and behaviors.

*Component Protocols*:
* [`Descriptive`](Sources/MiseEnPlace/Descriptive.swift): Properties that describe and categorize an element.
* [`Multimedia`](Sources/MiseEnPlace/Multimedia.swift): Protocol for interactive with element images.
* [`Proportioned`](Sources/MiseEnPlace/Proportioned.swift): Parameters that indicate a volume-to-weight ratio.
* [`Quantifiable`](Sources/MiseEnPlace/Quantifiable.swift): Parameters that indicate a 'measurement'.
* [`Sequenced`](Sources/MiseEnPlace/Sequenced.swift): Properties that describe the order of elements.
* [`Unique`](Sources/MiseEnPlace/Unique.swift): The properties needed to determine uniqueness of elements.

*Collective Protocols*:
* [`Ingredient`](Sources/MiseEnPlace/Ingredient.swift): Represents any raw material/ingredient
* [`FormulaElement`](Sources/MiseEnPlace/FormulaElement.swift): A measurement of some `Ingredient` or `Recipe`.
* [`ProcedureElement`](Sources/MiseEnPlace/ProcedureElement.swift): A step in the preparation of a `Recipe`.
* [`Recipe`](Sources/MiseEnPlace/Recipe.swift): A compilation of measurements and procedures.

### Enumerations

* [`Fraction`](Sources/MiseEnPlace/Fraction.swift): Commonly used fractions (¼, ½, ⅔, etc.)
* [`Integral`](Sources/MiseEnPlace/Integral.swift): Commonly used integrals for quick entry.
* [`MeasurementMethod`](Sources/MiseEnPlace/MeasurementMethod.swift): Representation of the _ways_ in which something can be measured.
* [`MeasurementSystem`](Sources/MiseEnPlace/MeasurementSystem.swift): The _types_ of systems used to measure (US, Metric)
* [`MeasurementSystemMethod`](Sources/MiseEnPlace/MeasurementSystemMethod.swift): Combined representation of a measurement 'system' and 'method'.

### Ingredient Ratios

Understanding the volume-to-weight ratio of `Ingredient`s is the key to scaling and transforming acurately.
Water, for instance, has a `1:1` ratio, meaning that 1 Ounce (or gram) is equal to 1 Fluid Ounce (or milliliter).
Whereas All Purpose (Plain) Flour takes up more volume than it weighs; a ratio of `1.882:1`.

This ratio allows for the transofmration of any measurement of an ingredient into another system.
Tablespoons, Cups, and Pounds can be converted into Grams or Milliliters (or the other way around).  

### Scaling Formulas

A formula is the collection of measured Ingredients (or other Recipes) for a specific Recipe.
A simple Italian Bread has the formula:
* 1.8 kg AP/Plain Flour
* 28 g Active Dry Yeast
* 28 g Salt
* 955 mL Water

The elements about can produce 1 large loaf or two small loaves weighing a total of 702.5 Grams.
But, what if you wanted 5 small loaves? This is where _scaling_ a `Recipe` comes in.

```swift
let recipe: Recipe
let scaledFormula: [FormulaElement] = recipe.scale(by: 2.5)
// 4.5 kg Flour
// 70 g Yeast
// 70 g Salt
// 2388 mL Water
```

## Installation

**MiseEnPlace** is distributed using the [Swift Package Manager](https://swift.org/package-manager). To install it into a project, add it as a dependency within your `Package.swift` manifest, or through [Xcode](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app):

```swift
let package = Package(
    …
    dependencies: [
        .package(url: "https://github.com/richardpiazza/MiseEnPlace.git", .upToNextMajor(from: "6.0.0"))
    ],
    …
)
```

Then import **MiseEnPlace** wherever you'd like to use it:

```swift
import MiseEnPlace
```
