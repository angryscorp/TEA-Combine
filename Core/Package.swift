// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Core",
            targets: [
                "Architecture",
                "MainScene",
                "ChildScene"
            ]
        )
    ],
    targets: [
        .target(name: "Architecture"),
        .target(
            name: "MainScene",
            dependencies: ["Architecture"],
            path: "Sources/Scenes/MainScene"
        ),
        .target(
            name: "ChildScene",
            dependencies: ["Architecture"],
            path: "Sources/Scenes/ChildScene"
        ),
        .testTarget(
            name: "MainSceneTests",
            dependencies: [
                "Architecture",
                "MainScene",
            ]
        )
    ]
)

