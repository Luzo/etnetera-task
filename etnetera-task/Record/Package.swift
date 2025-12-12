// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Record",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Record",
            targets: [
                "Record",
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.0.0"),
        .package(name: "Utils", path: "../Utils")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Record",
            dependencies: [
                .product(name: "FactoryKit", package: "Factory"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "Utils", package: "Utils"),
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "RecordTests",
            dependencies: [
                "Record",
                .product(name: "FactoryTesting", package: "Factory")
            ]
        ),
    ]
)
