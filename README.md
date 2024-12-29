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
* [`Descriptive`](Sources/MiseEnPlace/Descriptive.swift):
* [`Multimedia`](Sources/MiseEnPlace/Multimedia.swift):
* [`Proportioned`](Sources/MiseEnPlace/Proportioned.swift):
* [`Quantifiable`](Sources/MiseEnPlace/Quantifiable.swift):
* [`Sequenced`](Sources/MiseEnPlace/Sequenced.swift):
* [`Unique`](Sources/MiseEnPlace/Unique.swift):

*Collective Protocols*:
* [`Ingredient`](Sources/MiseEnPlace/Ingredient.swift): Represents any raw material/ingredient
* [`FormulaElement`](Sources/MiseEnPlace/FormulaElement.swift):
* [`ProcedureElement`](Sources/MiseEnPlace/ProcedureElement.swift):
* [`Recipe`](Sources/MiseEnPlace/Recipe.swift): 

### Enumerations

* [`Fraction`](Sources/MiseEnPlace/Fraction.swift):
* [`Integral`](Sources/MiseEnPlace/Integral.swift):
* [`MeasurementMethod`](Sources/MiseEnPlace/MeasurementMethod.swift):
* [`MeasurementSystem`](Sources/MiseEnPlace/MeasurementSystem.swift):
* [`MeasurementSystemMethod`](Sources/MiseEnPlace/MeasurementSystemMethod.swift):

### Ingredient Ratios

🔎…

### Scaling Formulas

🔎…

## Installation

**MiseEnPlace** is distributed using the [Swift Package Manager](https://swift.org/package-manager). To install it into a project, add it as a dependency within your `Package.swift` manifest, or through [Xcode](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app):

```swift
let package = Package(
...
    dependencies: [
        .package(url: "https://github.com/richardpiazza/MiseEnPlace.git", .upToNextMajor(from: "6.0.0"))
    ],
    ...
)
```

Then import **MiseEnPlace** wherever you'd like to use it:

```swift
import MiseEnPlace
```
