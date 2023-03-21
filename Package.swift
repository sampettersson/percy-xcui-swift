// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "Percy XCUI Swift",
    products: [
        .library(
            name: "PercyXcui",
            targets: ["PercyXcui"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "PercyXcui",
            // Note: This contains inner folder as path so that other clients can use this repo as a package
            path: "percy-xcui/Sources")
    ]
)
