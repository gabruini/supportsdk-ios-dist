// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "SupportSDKPreview", platforms: [.iOS(.v17)],
    products: [.library(name: "SupportSDK", targets: ["SupportSDK"])],
    targets: [.binaryTarget(name: "SupportSDK", url: "https://github.com/gabruini/supportsdk-ios-dist/releases/download/0.3.2/SupportSDKPreview.xcframework.zip", checksum: "f7db78a8c2d748043657fcf132ba53a751e9e7e95b70f0a9da2099d825123120")])
