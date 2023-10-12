// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
            resources: [.process("Resources")]),
        .testTarget(
            name: "RichTextKitTests",
            dependencies: ["RichTextKit", "MockingKit"]),
    ]
)
