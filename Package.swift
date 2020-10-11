// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "RefreshControlKit",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "RefreshControlKit", targets: ["RefreshControlKit"]),
    ],
    targets: [
        .target(name: "RefreshControlKit", dependencies: [], path: "Sources"),
        // .testTarget(name: "RefreshControlKitTests", dependencies: ["RefreshControlKit"]),
    ],
    swiftLanguageVersions: [.v5]
)
