// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "MiseEnPlace",
    platforms: [
        .macOS(.v12),
        .macCatalyst(.v15),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8),
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
