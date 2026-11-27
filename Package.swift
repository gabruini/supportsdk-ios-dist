// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "SupportSDK", platforms: [.iOS(.v17)],
    products: [.library(name: "SupportSDK", targets: ["SupportSDK"])],
    targets: [.binaryTarget(name: "SupportSDK", url: "https://github.com/gabruini/supportsdk-ios-dist/releases/download/0.3.2/SupportSDK.xcframework.zip", checksum: "23be1a2d2f5489a82fa31e68de80ee95770a04bfd71d98a205988e175b980540")])
