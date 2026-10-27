// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "SupportSDKPreview", platforms: [.iOS(.v17)],
    products: [.library(name: "SupportSDK", targets: ["SupportSDK"])],
    targets: [.binaryTarget(name: "SupportSDK", url: "https://github.com/gabruini/supportsdk-ios-dist/releases/download/0.1.3/SupportSDKPreview.xcframework.zip", checksum: "18b076919e0adf1ba7d65e563bed7a209acf363d6163ffe393235f8a76886b03")])
