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
            name: "Graphics",
            targets: ["Graphics"]
        ),
        .library(
            name: "Templates",
            targets: ["Templates"]
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
            url: "https://github.com/richardpiazza/GraphPoint.git",
            .upToNextMinor(from: "3.4.0")
        ),
    ],
    targets: [
        .target(
            name: "VectorPlus",
            dependencies: ["SVG", "Templates", .product(name: "ArgumentParser", package: "swift-argument-parser")]
        ),
        .target(
            name: "SVG",
            dependencies: ["XMLCoder"]
        ),
        .target(
            name: "Graphics",
            dependencies: ["SVG", "GraphPoint"]
        ),
        .target(
            name: "Templates",
            dependencies: ["SVG", "Graphics"]
        ),
        .testTarget(
            name: "VectorPlusTests",
            dependencies: ["VectorPlus", "SVG"]
        ),
    ]
)
