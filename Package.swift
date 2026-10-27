// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "SupportSDK", platforms: [.iOS(.v17)],
    products: [.library(name: "SupportSDK", targets: ["SupportSDK"])],
    targets: [.binaryTarget(name: "SupportSDK", url: "https://github.com/gabruini/supportsdk-ios-dist/releases/download/0.1.0/SupportSDK.xcframework.zip", checksum: "12c0ec5906e56c7e38c6a98a0f6bff7537b634d13e25f2d47c355325b279157e")])
