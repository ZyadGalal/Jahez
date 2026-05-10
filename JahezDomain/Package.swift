// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "JahezDomain",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "JahezDomain", targets: ["JahezDomain"]),
    ],
    targets: [
        .target(name: "JahezDomain"),
    ]
)
