// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.55.0"),
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
