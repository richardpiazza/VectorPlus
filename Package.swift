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
            url: "https://github.com/richardpiazza/Swift2D.git",
            from: "0.1.1"
        ),
        .package(
            url: "https://github.com/richardpiazza/SwiftColor.git",
            from: "0.1.1"
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
                "SVG",
                "Graphics",
                "Templates",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "ShellOut", package: "ShellOut"),
            ]
        ),
        .target(
            name: "SVG",
            dependencies: ["XMLCoder"]
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
            dependencies: ["Executable", "SVG", "Graphics", "Templates"]
        ),
    ]
)
