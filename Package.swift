// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FirstCyclingSwift",
    platforms: [
        .iOS(.v15),
        .watchOS(.v8),
        .macOS(.v11),
        .macCatalyst(.v14),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "FirstCyclingSwift",
            targets: ["FirstCyclingSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.6.0"),
    ],
    targets: [
        .target(
            name: "FirstCyclingSwift", 
            dependencies: ["SwiftSoup"]
        ),
        .testTarget(
            name: "FirstCyclingSwiftTests",
            dependencies: ["FirstCyclingSwift"],
            exclude: ["Resources/Mocks"]
        )
    ]
)
