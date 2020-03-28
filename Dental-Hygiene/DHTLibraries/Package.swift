// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DHTLibraries",
    platforms: [
        .iOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DHTAccess",
            targets: ["DHTAccess"]),
        .library(
            name: "DHTTimer",
            targets: ["DHTTimer"]),
    ],
    targets: [
        .target(
            name: "DHTAccess",
            dependencies: []),
        .target(
            name: "DHTTimer",
            dependencies: []),
        .testTarget(
            name: "DHTAccessTests",
            dependencies: ["DHTAccess"]),
    ]
)
