// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VectorPlus",
    platforms: [
        .macOS(.v13),
        .macCatalyst(.v16),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
    ],
    products: [
        .executable(
            name: "vector-plus",
            targets: ["vector-plus"]
        ),
        .library(
            name: "VectorPlus",
            targets: ["VectorPlus"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.7.0"),
        .package(url: "https://github.com/swiftlang/swift-testing.git", from: "6.2.0"),
        .package(url: "https://github.com/richardpiazza/SwiftSVG.git", from: "0.12.0"),
        .package(url: "https://github.com/richardpiazza/SwiftColor.git", from: "0.3.1"),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.3.0"),
    ],
    targets: [
        .executableTarget(
            name: "vector-plus",
            dependencies: [
                "VectorPlus",
                .product(name: "SwiftSVG", package: "SwiftSVG"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(
                    name: "ShellOut",
                    package: "ShellOut",
                    condition: .when(
                        platforms: [
                            .macOS,
                            .linux,
                        ]
                    )
                ),
            ]
        ),
        .target(
            name: "VectorPlus",
            dependencies: [
                .product(name: "SwiftSVG", package: "SwiftSVG"),
                .product(name: "SwiftColor", package: "SwiftColor"),
            ]
        ),
        .testTarget(
            name: "VectorPlusTests",
            dependencies: [
                "vector-plus",
                "VectorPlus",
                .product(name: "SwiftSVG", package: "SwiftSVG"),
                .product(name: "Testing", package: "swift-testing"),
            ]
        ),
    ]
)

for target in package.targets {
    var settings = target.swiftSettings ?? []
    settings.append(contentsOf: [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("StrictConcurrency=complete"),
    ])
    target.swiftSettings = settings
}
