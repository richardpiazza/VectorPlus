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
            targets: ["VectorPlus"]
        ),
        .library(
            name: "SVG",
            targets: ["SVG"]
        ),
        .library(
            name: "Translation",
            targets: ["Translation"]
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
    ],
    targets: [
        .target(
            name: "VectorPlus",
            dependencies: ["SVG", "Translation", .product(name: "ArgumentParser", package: "swift-argument-parser")]
        ),
        .target(
            name: "SVG",
            dependencies: ["XMLCoder"]
        ),
        .target(
            name: "Translation",
            dependencies: ["SVG"]
        ),
        .testTarget(
            name: "VectorPlusTests",
            dependencies: ["VectorPlus", "SVG", "Translation"]
        ),
    ]
)
