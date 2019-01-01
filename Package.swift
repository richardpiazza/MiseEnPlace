// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "MiseEnPlace",
    products: [
        .library(name: "MiseEnPlace", targets: ["MiseEnPlace"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "MiseEnPlace", path: "Sources"),
        .testTarget(name: "MiseEnPlaceTests", dependencies: ["MiseEnPlace"], path: "Tests")
    ],
    swiftLanguageVersions: [.v4_2]
)

