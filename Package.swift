// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIGestureLibrary",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "SwiftUIGestureLibrary",
            targets: ["SwiftUIGestureLibrary"]),
        .library(
            name: "SwiftUIGestureLibraryCore",
            targets: ["SwiftUIGestureLibraryCore"]),
        .library(
            name: "SwiftUIGestureLibraryHaptics",
            targets: ["SwiftUIGestureLibraryHaptics"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-async-algorithms.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftUIGestureLibraryCore",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Algorithms", package: "swift-algorithms"),
            ],
            path: "Sources/Core"),
        .target(
            name: "SwiftUIGestureLibraryHaptics",
            dependencies: ["SwiftUIGestureLibraryCore"],
            path: "Sources/Haptics"),
        .target(
            name: "SwiftUIGestureLibrary",
            dependencies: [
                "SwiftUIGestureLibraryCore",
                "SwiftUIGestureLibraryHaptics",
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ],
            path: "Sources/Gestures"),
        .testTarget(
            name: "SwiftUIGestureLibraryTests",
            dependencies: ["SwiftUIGestureLibrary"],
            path: "Tests/UnitTests"),
        .testTarget(
            name: "SwiftUIGestureLibraryIntegrationTests",
            dependencies: ["SwiftUIGestureLibrary"],
            path: "Tests/IntegrationTests"),
        .testTarget(
            name: "SwiftUIGestureLibraryUITests",
            dependencies: ["SwiftUIGestureLibrary"],
            path: "Tests/UITests"),
    ]
) 