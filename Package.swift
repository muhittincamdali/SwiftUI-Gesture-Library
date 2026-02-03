// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "GestureKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "GestureKit",
            targets: ["GestureKit"]
        )
    ],
    targets: [
        .target(
            name: "GestureKit",
            path: "Sources/GestureKit",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "GestureKitTests",
            dependencies: ["GestureKit"],
            path: "Tests/GestureKitTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
