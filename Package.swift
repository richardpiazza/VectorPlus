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
            name: "VectorPlus",
            targets: ["VectorPlus"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.1"),
        .package(url: "https://github.com/richardpiazza/SwiftSVG", from: "0.9.0"),
        .package(url: "https://github.com/richardpiazza/SwiftColor", from: "0.2.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut", from: "2.3.0"),
    ],
    targets: [
        .target(
            name: "Executable",
            dependencies: [
                "SwiftSVG",
                "VectorPlus",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "ShellOut", package: "ShellOut"),
            ]
        ),
        .target(
            name: "VectorPlus",
            dependencies: ["SwiftSVG", "SwiftColor"]
        ),
        .testTarget(
            name: "VectorPlusTests",
            dependencies: ["Executable", "SwiftSVG", "VectorPlus"]
        ),
    ]
)
