// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "SupportSDKPreview", platforms: [.iOS(.v17)],
    products: [.library(name: "SupportSDK", targets: ["SupportSDK"])],
    targets: [.binaryTarget(name: "SupportSDK", url: "https://github.com/gabruini/supportsdk-ios-dist/releases/download/0.1.2/SupportSDKPreview.xcframework.zip", checksum: "b1958c159cbff7c6ac399d09129f9e35f0970cfa24bdcbd053b932e32ae2e160")])
