// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "MiseEnPlace",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v4),
    ],
    products: [
        .library(
            name: "MiseEnPlace",
            targets: ["MiseEnPlace"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "MiseEnPlace"
        ),
        .testTarget(
            name: "MiseEnPlaceTests",
            dependencies: ["MiseEnPlace"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
