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
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            .upToNextMinor(from: "0.3.1")
        ),
        .package(
            url: "https://github.com/richardpiazza/SwiftSVG.git",
            .branch("main")
        ),
        .package(
            url: "https://github.com/richardpiazza/SwiftColor.git",
            from: "0.1.3"
        ),
        .package(
            url: "https://github.com/JohnSundell/ShellOut.git",
            from: "2.3.0"
        ),
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
