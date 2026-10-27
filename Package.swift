// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "SupportSDK", platforms: [.iOS(.v17)],
    products: [.library(name: "SupportSDK", targets: ["SupportSDK"])],
    targets: [.binaryTarget(name: "SupportSDK", url: "https://github.com/gabruini/supportsdk-ios-dist/releases/download/0.1.4/SupportSDK.xcframework.zip", checksum: "2438c84223ce17b00fb9a632f40a990a06bf6a8f406a36f3e393b21b958a0e1a")])
