// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "SupportSDK", platforms: [.iOS(.v17)],
    products: [.library(name: "SupportSDK", targets: ["SupportSDK"])],
    targets: [.binaryTarget(name: "SupportSDK", url: "https://github.com/gabruini/supportsdk-ios-dist/releases/download/0.2.0/SupportSDK.xcframework.zip", checksum: "76f966e58795b38bb20695aef13169fdee0770282b6bbb71261b54896d9f0784")])
