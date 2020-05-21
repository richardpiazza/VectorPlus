// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VectorPlus",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
    ],
    products: [
        .executable(
            name: "vectorplus",
            targets: ["Executable"]
        ),
        .library(
            name: "SVG",
            targets: ["SVG"]
        ),
        .library(
            name: "Swift2D",
            targets: ["Swift2D"]
        ),
        .library(
            name: "Graphics",
            targets: ["Graphics"]
        ),
        .library(
            name: "Templates",
            targets: ["Templates"]
        ),
        .library(
            name: "VectorPlus",
            targets: [
                "SVG",
                "Swift2D",
                "Graphics",
                "Templates"
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "0.0.5"
        ),
        .package(
            url: "https://github.com/MaxDesiatov/XMLCoder.git",
            from: "0.11.1"
        ),
        .package(
            url: "https://github.com/richardpiazza/SwiftColor.git",
            from: "0.1.0"
        ),
    ],
    targets: [
        .target(
            name: "Executable",
            dependencies: [
                "SVG",
                "Swift2D",
                "Graphics",
                "Templates",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .target(
            name: "SVG",
            dependencies: ["XMLCoder"]
        ),
        .target(
            name: "Swift2D",
            dependencies: []
        ),
        .target(
            name: "Graphics",
            dependencies: ["SVG", "Swift2D", "SwiftColor"]
        ),
        .target(
            name: "Templates",
            dependencies: ["SVG", "Graphics", "Swift2D"]
        ),
        .testTarget(
            name: "VectorPlusTests",
            dependencies: ["Executable", "SVG", "Swift2D", "SwiftColor", "Graphics", "Templates"]
        ),
    ]
)
