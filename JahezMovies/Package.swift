// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "JahezMovies",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "JahezMovies", targets: ["JahezMovies"]),
    ],
    dependencies: [
        .package(path: "../JahezDomain"),
    ],
    targets: [
        .target(
            name: "JahezMovies",
            dependencies: [
                .product(name: "JahezDomain", package: "JahezDomain"),
            ]
        ),
        .testTarget(
            name: "JahezMoviesTests",
            dependencies: ["JahezMovies", "JahezDomain"]
        ),
    ]
)
