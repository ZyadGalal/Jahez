// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "JahezData",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "JahezData", targets: ["JahezData"]),
    ],
    dependencies: [
        .package(path: "../JahezDomain"),
    ],
    targets: [
        .target(
            name: "JahezData",
            dependencies: [
                .product(name: "JahezDomain", package: "JahezDomain"),
            ],
            resources: [
                .process("Resources/TMDBCache.xcdatamodeld"),
            ]
        ),
    ]
)
