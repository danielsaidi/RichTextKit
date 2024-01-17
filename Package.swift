// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "RichTextKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "RichTextKit",
            targets: ["RichTextKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/danielsaidi/MockingKit.git", .upToNextMajor(from: "1.1.0"))
    ],
    targets: [
        .target(
            name: "RichTextKit",
            dependencies: [],
            resources: [.process("Resources")],
            swiftSettings: [
                .define("macOS", .when(platforms: [.macOS])),
                .define("iOS", .when(platforms: [.iOS, .macCatalyst]))
            ]
        ),
        .testTarget(
            name: "RichTextKitTests",
            dependencies: ["RichTextKit", "MockingKit"],
            swiftSettings: [
                .define("macOS", .when(platforms: [.macOS])),
                .define("iOS", .when(platforms: [.iOS, .macCatalyst]))
            ]
        )
    ]
)
