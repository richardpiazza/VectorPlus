// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VectorPlus",
    platforms: [
        .macOS(.v12),
        .macCatalyst(.v15),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        .executable(
            name: "vectorplus",
            targets: ["Executable"]
        ),
        .library(
            name: "VectorPlus",
            targets: ["VectorPlus"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.5.0")),
        .package(url: "https://github.com/richardpiazza/SwiftSVG.git", .upToNextMajor(from: "0.11.0")),
        .package(url: "https://github.com/richardpiazza/SwiftColor.git", .upToNextMajor(from: "0.2.0")),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", .upToNextMajor(from: "2.3.0")),
    ],
    targets: [
        .executableTarget(
            name: "Executable",
            dependencies: [
                "VectorPlus",
                .product(name: "SwiftSVG", package: "SwiftSVG"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "ShellOut", package: "ShellOut"),
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
                "Executable",
                "VectorPlus",
                .product(name: "SwiftSVG", package: "SwiftSVG"),
            ]
        ),
    ]
)
