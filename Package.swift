// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "swggrmm",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "swggrmm", targets: ["swggrmm"])
    ],
    dependencies: [
        .package(url: "https://github.com/Swiftgram/TDLibKit", branch: "main")
    ],
    targets: [
        .target(
            name: "swggrmm",
            dependencies: ["TDLibKit"],
            path: "SimpleIOSApp"
        )
    ]
)
