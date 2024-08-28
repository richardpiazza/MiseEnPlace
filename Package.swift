// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "MiseEnPlace",
    platforms: [
        .macOS(.v13),
        .macCatalyst(.v16),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
    ],
    products: [
        .library(
            name: "MiseEnPlace",
            targets: ["MiseEnPlace"]
        )
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
