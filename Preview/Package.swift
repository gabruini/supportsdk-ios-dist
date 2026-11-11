// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "SupportSDKPreview", platforms: [.iOS(.v17)],
    products: [.library(name: "SupportSDK", targets: ["SupportSDK"])],
    targets: [.binaryTarget(name: "SupportSDK", url: "https://github.com/gabruini/supportsdk-ios-dist/releases/download/0.3.1/SupportSDKPreview.xcframework.zip", checksum: "f3dcce2855ecbdd72dd10141ec8f8a25ee8d7d4f9bdf35391232efeb227ab38e")])
