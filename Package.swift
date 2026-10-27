// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "SupportSDK", platforms: [.iOS(.v17)],
    products: [.library(name: "SupportSDK", targets: ["SupportSDK"])],
    targets: [.binaryTarget(name: "SupportSDK", url: "https://github.com/gabruini/supportsdk-ios-dist/releases/download/0.1.2/SupportSDK.xcframework.zip", checksum: "bc03e241655f17e342c9c7972468bdbd91d2a3b1d4c814ed4bbbe8186b930003")])
