// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "SupportSDK", platforms: [.iOS(.v17)],
    products: [.library(name: "SupportSDK", targets: ["SupportSDK"])],
    targets: [.binaryTarget(name: "SupportSDK", url: "https://github.com/gabruini/supportsdk-ios-dist/releases/download/0.3.1/SupportSDK.xcframework.zip", checksum: "b4e138da0dc8d581a7729ae90d9888ba1b319e3eba12c4d017328ca6f3ea3555")])
