// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "JahezCentral",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "JahezCentral", targets: ["JahezCentral"]),
    ],
    dependencies: [
        .package(path: "../JahezDomain"),
        .package(path: "../JahezData"),
    ],
    targets: [
        .target(
            name: "JahezCentral",
            dependencies: [
                .product(name: "JahezDomain", package: "JahezDomain"),
                .product(name: "JahezData", package: "JahezData"),
            ]
        ),
        .testTarget(
            name: "JahezCentralTests",
            dependencies: ["JahezCentral"]
        ),
    ]
)
