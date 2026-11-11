// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "SupportSDKPreview", platforms: [.iOS(.v17)],
    products: [.library(name: "SupportSDK", targets: ["SupportSDK"])],
    targets: [.binaryTarget(name: "SupportSDK", url: "https://github.com/gabruini/supportsdk-ios-dist/releases/download/0.3.0/SupportSDKPreview.xcframework.zip", checksum: "6a265857574930a84d29508e837ad24b5bec98daf55e2eb038d2d74d25a9cea7")])
