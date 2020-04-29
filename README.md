<p align="center">
    <img src="MiseEnPlace.png" width="1000" max-width="90%" alt="MiseEnPlace" />
</p>

<p align="center">
    <img src="https://github.com/richardpiazza/MiseEnPlace/workflows/Swift/badge.svg" />
    <img src="https://img.shields.io/badge/Swift-5.1-orange.svg" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/swiftpm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
     <img src="https://img.shields.io/badge/platforms-mac+linux-brightgreen.svg?style=flat" alt="Mac + Linux" />
    <a href="https://twitter.com/richardpiazza">
        <img src="https://img.shields.io/badge/twitter-@richardpiazza-blue.svg?style=flat" alt="Twitter: @richardpiazza" />
    </a>
</p>

<p align="center">A framework for converting and interpreting common measurements used in cooking.</p>

## Installation

**MiseEnPlace** is distributed using the [Swift Package Manager](https://swift.org/package-manager). To install it into a project, add it as a dependency within your `Package.swift` manifest, or through [Xcode](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app):

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/richardpiazza/MiseEnPlace.git", from: "5.0.0")
    ],
    ...
)
```

Then import **MiseEnPlace** wherever you'd like to use it:

```swift
import MiseEnPlace
```

## Usage

